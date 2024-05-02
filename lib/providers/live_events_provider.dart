import 'package:flutter/material.dart';
import 'package:kanemaonline/api/live_events_api.dart';

class LiveEventsProvider with ChangeNotifier {
  List events = [];
  List get tvs => events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getAllLiveEvents() async {
    _isLoading = true;
    notifyListeners();

    events = await LiveEventsAPI.getAllTrending();

    _isLoading = false;
    notifyListeners();
  }

  void init() async {
    getAllLiveEvents();
  }
}
