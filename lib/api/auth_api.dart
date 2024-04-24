import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kanemaonline/providers/auth_provider.dart';

class AuthAPI {
  String baseUrl = "https://kanemaonline.com/clone";

  Future<bool> login({required String userid, required String password}) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final requestBody = {
      'userid': userid,
      'password': password,
    };

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: headers,
      );

      debugPrint(response.statusCode.toString());
      debugPrint(response.body.toString());
      if (response.statusCode == 201) {
        final body = jsonDecode(response.body);
        var status = body['status'] != "unsuccesful";
        debugPrint(status.toString());
        if (status) {
          final newRefreshToken = body['message']['tk']['refresh_token'];
          final newAccessToken = body['message']['tk']['accessToken'];
          final userid = body['message']['user'];

          AuthProvider().setAuthData(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            userid: userid,
          );
          return true;
        } else {
          throw Exception("Failed to Login");
        }
      }
    } on SocketException {
      throw Exception("Please Check Your Internet Connection");
      // Handle network connection issues
    } on FormatException {
      // Handle JSON decoding issues
      debugPrint("something went wrong with the request body");
    }
    return false;
  }

  /// Refreshes the access token using the provided [userid] and [refreshToken].
  ///
  /// The function sends a POST request to the `$baseUrl/auth/refresh` endpoint
  /// with the [userid] and [refreshToken] in the request body. If the response
  /// status code is 200, the function updates the tokens using the [AuthProvider]
  /// and returns void. Otherwise, it throws an exception.
  /// If the request fails due to network connectivity issues or JSON decoding
  /// issues, appropriate exceptions are thrown.
  Future<void> refreshToken(
      {required String userid, required String refreshToken}) async {
    // Construct the URL for the token refresh request.
    final url = Uri.parse('$baseUrl/auth/refresh');

    // Construct the request body.
    final requestBody = {
      'userid': userid,
      'refreshToken': refreshToken,
    };

    // Set the request headers.
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      // Send the POST request to refresh the token.
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: headers,
      );

      // If the response status code is 200, update the tokens and return.
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final newRefreshToken = body['refreshToken'];
        final newAccessToken = body['accessToken'];

        AuthProvider().updateTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
      }
      // If the response status code is not 200, throw an exception.
      else {
        throw Exception("Failed to refresh token");
      }
    }
    // If the request fails due to network connectivity issues, throw an exception.
    on SocketException {
      throw Exception("Please Check Your Internet Connection");
    }
    // If the request fails due to JSON decoding issues, throw an exception.
    on FormatException {
      throw Exception("Failed to decode JSON response");
    }
  }

  Future<bool> register({
    required String userid,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    return true;
  }
}
