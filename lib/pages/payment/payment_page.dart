import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logger.dart';
import '../../models/stripe/price.dart';
import '../../providers/user_provider.dart';
import '../../services/stripe_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;

  Future<Price?>? _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _loadData();
  }

  Future<Price?> _loadData() async {
    final pro = Provider.of<UserProvider>(context, listen: false);
    final priceId = pro.toBuyPriceId;

    logger.d("${pro.userSession?.email},  ${pro.userSession?.token}");

    return await StripeService().getPrice(
      context.read<UserProvider>().userSession?.token ?? '',
      priceId!,
    );
  }

  void _reloadData() {
    setState(() {
      // 创建一个新的 Future 对象
      _futureData = _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<UserProvider>(context, listen: false);
    if (pro.userSession == null) {
      return Center(child: Text('请先登录'));
    }
    return FutureBuilder<Price?>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Text('Error: ${snapshot.error}'),
                Text('请联系管理员'),
                Text('管理员邮箱: support@example.com'),
                IconButton(
                  onPressed: () {
                    _reloadData();
                  },
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
          );
        } else {
          final price = snapshot.data;
          if (price == null) {
            return Center(child: Text('Price not found'));
          }
          return Center(
            child: Card(
              margin: const EdgeInsets.all(16),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('支付金额: ${price.unit_amount} 人民币'),
                  const Text('支付方式: stripe'),

                  ElevatedButton(
                    onPressed: () => handlePayment(context, price),
                    child: Text('支付'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> handlePayment(BuildContext context, Price price) async {
    try {
      final pro = Provider.of<UserProvider>(context, listen: false);
      final session = await StripeService().createCheckoutSession(
        pro.userSession?.token ?? '',
        pro.userSession?.email ?? '',
        pro.referenceId,
        //  pro.reference!,
        price.id,
        price.type,
        1,
      );

      if (session != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('支付成功')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('支付失败')));
      }
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
