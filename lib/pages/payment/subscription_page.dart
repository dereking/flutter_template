import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/user_provider.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      child: (userProvider.financeStat?.isSubscribed == true)
          ? Text(AppLocalizations.of(context)!.vip)
          : TextButton(
              onPressed: () {
                userProvider.navigateTo("/subscriptionScreen");
              },
              child: Text(AppLocalizations.of(context)!.subscribe),
            ),
    );
  }
}
