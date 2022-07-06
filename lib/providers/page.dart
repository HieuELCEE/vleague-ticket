import 'package:flutter/foundation.dart';

class PageProvider with ChangeNotifier {
  int _currPage = 0;

  int get currPage => _currPage;

  set currPage(int value) {
    _currPage = value;
    notifyListeners();
  }
}
