import 'package:flutter/cupertino.dart';
import 'package:kanemaonline/api/trending_api.dart';

class TrendingProvider extends ChangeNotifier {
  List _trends = [];
  List get trends => _trends;

  final bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getAllTrends() async {
    _trends = await TrendingAPI.getAllTrending();
    notifyListeners();
  }
}
