class UserSession {
  bool isLoggedIn;

  String? userId;
  String? name;
  String? email;
  bool? isEmailVerified;
  String? phone;
  bool? isPhoneVerified;
  String? password;

  String? avatar;

  DateTime? createdAt;
  DateTime? updatedAt;

  String? token;

  UserSession({
    this.isLoggedIn = false,
    this.userId,
    this.name,
    this.email,
    this.isEmailVerified,
    this.phone,
    this.isPhoneVerified,
    this.password,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.token,
  });
 

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      isLoggedIn: json['isLoggedIn'],
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      isEmailVerified: json['isEmailVerified'],
      phone: json['phone'],
      isPhoneVerified: json['isPhoneVerified'],
      password: json['password'],
      avatar: json['avatar'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson(UserSession userSession) {
    return {
      'isLoggedIn': userSession.isLoggedIn,
      'userId': userSession.userId,
      'name': userSession.name,
      'email': userSession.email,
      'isEmailVerified': userSession.isEmailVerified,
      'phone': userSession.phone,
      'isPhoneVerified': userSession.isPhoneVerified,
      'password': userSession.password,
      'avatar': userSession.avatar,
      'createdAt': userSession.createdAt?.toIso8601String(),
      'updatedAt': userSession.updatedAt?.toIso8601String(),
      'token': userSession.token,
    };
  }

}
