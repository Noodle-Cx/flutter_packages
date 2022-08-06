import '../exception/noodle_exception.dart';
import 'analytics_user.dart';
import 'analytics_event.dart';

abstract class AnalyticsProvider {
  Future logout();

  Future setLoggedUser(AnalyticsUser user);

  Future logScreen(String screenName);

  Future logEvent(AnalyticsEvent event);

  Future logException(NoodleException exception);
}
