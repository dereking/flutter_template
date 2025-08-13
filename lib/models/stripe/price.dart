// {"active":true,"billing_scheme":"per_unit","created":1754880942,"currency":"usd","currency_options":null,"custom_unit_amount":null,"deleted":false,"id":"price_1Rulti19p49AJ7NjYJDigDBL","livemode":false,"lookup_key":"","metadata":{},"nickname":"","object":"price","product":{"active":false,"created":0,"default_price":null,"deleted":false,"description":"","id":"prod_SqSpJvpiP16xQo","images":null,"livemode":false,"marketing_features":null,"metadata":null,"name":"","object":"","package_dimensions":null,"shippable":false,"statement_descriptor":"","tax_code":null,"type":"","unit_label":"","updated":0,"url":""},"recurring":{"interval":"month","interval_count":1,"meter":"","trial_period_days":0,"usage_type":"licensed"},"tax_behavior":"unspecified","tiers":null,"tiers_mode":"","transform_quantity":null,"type":"recurring","unit_amount":199,"unit_amount_decimal":"199"}
import 'product.dart';

import 'recurring.dart';

class Price {
  bool active; //active":true,
  String billing_scheme; // "billing_scheme":"per_unit",
  int created; //"created":1754880942,
  String currency; //"currency":"usd",
  String currency_options; //"currency_options":null,
  String custom_unit_amount; //"custom_unit_amount":null,
  bool deleted; //"deleted":false,
  String id; //"id":"price_1Rulti19p49AJ7NjYJDigDBL",
  bool livemode; //"livemode":false,
  String lookup_key; //"lookup_key":"",
  Map<String, dynamic> metadata; //"metadata":{},
  String nickname; //"nickname":"",
  String object; //"object":"price",
  Product product; //"product":
  Recurring
  recurring; //"recurring":{"interval":"month","interval_count":1,"meter":"","trial_period_days":0,"usage_type":"licensed"},
  String tax_behavior; //"tax_behavior":"unspecified",
  String tiers; //"tiers":null,
  String tiers_mode; //"tiers_mode":"",
  String transform_quantity; //"transform_quantity":null,
  String type; //"type":"recurring","one_time"
  int unit_amount; //"unit_amount":199,
  String unit_amount_decimal; //"unit_amount_decimal":"199"}

  Price({
    required this.active,
    required this.billing_scheme,
    required this.created,
    required this.currency,
    required this.currency_options,
    required this.custom_unit_amount,
    required this.deleted,
    required this.id,
    required this.livemode,
    required this.lookup_key,
    required this.metadata,
    required this.nickname,
    required this.object,
    required this.product,
    required this.recurring,
    required this.tax_behavior,
    required this.tiers,
    required this.tiers_mode,
    required this.transform_quantity,
    required this.type,
    required this.unit_amount,
    required this.unit_amount_decimal,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      active: json['active'] ?? false,
      billing_scheme: json['billing_scheme'] ?? '',
      created: json['created'] ?? 0,
      currency: json['currency'] ?? '',
      currency_options: json['currency_options']?.toString() ?? '',
      custom_unit_amount: json['custom_unit_amount']?.toString() ?? '',
      deleted: json['deleted'] ?? false,
      id: json['id'] ?? '',
      livemode: json['livemode'] ?? false,
      lookup_key: json['lookup_key'] ?? '',
      metadata: json['metadata'] is Map ? json['metadata'] : {},
      nickname: json['nickname'] ?? '',
      object: json['object'] ?? '',
      product: Product.fromJson(json['product'] is Map ? json['product'] : {}),
      recurring: Recurring.fromJson(json['recurring'] is Map ? json['recurring'] : {}),
      tax_behavior: json['tax_behavior'] ?? '',
      tiers: json['tiers']?.toString() ?? '',
      tiers_mode: json['tiers_mode'] ?? '',
      transform_quantity: json['transform_quantity']?.toString() ?? '',
      type: json['type'] ?? '',
      unit_amount: json['unit_amount'] ?? 0,
      unit_amount_decimal: json['unit_amount_decimal']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'billing_scheme': billing_scheme,
      'created': created,
      'currency': currency,
      'currency_options': currency_options,
      'custom_unit_amount': custom_unit_amount,
      'deleted': deleted,
      'id': id,
      'livemode': livemode,
      'lookup_key': lookup_key,
      'metadata': metadata,
      'nickname': nickname,
      'object': object,
      'product': product.toJson(),
      'recurring': recurring.toJson(),
      'tax_behavior': tax_behavior,
      'tiers': tiers,
      'tiers_mode': tiers_mode,
      'transform_quantity': transform_quantity,
      'type': type,
      'unit_amount': unit_amount,
      'unit_amount_decimal': unit_amount_decimal,
    };
  }
}
