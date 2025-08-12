import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config.dart';
import '../../providers/user_provider.dart';
import '../../services/stripe_service.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Plans"),
        Row(
          children: stripeProducts.entries.map((e) {
            return _buildPlanWidget(
              e.key,
              e.value['name']!,
              e.value['price']!,
              () {
                final pro = Provider.of<UserProvider>(context, listen: false);
                pro.toBuyPriceId = e.key;
                pro.navigateTo("/payment" );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPlanWidget(
    String productId,
    String planName,
    String price,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(12),

      child: Column(
        children: [
          Text(planName),
          Text(price),
          TextButton(onPressed: onPressed, child: Text("Buy")),
        ],
      ),
    );
  }
}
