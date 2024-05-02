import 'package:flutter/material.dart';
import 'package:kanemaonline/api/vods_api.dart';

class VODsProvider with ChangeNotifier {
  List _vods = [];
  List get vods => _vods;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  void getVods() async {
    _isLoading = true;
    notifyListeners();

    _vods = await VodsAPI.getAllVods();

    _isLoading = false;
    notifyListeners();
  }

  void init() async {
    getVods();
  }

  void setHasError(bool hasErr) {
    _hasError = hasErr;
    notifyListeners();
  }
}
