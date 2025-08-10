import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../services/stripe_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;

  String? _productId;
  String? _priceId;
  String? _planId;

  @override
  void initState() {
    super.initState();
    final pro = Provider.of<UserProvider>(context, listen: false);
    _productId = pro.toBuyProductId;
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

  Future<void> _startPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // await _checkoutService.launchCheckoutPage(
      //   priceId: _priceId,
      //   context: context,
      // );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}
