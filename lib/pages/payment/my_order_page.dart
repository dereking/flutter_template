import 'package:flutter/material.dart';
import 'package:flutter_template/services/stripe_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config.dart';
import '../../l10n/app_localizations.dart';
import '../../models/finance/app_order.dart';
import '../../providers/user_provider.dart';
import '../../services/backend_service.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  // Future _loadMyOrder;
  List<AppOrder>? orders;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadMyOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.myOrder)),
      body: Column(
        children: [
          _buildProductInfo(),
          if (error != null) _buildErrorWidget(),
          if (orders == null) Center(child: CircularProgressIndicator()),
          if (orders != null && orders!.isNotEmpty)
            Expanded(child: _buildOrdersList()),
          _buildGoToPlansButton(),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Text("Product ID: $stripeProductId"),
        Text("User Name: ${userProvider.userSession?.name}"),
        Text("User Email: ${userProvider.userSession?.email}"),
        Text("User ID: ${userProvider.userSession?.userId}"),
        // Text("Plan ID: $stripePlanId"),
      ],
    );
  }

  Widget _buildGoToPlansButton() {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      margin: EdgeInsets.all(20),
      child: (userProvider.financeStat?.isSubscribed == true)
          ? Text(AppLocalizations.of(context)!.vip)
          : TextButton(
              onPressed: () {
                userProvider.navigateTo("/plans");
              },
              child: Text(AppLocalizations.of(context)!.upgradePlan),
            ),
    );
  }

  Widget _buildOrdersList() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: orders!.map((order) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart),
                        Text("${order.total_price / 100} ${order.currency}"),
                      ],
                    ),
                    Text(
                      DateFormat(
                        'yyyy-MM-dd HH:mm:ss',
                      ).format(order.ctime.toLocal()),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        children: [
          Text("Product ID: $stripeProductId"),
          SizedBox(height: 200),
          Text(error!),
          TextButton(
            onPressed: () {
              _loadMyOrders();
            },
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Future<void> _loadMyOrders() async {
    try {
      setState(() {
        error = null;
        orders = null;
      });

      final ret = await StripeService().getMyOrdersOfProduct(
        await BackendService.instance.token ?? "",
        stripeProductId,
      );
      setState(() {
        orders = ret;
      });
    } catch (e) {
      setState(() {
        orders = [];
        error = e.toString();
      });
    }
  }
}
