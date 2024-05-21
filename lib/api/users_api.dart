import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UsersAPI {
  final String baseUrl = 'https://kanemaonline.com/clone';

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
}
