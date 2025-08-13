class CheckoutSession {
  final String id;
  final String url;

  CheckoutSession({required this.id, required this.url});

  factory CheckoutSession.fromJson(Map<String, dynamic> json) {
    return CheckoutSession(
      id: json['id']??'',
      url: json['url']??'',
    );
  }
 

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
  

  @override
  String toString() {
    return 'CheckoutSession{id: $id, url: $url}';
  }
}
