class PaymentWebsocketMessage {
  String type;
  String data;

  PaymentWebsocketMessage({
    required this.type,
    required this.data,
  });

  factory PaymentWebsocketMessage.fromJson(Map<String, dynamic> json) {
    return PaymentWebsocketMessage(
      type: json['type'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data': data,
    };
  }
}
