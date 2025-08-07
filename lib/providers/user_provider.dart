import 'dart:convert';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../services/storage_service.dart';

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

  late Client _client;
  late Account _account;
  late Databases _databases;

  User? _user;
  User? get user => _user;

  // 当前页面
  String _curPage = "/default";
  String get curPage => _curPage;
  set curPage(String page) {
    if (_curPage != page) {
      _curPage = page;
      notifyListeners();
    }
  }

  bool isLoggedIn() {
    return _user != null;
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final User user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return user;
    } catch (e) {
      print("register error $e");
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    if (isLoggedIn()) {
      return _user;
    }

    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      _user = await _account.get();
      notifyListeners();
      return _user;
    } catch (e) {
      print("login error $e");
      return null;
    }
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

  Future<bool> logout() async {
    await _account.deleteSession(sessionId: 'current');
    _user = null;
    notifyListeners();
    return true;
  }

  // 内置命令目录
  String _builtinBinDir = "";
  String get builtinCommandDir {
    if (_builtinBinDir == "") {
      throw Exception("UserProvider not initialized");
    }
    return _builtinBinDir;
  }

  // 初始化
  Future<bool> load() async {
    try {
      _client = Client()
          .setEndpoint('https://syd.cloud.appwrite.io/v1') // Your API Endpoint
          .setProject('6891b9060006d7ea6d47');
      _account = Account(_client);
      _databases = Databases(_client);
      

      _user = await _account.get();

      // _builtinBinDir = await fetchBuiltinBinPath();

      // _appWriteClient = Client()
      //     .setEndpoint("https://syd.cloud.appwrite.io/v1")
      //     .setProject("6884684c000f9730f89c");
      // _account = Account(_appWriteClient!);

      // user = await StorageService.instance.loadUserInfo();

      // token = await StorageService().get<String>("token", "");

      notifyListeners();
    } catch (e) {
      debugPrint("UserProvider load error: $e");
      return false;
    }
    return true;
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

      final session = await _account.getSession(sessionId: sessionId);
      _client.setSession(session);
      // userId = session.userId;
      // loggedInUser = await _account.get();
      return {'success': true, 'message': '登录成功'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
