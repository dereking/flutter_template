import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;

import '../../services/stripe_service.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  Future<void> handlePayment(BuildContext context) async {
    try {
      await StripeService().createSubscription('monthly', 'pm_card_visa');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('支付成功')));
    } catch (e) {
      print('支付失败: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('支付失败')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('支付金额: 100元 人民币'),
            const Text('支付方式:  stripe'),

            ElevatedButton(
              onPressed: () => handlePayment(context),
              child: Text('支付'),
            ),
          ],
        ),
      ),
    );
  }
}
