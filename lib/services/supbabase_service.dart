import '/models/user_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config.dart';
import '../logger.dart';
import '../models/finance/finance_stat.dart';
import 'backend_service.dart';

class SupabaseService implements BackendService {
  late SupabaseClient _supabase;

  // 同步登录状态
  @override
  Future<UserSession?> syncSession() async {
    try {
      return loadSessionFromSupabase();
    } catch (e) {
      return null;
    }
  }

  UserSession? loadSessionFromSupabase() {
    if (_supabase.auth.currentUser == null) {
      return null;
    }
    final ret = fromSupabaseUser(_supabase.auth.currentUser!);
    ret.token = _supabase.auth.currentSession?.accessToken;
    return ret;
  }

  /// 初始化
  @override
  Future<void> init() async {
    logger.i("SupabaseService.init start...");

    // 初始化 Supabase
    await Supabase.initialize(
      url: supabaseUrl, // Supabase 项目 URL
      anonKey: supabaseAnonKey, // Supabase 匿名公钥
    );

    logger.i("SupabaseService.init done");

    _supabase = Supabase.instance.client;
    // 检查是否已登录
    if (_supabase.auth.currentUser != null) {
      return;
    }
  }

  /// 从 Supabase 用户转换为 UserSession
  ///
  /// [user] Supabase 用户
  ///
  /// 返回 UserSession
  UserSession fromSupabaseUser(User user) {
    return UserSession(
      isLoggedIn: true,
      userId: user.id,
      name: user.userMetadata?['name'],
      email: user.email,
      isEmailVerified: user.emailChangeSentAt != null,
      phone: user.phone,
      isPhoneVerified: user.phoneConfirmedAt != null,
      password: "",
      avatar: user.userMetadata?['avatar_url'],
      token: "",
      createdAt: DateTime.parse(user.createdAt),
      updatedAt: DateTime.parse(user.updatedAt ?? ""),
    );
  }

  /// 注册
  @override
  Future<UserSession?> signUp(String email, String password) async {
    final AuthResponse response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('注册失败');
    }

    return await login(email, password);
  }

  /// 登录
  @override
  Future<UserSession?> login(String email, String password) async {
    final AuthResponse response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('登录失败');
    }

    logger.i(response);

    /// 当前用户
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('用户未登录');
    }

    final ret = fromSupabaseUser(user);

    ret.token = _supabase.auth.currentSession?.accessToken;

    return ret;
  }

  /// 注销
  @override
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  // Future<void> addTodo(String title) async {
  //   final supabase = Supabase.instance.client;
  //   final user = supabase.auth.currentUser;

  //   if (user == null) {
  //     throw Exception('用户未登录');
  //   }

  //   final response = await supabase.from('todos').insert({
  //     'user_id': user.id, // 必须有，否则策略会拒绝
  //     'title': title,
  //   });

  //   if (response.isEmpty) {
  //     print('写入失败，可能是策略或字段问题');
  //   } else {
  //     print('写入成功: $response');
  //   }
  // }

  @override
  Future<FinanceStat> loadFinanceStat() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('用户未登录');
    }

    final response = await _supabase
        .from('finance_stat')
        .select()
        .eq('user_id', user.id)
        .single();

    if (response.isEmpty) {
      print('查询失败，可能是策略或字段问题');
    } else {
      print('查询成功: $response');
    }
    return FinanceStat.fromJson(response);
  }
}
