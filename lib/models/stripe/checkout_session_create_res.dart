class CheckoutSessionCreateRes {
  final String id;
  final String url;

  CheckoutSessionCreateRes({required this.id, required this.url});

  factory CheckoutSessionCreateRes.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionCreateRes(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url};
  }

  @override
  String toString() {
    return 'CheckoutSessionCreateRes{id: $id, url: $url}';
  }
}
