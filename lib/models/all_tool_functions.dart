

/// 将Map中指定类型的值提取出来
T? mapValueOfType<T>(Map<String, dynamic> json, String key) {
  if (!json.containsKey(key)) return null;
  var value = json[key];
  if (value is T) return value;
  return null;
}


/// 深度比较两个对象是否相等
bool deepEquals<T>(T? obj1, T? obj2) {
  // 如果两个对象引用相同，则相等
  if (identical(obj1, obj2)) return true;
  
  // 如果其中一个为null，另一个不为null，则不相等
  if (obj1 == null || obj2 == null) return false;

  // 如果是基本类型，直接比较
  if (obj1 is num || obj1 is String || obj1 is bool) {
    return obj1 == obj2;
  }

  // 如果是List类型
  if (obj1 is List && obj2 is List) {
    if (obj1.length != obj2.length) return false;
    for (var i = 0; i < obj1.length; i++) {
      if (!deepEquals(obj1[i], obj2[i])) return false;
    }
    return true;
  }

  // 如果是Map类型
  if (obj1 is Map && obj2 is Map) {
    if (obj1.length != obj2.length) return false;
    for (var key in obj1.keys) {
      if (!obj2.containsKey(key)) return false;
      if (!deepEquals(obj1[key], obj2[key])) return false;
    }
    return true;
  }

  // 其他情况使用默认相等比较
  return obj1 == obj2;
}


/// 将Map中指定类型的键值对提取到新Map中
Map<K, V> mapCastOfType<K, V>(Map<String, dynamic> json, String key) {
  if (!json.containsKey(key)) return {};
  
  final value = json[key];
  if (value is! Map) return {};
  
  final Map<K, V> result = {};
  value.forEach((k, v) {
    if (k is K && v is V) {
      result[k] = v;
    }
  });
  
  return result;
}


//TODO:
enum AvailablePayoutMethodsEnum {
  bankTransfer,
  card,
  fpx,
  giropay,
  ideal,
  klarna,
  multibanco,
  p24,
  sepaDebit,
  sofort,
  threeDSecure,
  wechat,
}

enum SubscriptionDefaultSourceAvailablePayoutMethodsEnum {
  bankTransfer,
  card,
  fpx,
  giropay,
  ideal,
  klarna,
  multibanco,
  p24,
  sepaDebit,
  sofort,
  threeDSecure,
  wechat,
}