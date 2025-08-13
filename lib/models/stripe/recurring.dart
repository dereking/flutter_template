class Recurring {

  final String interval; // "interval":"month",
  final int intervalCount; // "interval_count":1,
  final String meter; // "meter":"",
  final int trialPeriodDays; // "trial_period_days":0,
  final String usageType; // "usage_type":"licensed"

  Recurring({
    required this.interval,
    required this.intervalCount,
    required this.meter,
    required this.trialPeriodDays,
    required this.usageType,
  });

  factory Recurring.fromJson(Map<String, dynamic> json) {
    return Recurring(
      interval: json['interval'] ?? '',
      intervalCount: json['interval_count'] ?? 0,
      meter: json['meter'] ?? '',
      trialPeriodDays: json['trial_period_days'] ?? 0,
      usageType: json['usage_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interval': interval,
      'interval_count': intervalCount,
      'meter': meter,
      'trial_period_days': trialPeriodDays,
      'usage_type': usageType,
    };
  }
}
