import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

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

  // 订阅计划ID（在Stripe控制台中创建）
  static const Map<String, String> _plans = {
    'monthly': 'price_1Nxxxxxxxxx', // 月度订阅价格ID
    'yearly': 'price_1Oyyyyyyyyy', // 年度订阅价格ID
  };

  // 初始化Stripe
  Future<void> init() async {
    Stripe.publishableKey = stripePublishableKey;
    await Stripe.instance.applySettings();
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
          'planId': _plans[planType],
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
        await Stripe.instance.confirmPaymentSheetPayment();
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
}
