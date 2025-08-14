import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/logger.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/finance/finance_stat.dart';
import '../models/user_session.dart';
import '../services/backend_service.dart';

class UserProvider extends ChangeNotifier {
  // 单例实例
  static UserProvider? _instance;

  // 私有构造函数
  UserProvider._();

  // 获取单例实例
  static UserProvider get instance {
    _instance ??= UserProvider._();
    return _instance!;
  }

  factory UserProvider() {
    _instance ??= UserProvider._();
    return _instance!;
  }

  UserSession? _userSession;
  UserSession? get userSession => _userSession;

  bool get isLoggedIn => _userSession != null;

  FinanceStat? financeStat;

  /// 选中想购买的 priceID
  String? toBuyPriceId;
  String referenceId = "";

  // 当前页面
  String _curPage = "/home";
  String get curPage => _curPage;
  set curPage(String page) {
    if (_curPage != page) {
      _curPage = page;
      notifyListeners();
    }
  }

  // 初始化
  Future<bool> load() async {
    try {
      _userSession = await BackendService.instance.syncSession();

      generateReferenceId();

      notifyListeners();
    } catch (e) {
      debugPrint("UserProvider load error: $e");
      return false;
    }
    return true;
  }

  void generateReferenceId() {
    final t = DateTime.now().millisecondsSinceEpoch;
    referenceId = t.toRadixString(16);
  }

  /// 注册
  Future<UserSession?> signUp(String email, String password) async {
    return await BackendService.instance.signUp(email, password);
  }

  /// 登录
  Future<UserSession?> login(String email, String password) async {
    logger.i("UserProvider.login email: $email, password: $password");

    if (isLoggedIn) {
      logger.i(
        "UserProvider.login already logged in, session: ${_userSession?.email}",
      );
      notifyListeners();
      return _userSession;
    }

    _userSession = await BackendService.instance.login(email, password);
    notifyListeners();
    return _userSession;
  }

  Future<void> logout() async {
    await BackendService.instance.logout();
    _userSession = null;
    notifyListeners();
  }

  //获取 Apple 登录信息
  //后端用 Appwrite Server SDK 创建会话
  //Flutter 端保存 Appwrite 会话或 JWT
  Future<AuthorizationCredentialAppleID?> getAppleCredential() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      //return credential;
      // credential.identityToken; // JWT
      // credential.authorizationCode;
      // credential.userIdentifier;

      return credential;
    } catch (e) {
      print('Apple Sign In failed: $e');
      return null;
    }
  }

  void gotoLogin() {
    navigateTo("/login");
  }

  void navigateTo(String route) {
    curPage = route;
    notifyListeners();
  }

  // 内置命令目录
  String _builtinBinDir = "";
  String get builtinCommandDir {
    if (_builtinBinDir == "") {
      throw Exception("UserProvider not initialized");
    }
    return _builtinBinDir;
  }

  String getAppDir() {
    return builtinCommandDir;
  }

  Future<Map<String, dynamic>> signInWithMicrosoft() async {
    try {
      // TODO: 实现Microsoft登录
      return {'success': true, 'message': '登录成功'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> signInWithApple() async {
    try {
      final credential = await getAppleCredential();
      if (credential == null) {
        return {'success': false, 'message': 'Apple登录失败'};
      }
      //identityToken
      final response = await http.post(
        // Uri.parse('https://appleid.zenkee.com//auth/apple'),
        Uri.parse('http://127.0.0.1:8080//auth/apple'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identityToken': credential.identityToken}),
      );

      // response := AppwriteResponse{
      // 		UserID: userID,
      // 		SessionID: sessionID,
      // 		Status: status,
      // 	}

      // final userId = jsonDecode(response.body)['userId'];
      final sessionId = jsonDecode(response.body)['sessionId'];

      return {'success': true, 'message': '登录成功'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
