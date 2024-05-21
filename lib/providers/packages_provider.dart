import 'package:flutter/material.dart';
import 'package:kanemaonline/api/packages_api.dart';

class PackagesProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List _packages = [];
  List get packages => _packages;

  void getPackages() async {
    _isLoading = true;
    notifyListeners();

    _packages = await PackagesAPI.getAllPackages();

    _isLoading = false;
    notifyListeners();
  }
}
