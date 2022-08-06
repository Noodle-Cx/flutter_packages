import 'package:flutter/foundation.dart';

void safeLog(dynamic message) {
  if (!kReleaseMode) {
    print(message?.toString());
  }
}
