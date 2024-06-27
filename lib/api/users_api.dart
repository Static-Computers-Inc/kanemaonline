import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:provider/provider.dart';

class UsersAPI {
  static String baseUrl = 'https://kanemaonline.com/clone';

  static Future<Map<dynamic, dynamic>> getUserData(
      {BuildContext? context}) async {
    String baseUrl = 'https://kanemaonline.com/clone';

    const headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/users/${Provider.of<AuthProvider>(context!, listen: false).userid}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        debugPrint('working fine');
        var data = await jsonDecode(response.body) as Map<dynamic, dynamic>;
        return data;
      } else {
        debugPrint(response.body);
        return {};
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  static Future<void> updateUserData({
    BuildContext? context,
    required Map<String, dynamic> data,
  }) async {
    const headers = {
      'Content-Type': 'application/json',
    };

    var requestBody = {
      "phone": "string",
      "email": "string",
      "password": "string",
      "city": "string",
      "country": "string",
      "isp": "string",
      "region": "string",
      "device": {},
    };

    try {
      var response = await http.put(
        Uri.parse(
            '$baseUrl/users/${Provider.of<AuthProvider>(context!, listen: false).userid}'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      var body = jsonDecode(response.body);

      if (body['status'] == "unsuccessful") {
        BotToasts.showToast(message: body['message'], isError: true);
        throw body['message'];
      } else {
        BotToasts.showToast(message: body['message'], isError: false);
        return;
      }
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> changePhonenumber({required String phoneNumber}) async {
    String baseUrl = 'https://kanemaonline.com/clone';

    const headers = {
      'Content-Type': 'application/json',
    };

    var requestBody = {
      "phone": phoneNumber,
    };

    try {
      final response = await http.put(
        Uri.parse(
            '$baseUrl/users/${Provider.of<AuthProvider>(navigatorKey.currentState!.context, listen: false).userid}'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      var body = jsonDecode(response.body);

      if (body['status'] == "unsuccessful") {
        BotToasts.showToast(message: body['message'], isError: true);
        throw body['message'];
      } else {
        BotToasts.showToast(message: "Phone number updated.", isError: false);
        Navigator.popUntil(
          navigatorKey.currentState!.context,
          (route) => route.isFirst,
        );
      }
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> changeEmail({required String email}) async {
    String baseUrl = 'https://kanemaonline.com/clone';

    const headers = {
      'Content-Type': 'application/json',
    };

    var requestBody = {
      "email": email,
    };

    try {
      final response = await http.put(
        Uri.parse(
            '$baseUrl/users/${Provider.of<AuthProvider>(navigatorKey.currentState!.context, listen: false).userid}'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      var body = jsonDecode(response.body);

      if (body['status'] == "unsuccessful") {
        BotToasts.showToast(message: body['message'], isError: true);
        throw body['message'];
      } else {
        BotToasts.showToast(message: body['message'], isError: false);
        Navigator.popUntil(
          navigatorKey.currentState!.context,
          (route) => route.isFirst,
        );
      }
    } catch (err) {
      rethrow;
    }
  }
}
