import 'camel_case_to_words.dart';

String? enumToString(dynamic enumItem, {bool camelCase = false}) {
  if (enumItem == null) {
    return null;
  }
  assert(isEnumItem(enumItem),
      '$enumItem of type ${enumItem.runtimeType.toString()} is not an enum item');
  final _tmp = enumItem.toString().split('.')[1];
  return !camelCase ? _tmp : camelCaseToWords(_tmp);
}

T? enumFromString<T>(List<T> enumValues, String value,
    {bool camelCase = false}) {
  try {
    return enumValues.singleWhere((enumItem) =>
        convertToString(enumItem, camelCase: camelCase)?.toLowerCase() ==
        value.toLowerCase());
  } catch (_) {
    return null;
  }
}

String? convertToString(dynamic enumItem, {bool camelCase = false}) {
  if (enumItem == null) {
    return null;
  }
  assert(isEnumItem(enumItem),
      '$enumItem of type ${enumItem.runtimeType.toString()} is not an enum item');
  final _tmp = enumItem.toString().split('.')[1];
  return !camelCase ? _tmp : camelCaseToWords(_tmp);
}

bool isEnumItem(enumItem) {
  final splitEnum = enumItem.toString().split('.');
  return splitEnum.length > 1 &&
      splitEnum[0] == enumItem.runtimeType.toString();
}
