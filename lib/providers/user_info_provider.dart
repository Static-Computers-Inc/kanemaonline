// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kanemaonline/api/users_api.dart';
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<dynamic, dynamic> _userData = {};
  Map<dynamic, dynamic> get userData => _userData;

  refreshUserData() async {
    _isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      debugPrint("Context is ${navigatorKey.currentState!.context}");
      Map<dynamic, dynamic> userData = await UsersAPI.getUserData(
        context: navigatorKey.currentState!.context,
      );

      if (userData == {}) {
        debugPrint("User data is empty");
      } else {
        prefs.setString("userData", jsonEncode(userData));
        _userData = userData;
        notifyListeners();

        Provider.of<MyListProvider>(
          navigatorKey.currentState!.context,
          listen: false,
        ).init();
      }
    } catch (e) {
      BotToasts.showToast(
        message: "Error getting profile. Please try again!",
        isError: true,
      );
    }

    String data = prefs.getString("userData") ?? "{}";
    Map<dynamic, dynamic> decodedData =
        jsonDecode(data) as Map<dynamic, dynamic>;
    _userData = decodedData;
    _isLoading = false;
    notifyListeners();
  }

  init() async {
    _isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("userData") ?? "{}";

    Map<dynamic, dynamic> decodedData =
        jsonDecode(data) as Map<dynamic, dynamic>;

    if (decodedData == {}) {
      refreshUserData();
    } else {
      _userData = decodedData;
    }

    _isLoading = true;
    notifyListeners();
  }
}
