import 'package:flutter/foundation.dart';

void debug(dynamic msg) {
  if (kDebugMode) {
    print(msg);
  }
}
