class AppOrder {
  String name;
  String email;
  String local;
  String stripe_checkout_session;
  String stripe_payment_intent;
  String sn;
  String pid;
  int count;

  int unit_price;
  String currency;
  int total_price;
  DateTime ctime;
  DateTime mtime;
  String uid;

  AppOrder({
    required this.name,
    required this.uid,
    required this.count,
    required this.currency,
    required this.email,
    required this.local,
    required this.sn,
    required this.pid,
    required this.unit_price,
    required this.total_price,
    required this.stripe_checkout_session,
    required this.stripe_payment_intent,
    required this.ctime,
    required this.mtime,
  });

  factory AppOrder.fromJson(Map<String, dynamic> json) {
    return AppOrder(
      name: json['name'] ?? "",
      uid: json['uid'] ?? "",
      count: json['count'] ?? 0,
      currency: json['currency'] ?? "",
      email: json['email'] ?? "",
      local: json['local'] ?? "",
      sn: json['sn'] ?? "",
      pid: json['pid'] ?? "",
      unit_price: json['unit_price'] ?? 0,
      total_price: json['total_price'] ?? 0,
      stripe_checkout_session: json['stripe_checkout_session'] ?? "",
      stripe_payment_intent: json['stripe_payment_intent'] ?? "",
      ctime: DateTime.parse(json['ctime'] ?? ""),
      mtime: DateTime.parse(json['mtime'] ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "uid": uid,
      "count": count,
      "currency": currency,
      "email": email,
      "local": local,
      "sn": sn,
      "pid": pid,
      "unit_price": unit_price,
      "total_price": total_price,
      "stripe_checkout_session": stripe_checkout_session,
      "ctime": ctime.toIso8601String(),
      "mtime": mtime.toIso8601String(),
    };
  }
}
