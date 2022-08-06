class AnalyticsUser {
  AnalyticsUser({
    required this.uid,
  });
  final String uid;

  Map<String, dynamic> toJson() => {
        'uid': uid,
      }..removeWhere((e, dynamic v) => v == null);
}
