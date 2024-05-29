import 'package:flutter/material.dart';
import 'package:kanemaonline/api/live_events_api.dart';

class LiveEventsProvider with ChangeNotifier {
  List _events = [];
  List get events => _events;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getAllLiveEvents() async {
    _isLoading = true;
    notifyListeners();

    List eventsList = await LiveEventsAPI.getAllTrending();

    eventsList
        .removeWhere((element) => element['status']['visibility'] == false);
    _events = eventsList;
    _isLoading = false;
    notifyListeners();
  }

  void init() async {
    getAllLiveEvents();
  }
}
