//{"description":"","id":"txcd_10202001","name":"","object":""}
class TaxCode {
  final String? description; //{"description":"",
  final String? id; //"id":"txcd_10202001",
  final String? name; //"name":"",
  final Object? object; //"object":""}

  TaxCode({
    required this.description,
    required this.id,
    required this.name,
    required this.object,
  });

  factory TaxCode.fromJson(Map<String, dynamic> json) {
    return TaxCode(
      description: json["description"],
      id: json["id"],
      name: json["name"],
      object: json["object"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "id": id,
      "name": name,
      "object": object,
    };
  }
}
