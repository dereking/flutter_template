import 'dart:convert';
 
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 
  

import '../config.dart';
import '../models/stripe/price.dart';

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

  Future<Price?> getPrice(String priceId) async {
    print("getPrice: $stripeBaseUrl/price/$priceId");
    final response = await http.get(
      Uri.parse('$stripeMyHostBaseUrl/price/$priceId'),
    );
    if (response.statusCode == 200) {
      final price = Price.fromJson(json.decode(response.body));
      // final price = serializers.deserializeWith<Price>(Price.serializer, json.decode(response.body));
      print("getPrice: $price");
      return price;
    } else {
      throw Exception('Failed to load price');
    }
  }

  // 检查用户是否已订阅
  Future<bool> checkSubscriptionStatus() async {
    ///TODO:
    return true;
    // // final prefs = await SharedPreferences.getInstance();
    // final expiryDate = prefs.getString('subscription_expiry');

    // if (expiryDate == null) return false;

    // return DateTime.parse(expiryDate).isAfter(DateTime.now());
  }

  // 创建订阅
  Future<void> createSubscription(
    String planType,
    String paymentMethodId,
  ) async {
    try {
      // 1. 在后端创建客户和订阅（实际项目中这部分应在你的服务器上完成）
      print("createSubscription: $stripeMyHostBaseUrl/create-subscription'");
      final response = await http.post(
        Uri.parse('$stripeMyHostBaseUrl/create-subscription'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'planId': stripeProducts[planType]!['price'],
          'paymentMethodId': paymentMethodId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('创建订阅失败: ${response.body}');
      }

      final result = json.decode(response.body);
      print("createSubscription res: ${response.body}");

      // 2. 确认支付（如果需要）
      if (result['requiresAction'] == true) {
        // await Stripe.instance.confirmPaymentSheetPayment();
      }

      // 3. 存储订阅信息
      final prefs = await SharedPreferences.getInstance();
      final expiryDate = planType == 'monthly'
          ? DateTime.now().add(const Duration(days: 30))
          : DateTime.now().add(const Duration(days: 365));

      await prefs.setString(
        'subscription_expiry',
        expiryDate.toIso8601String(),
      );
      await prefs.setString('subscription_plan', planType);
    } catch (e) {
      throw Exception('订阅过程出错: $e');
    }
  }

  // 获取用户当前订阅计划
  Future<String?> getCurrentPlan() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('subscription_plan');
  }

  // 取消订阅
  static Future<void> cancelSubscription() async {
    // 调用后端API取消订阅
    print("cancelSubscription: $stripeMyHostBaseUrl/cancel-subscription'");
    final response = await http.post(
      Uri.parse('$stripeMyHostBaseUrl/cancel-subscription'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('取消订阅失败: ${response.body}');
    }

    // 清除本地订阅信息
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('subscription_expiry');
    await prefs.remove('subscription_plan');
  }

  Future<bool> createPaymentMethod() async {
    // final paymentMethod = await Stripe.instance.createPaymentMethod(
    //   params: PaymentMethodParams.alipay(
    //     paymentMethodData: PaymentMethodDataAlipay(email: 'user@example.com'),
    //   ),
    // );
    return false;
  }

  // // 创建Checkout Session
  // Future<String?> createCheckoutSession({
  //   required String priceId, // 产品价格ID
  //   required String successUrl, // 支付成功后跳转的URL
  //   required String cancelUrl, // 支付取消后跳转的URL
  // }) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/checkout/sessions'),
  //       headers: {
  //         'Authorization': 'Bearer $_stripeSecretKey',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       body: {
  //         'payment_method_types[]': 'card',
  //         'line_items[0][price]': priceId,
  //         'line_items[0][quantity]': '1',
  //         'mode': 'payment',
  //         'success_url': successUrl,
  //         'cancel_url': cancelUrl,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final session = json.decode(response.body);
  //       return session['url']; // 返回托管支付页面的URL
  //     } else {
  //       throw Exception('Failed to create checkout session: ${response.body}');
  //     }
  //   } catch (e) {
  //     debugPrint('Error creating checkout session: $e');
  //     return null;
  //   }
  // }

  // // 启动Stripe托管支付页面
  // Future<void> launchCheckoutPage({
  //   required String priceId,
  //   required BuildContext context,
  // }) async {
  //   // 定义支付成功和取消后的回调URL
  //   // 实际项目中应该使用你的后端URL或深度链接
  //   const String successUrl = 'yourapp://success';
  //   const String cancelUrl = 'yourapp://cancel';

  //   // 创建Checkout Session
  //   final checkoutUrl = await createCheckoutSession(
  //     priceId: priceId,
  //     successUrl: successUrl,
  //     cancelUrl: cancelUrl,
  //   );

  //   if (checkoutUrl != null) {
  //     // 启动支付页面
  //     if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
  //       await launchUrl(
  //         Uri.parse(checkoutUrl),
  //         mode: LaunchMode.externalApplication,
  //       );
  //     } else {
  //       throw Exception('Could not launch $checkoutUrl');
  //     }
  //   }
  // }
}
