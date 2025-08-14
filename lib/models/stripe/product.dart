// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'price.dart';
import 'tax_code.dart';

class Product {
// {"active":true,"created":1754881010,
//"default_price":{"active":true,"billing_scheme":"per_unit","created":1754881010,"currency":"usd",
  //"currency_options":null,"custom_unit_amount":null,"deleted":false,"id":"price_1Ruluo19p49AJ7Nj2kKo6rtW",
  //"livemode":false,"lookup_key":"","metadata":{},"nickname":"","object":"price",
  //"product":{"active":false,"created":0,"default_price":null,"deleted":false,"description":"","id":"prod_SqSqMxYYUdHKY6","images":null,
  //"livemode":false,"marketing_features":null,"metadata":null,"name":"","object":"","package_dimensions":null,
  //"shippable":false,"statement_descriptor":"","tax_code":null,"type":"","unit_label":"","updated":0,"url":""},
  //"recurring":null,"tax_behavior":"unspecified","tiers":null,"tiers_mode":"",
  //"transform_quantity":null,"type":"one_time",
  //"unit_amount":4990,"unit_amount_decimal":"4990"},
//"deleted":false,"description":"A demo for zenkee, permanent","id":"prod_SqSqMxYYUdHKY6","images":[],"livemode":false,
//"marketing_features":[],"metadata":{},
//"name":"Zenkee Demo APP Permanent","object":"product","package_dimensions":null,
//"shippable":false,"statement_descriptor":"","tax_code":{"description":"","id":"txcd_10202001","name":"","object":""},"type":"service","unit_label":"","updated":1754890829,"url":""}
  final bool active; // "active":false,
  final int created;// "created":0,
  final Price? defaultPrice; // "default_price":null,
  final bool deleted; // "deleted":false,
  final String description; // "description":"",
  final String? id; // "id":"prod_SqSpJvpiP16xQo",
  final List<String>? images; // "images":null,
  final bool livemode; // "livemode":false,
  final List<String>? marketingFeatures; // "marketing_features":null,
  final Map<String, dynamic>? metadata; // "metadata":null,
  final String name; // "name":"",
  final String object; // "object":"",
  // final PackageDimensions? packageDimensions; // "package_dimensions":null,
  final bool shippable; // "shippable":false,
  final String? statementDescriptor; // "statement_descriptor":"",
  final TaxCode? taxCode; // "tax_code":null,
  final String type; // "type":"",
  final String? unitLabel; // "unit_label":"",
  final int updated; // "updated":0,
  final String? url; // "url":"" 
 
//
  Product({
    required this.active,
    this.defaultPrice,
    required this.deleted,
    required this.description,
    this.id,
    this.images,
    required this.livemode,
    this.marketingFeatures,
    this.metadata,
    required this.name,
    required this.object,
    // this.packageDimensions,
    required this.shippable,
    this.statementDescriptor,
    this.taxCode,
    required this.type,
    this.unitLabel,
    required this.created,
    required this.updated,
    this.url,
  });
 
 //{"active":true,"created":1754881010,"default_price":{"active":true,"billing_scheme":"per_unit","created":1754881010,"currency":"usd","currency_options":null,"custom_unit_amount":null,"deleted":false,"id":"price_1Ruluo19p49AJ7Nj2kKo6rtW","livemode":false,"lookup_key":"","metadata":{},"nickname":"","object":"price","product":{"active":false,"created":0,"default_price":null,"deleted":false,"description":"","id":"prod_SqSqMxYYUdHKY6","images":null,"livemode":false,"marketing_features":null,"metadata":null,"name":"","object":"","package_dimensions":null,"shippable":false,"statement_descriptor":"","tax_code":null,"type":"","unit_label":"","updated":0,"url":""},"recurring":null,"tax_behavior":"unspecified","tiers":null,"tiers_mode":"","transform_quantity":null,"type":"one_time","unit_amount":4990,"unit_amount_decimal":"4990"},"deleted":false,"description":"A demo for zenkee, permanent","id":"prod_SqSqMxYYUdHKY6","images":[],"livemode":false,"marketing_features":[],"metadata":{},"name":"Zenkee Demo APP Permanent","object":"product","package_dimensions":null,"shippable":false,"statement_descriptor":"","tax_code":{"description":"","id":"txcd_10202001","name":"","object":""},"type":"service","unit_label":"","updated":1754890829,"url":""}
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      active: json['active'] ?? false,
      defaultPrice: json['default_price'] != null ? Price.fromJson(json['default_price']) : null,
      deleted: json['deleted'] ?? false,
      description: json['description'] ?? '',
      id: json['id'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      livemode: json['livemode'] ?? false,
      marketingFeatures: json['marketing_features'] != null ? List<String>.from(json['marketing_features']) : null,
      metadata: json['metadata'],
      name: json['name'] ?? '',
      object: json['object'] ?? '',
      // packageDimensions: json['package_dimensions'],
      shippable: json['shippable'] ?? false,
      statementDescriptor: json['statement_descriptor'],
      taxCode: json['tax_code']!=null ? TaxCode.fromJson(json['tax_code']): null,
      type: json['type'] ?? '',
      unitLabel: json['unit_label'],
      created: json['created'] ?? 0,
      updated: json['updated'] ?? 0,
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'default_price': defaultPrice,
      'deleted': deleted,
      'description': description,
      'id': id,
      'images': images,
      'livemode': livemode,
      'marketing_features': marketingFeatures,
      'metadata': metadata,
      'name': name,
      'object': object,
      // 'package_dimensions': packageDimensions,
      'shippable': shippable,
      'statement_descriptor': statementDescriptor,
      'tax_code': taxCode?.toJson(),
      'type': type,
      'unit_label': unitLabel,
      'created': created,
      'updated': updated,
      'url': url,
    };
  }
}
