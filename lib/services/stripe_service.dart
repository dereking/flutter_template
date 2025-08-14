import 'dart:convert';

import 'package:flutter_template/models/stripe/checkout_session_create_res.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../config.dart';
import '../logger.dart';
import '../models/stripe/checkout_session.dart';
import '../models/stripe/payment_websocket_message.dart';
import '../models/stripe/price.dart';
import '../models/stripe/product.dart';

class StripeService {
  // 单例实例
  static StripeService? _instance;
  // 私有构造函数
  StripeService._();

  // 获取单例实例
  static StripeService get instance {
    _instance ??= StripeService._();
    return _instance!;
  }

  factory StripeService() {
    _instance ??= StripeService._();
    return _instance!;
  }

  // 初始化Stripe
  Future<void> init() async {
    // Stripe.publishableKey = stripePublishableKey;
    // Stripe.merchantIdentifier = stripeMerchantIdentifier;
    // Stripe.setReturnUrlSchemeOnAndroid = true;

    // await Stripe.instance.applySettings();
  }

  Future<Product?> getProduct(String token, String productId) async {
    print("getProduct: $stripeBaseUrl/info/product/$productId");

    final response = await http.get(
      Uri.parse('$stripeMyHostBaseUrl/info/product/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    logger.d("getProduct ${response.statusCode}, ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      logger.d("getPrice data=$data");

      final product = Product.fromJson(data as Map<String, dynamic>);
      // final price = serializers.deserializeWith<Price>(Price.serializer, json.decode(response.body));
      print("getProduct: $product");
      return product;
    } else {
      throw Exception('Failed to getProduct');
    }
  }

  Future<Price?> getPrice(String token, String priceId) async {
    print("getPrice: $stripeMyHostBaseUrl/info/price/$priceId");

    final response = await http.get(
      Uri.parse('$stripeMyHostBaseUrl/info/price/$priceId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    logger.d("getPrice ${response.statusCode}, ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      logger.d("getPrice data=$data");

      final price = Price.fromJson(data as Map<String, dynamic>);
      // final price = serializers.deserializeWith<Price>(Price.serializer, json.decode(response.body));
      print("getPrice: $price");
      return price;
    } else {
      throw Exception('Failed to load price ');
    }
  }

  Future<String> getCheckoutSessionStatus(
    String token,
    String sessionId,
  ) async { 

    final response = await http.get(
      Uri.parse('$stripeMyHostBaseUrl/stripe/session_status/$sessionId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    // logger.d(
    //   "getCheckoutSessionStatus ${response.statusCode}, ${response.body}",
    // );

    if (response.statusCode == 200) {
      final status = json.decode(response.body)['status'];
      // logger.d("getCheckoutSessionStatus status=$status");

      return status;
    } else {
      throw Exception('Failed to getCheckoutSessionStatus ');
    }
  }

  Future<CheckoutSessionCreateRes?> createCheckoutSession(
    String token,
    String email,
    String clientReferenceId,
    String priceId,
    String priceType,
    int quantity,
  ) async {
    String mode = (priceType == 'one_time') ? "payment" : "recurring";

    final response = await http.put(
      Uri.parse(
        "$stripeMyHostBaseUrl/stripe/session/$email/$clientReferenceId/$priceId/$mode/$quantity",
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    logger.d(
      "createCheckoutSession:$stripeMyHostBaseUrl/stripe/session/$email/$clientReferenceId/$priceId/$mode/$quantity ${response.body}",
    );

    if (response.statusCode == 200) {
      final session = CheckoutSessionCreateRes.fromJson(json.decode(response.body));
      logger.d("createCheckoutSession: $session");


      return session;
    } else {
      logger.e("createCheckoutSession: ${response.body}");
      return null;
    }
  }

  WebSocketChannel createPaymentWebSocketChannel(
    String referenceId,
    void Function(PaymentWebsocketMessage) onData,
  ) {
    // 建立 WebSocket 连接
    final channel = WebSocketChannel.connect(
      Uri.parse("$stripeMyHostBaseUrl/stripe/websocket/$referenceId"),
    );

    // 监听消息
    channel.stream.listen((dat) {
      final message = PaymentWebsocketMessage.fromJson(json.decode(dat));
      onData(message);
    });

    return channel;
  }

}
