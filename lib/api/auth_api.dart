// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kanemaonline/api/ip_lookup_api.dart';
import 'package:kanemaonline/helpers/fx/betterlogger.dart';
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/screens/auth/verify_account.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:provider/provider.dart';

class AuthAPI {
  String baseUrl = "https://kanemaonline.com/clone";

  Future<bool> login({required String userid, required String password}) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final requestBody = {
      'userid': userid,
      'password': password,
    };

    debugPrint(requestBody.toString());
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
        var status = body['status'];

        //LOGIN SUCESSFUL

        if (status == "success") {
          final newRefreshToken = body['message']['tk']['refresh_token'];
          final newAccessToken = body['message']['tk']['accessToken'];
          final userid = body['message']['user']['_id'];

          var accountStatus = body['message']['user']['status']['admin'];

          debugPrint(accountStatus.toString());
          if (accountStatus == "inactive") {
            BotToasts.showToast(
              message: "Account doesn't exist. Please register",
              isError: true,
            );
            throw "Account doesn't exist. Please register";
          } else if (accountStatus == "deactivated" ||
              accountStatus == "pending") {
            try {
              await http.get(Uri.parse('$baseUrl/auth/$userid/resend-otp'),
                  headers: headers);
              Navigator.popUntil(
                  navigatorKey.currentState!.context, (route) => route.isFirst);
              Navigator.push(
                navigatorKey.currentState!.context,
                CupertinoPageRoute(
                  builder: (context) =>
                      VerifyAccountScreen(phoneNumber: "", userId: userid),
                ),
              );
              throw "User account is not verified. Please verify your account";
            } catch (err) {
              rethrow;
            }
          }

          AuthProvider().setAuthData(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            userid: userid,
          );

          return true;
        } else {
          BotToasts.showToast(
            message: body['message'],
            isError: true,
          );
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
    final url = Uri.parse('$baseUrl/clone/auth/refresh');

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

  Future<Map<dynamic, dynamic>> register({
    required String userid,
    required String password,
    required String name,
    required String region,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final requestBody = {
      "userid": userid,
      "name": name,
      "password": password,
      "city": "",
      "service_name": "",
      "region": region,
    };

    // GET LOCATION DATA
    final ipdata = await IPLookUpAPI().getIPData();

    final addressInfo = {
      "ip": ipdata['ip'],
      "isp": ipdata['connection']['organization'],
      "city": ipdata['location']['city'],
      "country": ipdata['location']['country']['name'],
      "region": ipdata['location']['region']['name'],
    };

    final headers = {
      'Content-Type': 'application/json',
      'x_location_info': jsonEncode(addressInfo),
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: headers,
      );

      debugPrint(response.body.toString());

      var body = jsonDecode(response.body);

      if (body['status'] == "unsuccessful") {
        BotToasts.showToast(
          message: body['message'],
          isError: true,
        );
        throw Exception("Failed to register");
      } else if (body['status'] == "success") {
        return body;
      } else {
        throw Exception("Failed to register");
      }
    }
    // If the request fails due to network connectivity issues, throw an exception.
    on SocketException {
      throw Exception("Please Check Your Internet Connection");
    }
  }

  Future forgotPassword({required String userId}) async {
    final url = Uri.parse('$baseUrl/auth/$userId/forgot-passwd');
// GET LOCATION DATA
    final ipdata = await IPLookUpAPI().getIPData();

    final addressInfo = {
      "ip": ipdata['ip'],
      "isp": ipdata['connection']['organization'],
      "city": ipdata['location']['city'],
      "country": ipdata['location']['country']['name'],
      "region": ipdata['location']['region']['name'],
    };

    final headers = {
      'Content-Type': 'application/json',
      'x_location_info': jsonEncode(addressInfo),
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      var body = jsonDecode(response.body);
      debugPrint(body.toString());
      if (body['status'] == "unsuccessfull") {
        BotToasts.showToast(
          message: body['message'],
          isError: true,
        );
        throw body['message'];
      } else if (body['status'] == "success") {
        return body;
      } else {
        throw body['message'];
      }
    } catch (err) {
      BotToasts.showToast(
        message: err.toString(),
        isError: true,
      );
      rethrow;
    }
  }

  Future<Map<dynamic, dynamic>> verifyOTP({
    required String code,
  }) async {
    final url = Uri.parse('$baseUrl/auth/verify-account/$code');

    final headers = {
      'Content-Type': 'application/json',
    };

    // final body = {"id": code};

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      var body = jsonDecode(response.body);
      debugPrint(body.toString());
      if (body['status'] == "unsuccessfull") {
        BotToasts.showToast(
          message: body['message'],
          isError: true,
        );
        throw body['message'];
      } else if (body['status'] == "success") {
        return body;
      } else {
        throw body['message'];
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> resendOTP({required String userId}) async {
    final url = Uri.parse('$baseUrl/auth/$userId/resend-otp/');

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      var body = jsonDecode(response.body);
      if (body['status'] == "unsuccessful") {
        throw body['message'];
      } else {
        return body['message'];
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> changePassword({
    required String newPassword,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/auth/reset-password');
    final ipdata = await IPLookUpAPI().getIPData();

    final addressInfo = {
      "isp": ipdata['connection']['organization'],
      "city": ipdata['location']['city'],
      "country": ipdata['location']['country']['name'],
      "region": ipdata['location']['region']['name'],
    };

    final headers = {
      'Content-Type': 'application/json',
      'x_location_info': jsonEncode(addressInfo),
    };

    var requestBody = {
      'password': newPassword,
      'token': token,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: headers,
      );

      var body = jsonDecode(response.body);
      if (body['status'] == "unsuccessful") {
        throw body['message'];
      } else {
        return body['message'];
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> changePasswordLoggedIn({
    required String newPassword,
    required String oldPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/change-password');
    final ipdata = await IPLookUpAPI().getIPData();

    final addressInfo = {
      "isp": ipdata['connection']['organization'],
      "city": ipdata['location']['city'],
      "country": ipdata['location']['country']['name'],
      "region": ipdata['location']['region']['name'],
    };

    final headers = {
      'Content-Type': 'application/json',
      'x_location_info': jsonEncode(addressInfo),
    };

    var requestBody = {
      'userid': Provider.of<AuthProvider>(navigatorKey.currentState!.context,
              listen: false)
          .userid,
      "old_password": oldPassword,
      "new_password": newPassword,
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: headers,
      );

      var body = jsonDecode(response.body);
      console.log(body);
      if (body['status'] == "unsuccessful") {
        BotToasts.showToast(message: body['message'], isError: true);
        throw body['message'];
      } else {
        return;
      }
    } catch (err) {
      BotToasts.showToast(message: err.toString(), isError: true);
      rethrow;
    }
  }

  Future<void> deactivateAccount({required String userId}) async {
    final url = Uri.parse('$baseUrl/users/$userId/');

    final ipdata = await IPLookUpAPI().getIPData();

    final addressInfo = {
      "isp": ipdata['connection']['organization'],
      "city": ipdata['location']['city'],
      "country": ipdata['location']['country']['name'],
      "region": ipdata['location']['region']['name'],
    };

    final headers = {
      'Content-Type': 'application/json',
      'x_location_info': jsonEncode(addressInfo),
    };
    final request = {
      "_id": userId,
      "phone": "+265998435576",
      "status": {
        "admin": "deactivated",
      },
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(request),
      );

      var body = jsonDecode(response.body);

      if (body['status'] == "unsuccessful") {
        throw body['message']['response']['message'];
      } else {
        BotToasts.showToast(message: "Account deactivated", isError: true);
        return;
      }
    } catch (err) {
      BotToasts.showToast(
        message: err.toString(),
        isError: true,
      );
      rethrow;
    }
  }

  Future<void> deleteAccount({required String userId}) async {
    final url = Uri.parse('$baseUrl/users/$userId/');

    final ipdata = await IPLookUpAPI().getIPData();

    final addressInfo = {
      "isp": ipdata['connection']['organization'],
      "city": ipdata['location']['city'],
      "country": ipdata['location']['country']['name'],
      "region": ipdata['location']['region']['name'],
    };

    final headers = {
      'Content-Type': 'application/json',
      'x_location_info': jsonEncode(addressInfo),
    };
    final request = {
      "_id": userId,
      "phone": "+265998435576",
      "status": {
        "admin": "inactive",
      },
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(request),
      );

      var body = jsonDecode(response.body);

      if (body['status'] == "unsuccessful") {
        throw body['message']['response']['message'];
      } else {
        BotToasts.showToast(message: "Account deactivated", isError: true);
        return;
      }
    } catch (err) {
      BotToasts.showToast(
        message: err.toString(),
        isError: true,
      );
      rethrow;
    }
  }

  Future<void> verifyProfile({required String credential}) async {
    final url = Uri.parse('$baseUrl/users/profile-verify');
    final headers = {
      'Content-Type': 'application/json',
    };

    var requestBody = {
      "id": Provider.of<AuthProvider>(navigatorKey.currentState!.context,
              listen: false)
          .userid,
      "userid": credential,
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      var body = jsonDecode(response.body);

      console.log(body);

      if (body['status'] == "unsuccessful") {
        BotToasts.showToast(
          message: body['message'],
          isError: true,
        );
        throw body['message'];
      } else {
        // BotToasts.showToast(message: "", isError: false);
        return;
      }
    } catch (err) {
      rethrow;
    }
  }
}
