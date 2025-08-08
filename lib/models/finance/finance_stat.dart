import 'finance_activity.dart';

class FinanceStat {
  bool isSubscribed;
  String? currentPlan;

  final int balance; // 余额  最小单位分。
  int income; // 收入 最小单位分。
  int expense; // 支出 最小单位分。

  final List<FinanceActivity> logs;

  FinanceStat({
    this.isSubscribed = false,
    this.currentPlan,
    required this.balance,
    required this.income,
    required this.expense,
    this.logs = const [],
  });

  factory FinanceStat.fromJson(Map<String, dynamic> json) {
    return FinanceStat(
      isSubscribed: json['isSubscribed'],
      currentPlan: json['currentPlan'],
      balance: json['balance'],
      income: json['income'],
      expense: json['expense'],
      logs:
          json['logs']?.map((e) => FinanceActivity.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSubscribed': isSubscribed,
      'currentPlan': currentPlan,
      'balance': balance,
      'income': income,
      'expense': expense,
      'logs': logs.map((e) => e.toJson()).toList(),
    };
  }

  void addLog(FinanceActivity log) {
    logs.add(log);
    if (log.type == 1) {
      income += log.amount;
    } else {
      expense += log.amount;
    }
  }
}
