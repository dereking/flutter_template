import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentPage extends StatelessWidget {
  final String clientSecret;

  const PaymentPage({super.key, required this.clientSecret});

  Future<void> handlePayment(BuildContext context) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your App Name',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('支付成功')),
      );
    } catch (e) {
      print('支付失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('支付失败')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => handlePayment(context),
        child: Text('支付'),
      ),
    );
  }
}