import 'package:flutter/foundation.dart';
import 'dart:async';

class DebouncerHelper {
  VoidCallback action;
  static Timer _timer;

  static run(VoidCallback action, {int milliseconds: 500}) {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}