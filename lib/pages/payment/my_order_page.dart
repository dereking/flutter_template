import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/finance/app_order.dart';
import '../../providers/user_provider.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {

  // Future _loadMyOrder;
  AppOrder? order;
  


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: (userProvider.financeStat?.isSubscribed == true)
          ? Text(AppLocalizations.of(context)!.vip)
          : TextButton(
              onPressed: () {
                userProvider.navigateTo("/plans");
              },
              child: Text(AppLocalizations.of(context)!.subscribe),
            ),
    );
  }
}
