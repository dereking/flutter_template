import 'package:flutter/material.dart';

import '../../models/finance/finance_stat.dart';
import '../../services/supbabase_service.dart';

class FinanceProvider extends ChangeNotifier {
  FinanceProvider();

  final FinanceStat _financeStat = FinanceStat(
    balance: 0,
    income: 0,
    expense: 0,
  ); // 余额

  FinanceStat get financeStat => _financeStat;

  Future<bool> load() async {
    return true;
  }
}
