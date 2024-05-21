import 'package:flutter/material.dart';
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _accessToken = "";
  String _refreshToken = "";
  String _userid = "";

  bool _isAuthLoading = false;
  bool get isAuthLoading => _isAuthLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;
  String get userid => _userid;

  /// Sets the authentication data to the provided values and saves them in
  /// shared preferences.
  ///
  /// Parameters:
  /// - [accessToken]: The new access token to be set.
  /// - [refreshToken]: The new refresh token to be set.
  /// - [userid]: The new user id to be set.
  void setAuthData({
    required String accessToken,
    required String refreshToken,
    required String userid,
  }) async {
    // Set loading state to true and notify listeners.
    _isAuthLoading = true;
    notifyListeners();

    // Get shared preferences instance.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Set new values in shared preferences.
    prefs.setString("accessToken", accessToken);
    prefs.setString("refreshToken", refreshToken);
    prefs.setString("userid", userid);

    // Update internal variables.
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userid = userid;

    // Set loading state to false and logged in state to true and notify listeners.
    _isAuthLoading = false;
    _isLoggedIn = true;

    // Notify listeners.
    notifyListeners();
  }

  void updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    // Update shared preferences with new tokens
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accessToken", accessToken);
    prefs.setString("refreshToken", refreshToken);

    notifyListeners();
  }

  /// Retrieves the authentication data from shared preferences and updates
  /// the internal variables.
  ///
  /// This function sets the loading state to true, gets the shared preferences
  /// instance, retrieves the authentication data from it, updates the internal
  /// variables, and sets the loading state to false.
  ///
  /// Returns null.
  void getAuthData() async {
    // Set loading state to true and notify listeners.
    _isAuthLoading = true;
    notifyListeners();

    // Get shared preferences instance.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve authentication data from shared preferences.
    _accessToken = prefs.getString("accessToken") ?? "";
    _refreshToken = prefs.getString("refreshToken") ?? "";
    _userid = prefs.getString("userid") ?? "";

    // Update the logged in state based on the presence of access and refresh tokens.
    _isLoggedIn = _accessToken.isNotEmpty && _refreshToken.isNotEmpty;

    //update providers that rely on this
    Provider.of<UserInfoProvider>(navigatorKey.currentState!.context,
            listen: false)
        .refreshUserData();
    Provider.of<MyListProvider>(navigatorKey.currentState!.context,
            listen: false)
        .init();

    // Set loading state to false and notify listeners.
    _isAuthLoading = false;
    notifyListeners();
    return null;
  }

  /// Deletes the authentication data from shared preferences and updates
  /// the internal variables.
  ///
  /// This function sets the loading state to true, gets the shared preferences
  /// instance, deletes the authentication data from it, updates the internal
  /// variables, and sets the loading state to false.
  ///
  /// Returns null.
  void deleteAuth() async {
    // Set loading state to true and notify listeners.
    _isAuthLoading = true;
    notifyListeners();

    // Get shared preferences instance.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Delete authentication data from shared preferences.
    prefs.remove("accessToken");
    prefs.remove("refreshToken");
    prefs.remove("userid");

    // Update the internal variables.
    _accessToken = "";
    _refreshToken = "";
    _userid = "";
    _isLoggedIn = false;

    // Set loading state to false and notify listeners.
    _isAuthLoading = false;
    notifyListeners();
  }
}
