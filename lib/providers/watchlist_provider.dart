import 'package:flutter/material.dart';
import 'package:kanemaonline/api/mylist_api.dart';
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:provider/provider.dart';

class WatchListProvider with ChangeNotifier {
  bool _isListLoading = false;
  bool get isListLoading => _isListLoading;

  List<dynamic> _watchList = [];
  List<dynamic> get myList => _watchList;

  init() async {
    _isListLoading = true;
    notifyListeners();

    List cloudList = Provider.of<UserInfoProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).userData['message'][0]['watch_list'];
    var contents = [];
    for (var element in cloudList) {
      if (element != "") {
        var content = await MyListAPI().getItemByID(id: element.toString());
        if (content != {}) {
          contents.add(content);
        }
      }
    }

    _watchList = contents;
    _isListLoading = false;
    notifyListeners();
  }
}
