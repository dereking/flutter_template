// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/finance/finance_stat.dart';
import '../../providers/user_provider.dart';

class SubscriptionStatusButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const SubscriptionStatusButton({super.key, this.onPressed});

  @override
  State<SubscriptionStatusButton> createState() =>
      _SubscriptionStatusButtonState();
}

class _SubscriptionStatusButtonState extends State<SubscriptionStatusButton> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return TextButton(
      onPressed: () {
        widget.onPressed?.call();
      },
      child: userProvider.financeStat?.isSubscribed == true
          ? _buildText(userProvider.financeStat!)
          : _buildButton(),
    );
  }

  Widget _buildButton() {
    return Text(AppLocalizations.of(context)!.pricing);
  }

  Widget _buildText(FinanceStat financeStat) {
    return Text(AppLocalizations.of(context)!.vip);
  }
}
