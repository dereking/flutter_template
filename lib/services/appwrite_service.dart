import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_template/config.dart';
import 'package:flutter_template/models/finance/finance_stat.dart';

import '../models/user_session.dart';
import 'backend_service.dart';

class AppwriteService implements BackendService {
  late Client _client;
  late Account _account;
  late Databases _databases;

  // 同步登录状态
  @override
  Future<UserSession?> syncSession() async {
    try {
      final user = await _account.get();
      return fromAppwriteUser(user);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> init() async {
    _client = Client()
        .setEndpoint(appwriteEndpoint) // Your API Endpoint
        .setProject(appwriteProjectId);
    _account = Account(_client);
    // _databases = Databases(_client);
  }

  UserSession? fromAppwriteUser(User u) {
    return UserSession(
      isLoggedIn: true,
      userId: u.$id,
      name: u.name,
      email: u.email,
      isEmailVerified: u.emailVerification,
      avatar: "",
      token: "",
      password: u.password,
      phone: u.phone,
      isPhoneVerified: u.phoneVerification,
      createdAt: DateTime.parse(u.$createdAt),
      updatedAt: DateTime.parse(u.$updatedAt),
    );
  }

  @override
  Future<UserSession?> login(String email, String password) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final _user = await _account.get();

      return fromAppwriteUser(_user);
    } catch (e) {
      print("login error $e");
      return null;
    }
  }

  @override
  Future<UserSession?> signUp(String email, String password) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return login(email, password);
    } catch (e) {
      print("register error $e");
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }

  @override
  Future<FinanceStat?> loadFinanceStat() async {
    try {
      final doc = await _databases.getDocument(
        databaseId: '6891b9060006d7ea6d47',
        collectionId: '6891b9060006d7ea6d47',
        documentId: '6891b9060006d7ea6d47',
      );

      return FinanceStat.fromJson(doc.data);
    } catch (e) {
      print("loadFinanceStat error $e");
    }
  }
}
