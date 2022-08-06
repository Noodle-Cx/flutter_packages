import 'noodle_exception.dart';

abstract class ErrorHandler {
  NoodleException handle(exception);
}
