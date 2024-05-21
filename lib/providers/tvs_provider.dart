import 'package:flutter/material.dart';
import 'package:kanemaonline/api/tvs_api.dart';

class TVsProvider with ChangeNotifier {
  List _tvs = [];
  List get tvs => _tvs;

  List _trends = [];
  List get trends => _trends;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getAllTVs() async {
    _isLoading = true;
    notifyListeners();

    _tvs = await TvsAPI.getAllTVs();

    _isLoading = false;
    notifyListeners();
  }

  void getAllTrends() async {
    _trends = await TvsAPI.getAllTrending();
    notifyListeners();
  }

  void init() async {
    getAllTVs();
  }
}
