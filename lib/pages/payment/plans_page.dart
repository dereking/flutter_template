import 'package:flutter/material.dart';

import '../../services/stripe_service.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Plans"),
        Row(
          children: [
            _buildPlanWidget("Basic", "Free"),
            _buildPlanWidget("Pro", "\$9.99"),
            _buildPlanWidget("Enterprise", "\$29.99"),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanWidget(String planName, String price) {
    return Card(
      child: Column(
        children: [
          Text(planName),
          Text(price),
          TextButton(
            onPressed: () async {
              // 购买计划
              // await StripeService.instance.(planName);
            },
            child: Text("Buy"),
          ),
        ],
      ),
    );
  }
}
