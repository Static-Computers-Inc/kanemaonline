import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kanemaonline/api/mylist_api.dart';
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyListProvider with ChangeNotifier {
  bool _isListLoading = false;
  bool get isListLoading => _isListLoading;

  List<dynamic> _myList = [];
  List<dynamic> get myList => _myList;

  get trends => null;

  Future<bool> checkIfInMyList({required String name}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedList = prefs.getString("myList") ?? "[]";

    List<dynamic> decodedList = jsonDecode(encodedList) as List<dynamic>;
    bool isInList = decodedList.any((element) => element["name"] == name);

    return isInList;
  }

  void addToMyList({
    required String id,
    required String name,
    required String description,
    required String thumbnail,
    required String mediaUrl,
    required String mediaType,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedList = prefs.getString("myList") ?? "[]";
    List<dynamic> decodedList = jsonDecode(encodedList) as List<dynamic>;

    if (decodedList.any((element) => element["_id"] == id)) {
      return;
    }

    decodedList.add({
      "id": id,
      "name": name,
      "description": description,
      "thumbnail": thumbnail,
      "mediaUrl": mediaUrl,
      "mediaType": mediaType,
    });

    String encodedList2 = jsonEncode(decodedList);
    prefs.setString("myList", encodedList2);
    _myList = decodedList;
    notifyListeners();
  }

  init() async {
    _isListLoading = true;
    notifyListeners();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String encodedList = prefs.getString("myList") ?? "[]";
    // List<dynamic> decodedList = jsonDecode(encodedList) as List<dynamic>;

    List cloudList = Provider.of<UserInfoProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).userData['message'][0]['favorites'];

    // List<dynamic> missingIDs = [];

    var contents = [];
    for (var element in cloudList) {
      if (element != "") {
        var content = await MyListAPI().getItemByID(id: element.toString());
        if (content != {}) {
          contents.add(content);
        }
      }
    }

    _myList = contents;
    _isListLoading = false;
    notifyListeners();
  }
}
