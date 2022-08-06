import 'package:noodle_utils/noodle_utils.dart';

class AnalyticsEvent {
  AnalyticsEvent({
    required this.eventName,
    this.data,
  });

  String eventName;
  Map<String, Object?>? data;

  AnalyticsEvent.fromJson(Map<String, dynamic> json)
      : eventName = json.getString('eventName'),
        data = json.getValue('data', null);

  Map<String, dynamic> toJson() => {
        'eventName': eventName,
        'data': data,
      }..removeWhere((e, dynamic v) => v == null);

  /// Util method to clone classes
  AnalyticsEvent clone() => AnalyticsEvent.fromJson(toJson());

  /// Util method pass fromJson mapper as a parameter
  static AnalyticsEvent mapper(Map<String, dynamic> map) =>
      AnalyticsEvent.fromJson(map);
}
