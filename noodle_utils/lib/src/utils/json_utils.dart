import 'dart:io';
import 'package:noodle_utils/noodle_utils.dart';

extension JsonUtils on Map<String, dynamic> {
  T getValue<T>(String key, T defaultValue) {
    return jsonSafeValue(this, key, defaultValue);
  }

  T? getNestedValue<T>(List<String> keys) {
    return jsonNestedValue(this, keys);
  }

  String getString(String key) {
    return jsonSafeValue(this, key, '');
  }

  String getStringFromKeys(List<String> keys) {
    String? value;
    for (final key in keys) {
      if (containsKey(key)) {
        value = getString(key);
        break;
      }
    }

    if (value != null) {
      return value;
    }

    return getString(keys[0]);
  }

  File? getFile(String key) {
    try {
      return File(getString(key));
    } catch (_) {
      return null;
    }
  }

  File? getFileFromKeys(List<String> keys) {
    File? value;
    for (var element in keys) {
      if (containsKey(element)) {
        value = getFile(element);
        break;
      }
    }

    return value!;
  }

  int getInt(String key) {
    return jsonSafeValue(this, key, 0);
  }

  int getIntFromKeys(List<String> keys) {
    int? value;
    for (var element in keys) {
      if (containsKey(element)) {
        value = getInt(element);
        break;
      }
    }
    if (value != null) {
      return value;
    }
    return getInt(keys[0]);
  }

  double getDouble(String key) {
    try {
      return double.parse(this[key].toString());
    } catch (_) {
      return 0.0;
    }
  }

  double getDoubleFromKeys(List<String> keys) {
    double? value;
    for (var element in keys) {
      if (containsKey(element)) {
        value = getDouble(element);
        break;
      }
    }
    if (value != null) {
      return value;
    }
    return getDouble(keys[0]);
  }

  bool getBool(String key) {
    return jsonSafeValue(this, key, false);
  }

  bool getBoolFromKeys(List<String> keys) {
    bool? value;
    for (var element in keys) {
      if (containsKey(element)) {
        value = getBool(element);
        break;
      }
    }
    if (value != null) {
      return value;
    }
    return getBool(keys[0]);
  }

  T? getObject<T>(String key, T Function(Map<String, dynamic>) itemMap) {
    return jsonSafeMap(this, key, itemMap);
  }

  T getEnum<T>(String key, T Function(String?) enumMap) {
    return jsonSafeEnum(this, key, enumMap);
  }

  T getEnumFromKeys<T>(List<String> keys, T Function(String?) enumMap) {
    T? value;
    for (var element in keys) {
      if (containsKey(element)) {
        value = jsonSafeEnum(this, element, enumMap);
        break;
      }
    }
    if (value != null) {
      return value;
    }
    return jsonSafeEnum(this, keys[0], enumMap);
  }

  List<T> getList<T>(String key, [T Function(Map<String, dynamic>)? itemMap]) {
    return jsonListValue(this, key, itemMap);
  }

  DateTime? getDate(String key) {
    return jsonDateValue(this, key);
  }

  DateTime? getDateFromKeys(List<String> keys) {
    DateTime? value;
    for (var element in keys) {
      if (containsKey(element)) {
        value = getDate(element);
        break;
      }
    }

    return value;
  }
}

extension ListUtils on List<dynamic> {
  List<T> asList<T>(T Function(Map<String, dynamic>) itemMap) {
    return jsonAsList(this, itemMap);
  }
}

DateTime? jsonDateValue(Map<String, dynamic> json, String key) {
  if (json[key] is int) {
    return DateTime.fromMillisecondsSinceEpoch(json[key], isUtc: true);
  }
  return (json[key] as String?)?.toDate();
}

T jsonSafeValue<T>(Map<String, dynamic> json, String key, T defaultValue) {
  try {
    final value = json[key];
    if (value != null) {
      return value;
    } else {
      return defaultValue;
    }
  } catch (e) {
    return defaultValue;
  }
}

T? jsonSafeMap<T>(Map<String, dynamic> json, String key,
    T Function(Map<String, dynamic>) itemMap) {
  if (json.containsKey(key)) {
    try {
      return itemMap(json[key]);
    } catch (e) {
      return null;
    }
  }
  return null;
}

T jsonSafeEnum<T>(
    Map<String, dynamic> json, String key, T Function(String?) enumMap) {
  try {
    return enumMap(json[key]);
  } catch (e) {
    return enumMap(null);
  }
}

List<T> jsonListValue<T>(Map<String, dynamic> json, String key,
    [T Function(Map<String, dynamic>)? itemMap]) {
  try {
    final list = (json[key] as List<dynamic>)
      ..removeWhere((element) => element == null);

    if (itemMap != null) {
      return list.map((dynamic e) => itemMap(e)).toList();
    }
    return list.map((e) => e as T).toList();
  } catch (e) {
    return [];
  }
}

List<T> jsonAsList<T>(
    List<dynamic> json, T Function(Map<String, dynamic>) itemMap) {
  try {
    return json.map((dynamic e) => itemMap(e)).toList();
  } catch (e) {
    return [];
  }
}

T? jsonNestedValue<T>(Map<String, dynamic> json, List<String> nestedKeys) {
  try {
    if (nestedKeys.length == 1) {
      return json[nestedKeys[0]];
    } else if (nestedKeys.length == 2) {
      return json[nestedKeys[0]][nestedKeys[1]];
    } else if (nestedKeys.length == 3) {
      return json[nestedKeys[0]][nestedKeys[1]][nestedKeys[2]];
    } else if (nestedKeys.length == 4) {
      return json[nestedKeys[0]][nestedKeys[1]][nestedKeys[2]][nestedKeys[3]];
    } else if (nestedKeys.length == 5) {
      return json[nestedKeys[0]][nestedKeys[1]][nestedKeys[2]][nestedKeys[3]]
          [nestedKeys[4]];
    } else {
      safeLog('implements json getJsonValue from ${nestedKeys.length}');
      return null;
    }
  } catch (e) {
    return null;
  }
}
