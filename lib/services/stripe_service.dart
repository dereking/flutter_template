import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../logger.dart';
import '../models/stripe/checkout_session.dart';
import '../models/stripe/price.dart';
import '../models/stripe/product.dart';
import 'package:url_launcher/url_launcher.dart';

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

    if (response.statusCode == 200) {
      final p = Product.fromJson(json.decode(response.body));
      // final price = serializers.deserializeWith<Price>(Price.serializer, json.decode(response.body));
      print("getProduct: $p");
      return p;
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

    logger.d("${response.statusCode}, ${response.body}");

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

  Future<bool> createCheckoutSession(
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
      final session = CheckoutSession.fromJson(json.decode(response.body));
      logger.d("createCheckoutSession: $session");
 
      await launchMyUrl(session.url);

      return true;
    } else {
      logger.e("createCheckoutSession: ${response.body}");
      return false;
    }
  }

  Future<void> launchMyUrl(String payURL) async {
    final Uri url = Uri.parse(payURL);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('无法打开链接: $url');
    }
  }
}
