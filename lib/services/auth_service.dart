 
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Future<AuthLoginPost200Response?> signInWithEmail(
  //     String email, String password) async {
  //   try {
  //     AuthApi authApi = AuthApi(ApiClient(
  //       basePath: SettingsProvider.instance.getAPIBaseUrl(),
  //       authentication: HttpBearerAuth(),
  //     ));

  //     ModelLoginRequest request = ModelLoginRequest(
  //       email: email,
  //       password: password,
  //     );
  //     AuthLoginPost200Response? res = await authApi.authLoginPost(request);

  //     return res;
  //   } catch (e) {
  //     print("login error $e");
  //     return null;
  //   }
  // }

  // Future<AuthRegisterPost200Response?> signUpWithEmail(
  //     String email, String password) async {
  //   try {
  //     AuthApi authApi = AuthApi(ApiClient(
  //       basePath: SettingsProvider.instance.getAPIBaseUrl(),
  //       authentication: HttpBearerAuth(),
  //     ));

  //     ModelRegisterRequest request = ModelRegisterRequest(
  //       email: email,
  //       name: email,
  //       password: password,
  //     );
  //     AuthRegisterPost200Response? res =
  //         await authApi.authRegisterPost(request);

  //     return res;
  //   } catch (e) {
  //     print("register error $e");
  //     return null;
  //   }
  // }

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
      // TODO: 实现 apple 登录
      return {'success': true, 'message': '登录成功'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
