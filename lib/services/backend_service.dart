import '../config.dart';
import '../models/finance/finance_stat.dart';
import '../models/user_session.dart';
import 'appwrite_service.dart';
import 'supbabase_service.dart';

abstract class BackendService {
  // 后端服务实例
  static BackendService? _instance;
  static BackendService get instance {
    if (backend == 'supabase') {
      _instance ??= SupabaseService();
      return _instance!;
    } else {
      _instance ??= AppwriteService();
      return _instance!;
    }
  }
 
  // 同步登录状态
  Future<UserSession?> syncSession();

  //init 初始化
  Future<void> init();

  // user 用户
  Future<UserSession?> login(String email, String password);
  Future<UserSession?> signUp(String email, String password);
  Future<void> logout();

  Future<FinanceStat?> loadFinanceStat();
}
