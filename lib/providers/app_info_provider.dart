import 'dart:io';

 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/storage_service.dart'; 

class AppInfoProvider extends ChangeNotifier {
  // 单例实例
  static AppInfoProvider? _instance;

  // 私有构造函数
  AppInfoProvider._();

  // 获取单例实例
  static AppInfoProvider get instance {
    _instance ??= AppInfoProvider._();
    return _instance!;
  }

  factory AppInfoProvider() {
    _instance ??= AppInfoProvider._();
    return _instance!;
  }
  
  dynamic loggedInUser;

  String? _token = "";
  String? get token {
    return _token;
  }

  set token(String? token) {
    _token = token;
    StorageService.instance.saveToken(token);
    notifyListeners();
  }

  // 当前页面
  String _curPage = "/default";
  String get curPage => _curPage;
  set curPage(String page) {
    if (_curPage != page) {
      _curPage = page;
      notifyListeners();
    }
  }


  // Future<models.User> register(
  //     String email, String password, String name) async {
  //   models.User user = await _account!.create(
  //       userId: ID.unique(), email: email, password: password, name: name);
  //   // await login(email, password);
  //   loggedInUser = user;
  //   return user;
  // }

  // Future<models.Session> login(String email, String password) async {
  //   models.Session session = await _account!
  //       .createEmailPasswordSession(email: email, password: password);
  //   final user = await _account!.get();

  //   loggedInUser = user;

  //   //TODO: 登录
  //   token = "token";
  //   return session;
  // }

  Future<bool> logout() async {
    // await _account!.deleteSession(sessionId: 'current');

    loggedInUser = null;

    // user = null;
    token = null;
    return true;
  }

  // 内置命令目录
  String _builtinBinDir = "";
  String get builtinCommandDir {
    if (_builtinBinDir == "") {
      throw Exception("AppInfoProvider not initialized");
    }
    return _builtinBinDir;
  }

  // 初始化
  Future<bool> load() async {
    try {
      // _builtinBinDir = await fetchBuiltinBinPath();

      // _appWriteClient = Client()
      //     .setEndpoint("https://syd.cloud.appwrite.io/v1")
      //     .setProject("6884684c000f9730f89c");
      // _account = Account(_appWriteClient!);

      // user = await StorageService.instance.loadUserInfo();

      token = await StorageService.instance.loadToken();
 
    } catch (e) {
      debugPrint("AppInfoProvider load error: $e");
      return false;
    }
    notifyListeners();
    return true;
  }

  String getAppDir() {
    return builtinCommandDir;
  }
}
