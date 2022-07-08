import 'package:flutter/foundation.dart';

class ResultCode with ChangeNotifier {
  int _resultCode = 1;

  int get resultCode {
    return _resultCode;
  }

  set resultCode(int value) {
    _resultCode = value;
    notifyListeners();
  }
}