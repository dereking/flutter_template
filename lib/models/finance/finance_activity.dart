class FinanceActivity {
  final int id;
  final int amount; //cent
  final int type; // income: 1 or expense  -1
  final String description;
  final DateTime createdAt;

  FinanceActivity({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  factory FinanceActivity.fromJson(Map<String, dynamic> json) {
    return FinanceActivity(
      id: json['id'],
      amount: json['amount'],
      type: json['type'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
