import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/vods_provider.dart';
import 'package:provider/provider.dart';

class VodsAPI {
  static Future<List<dynamic>> getAllVods() async {
    String baseUrl = 'https://kanemaonline.com/clone';

    const headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vods'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body) as List<dynamic>;
        return data;
      }
      debugPrint(response.body);
      Provider.of<VODsProvider>(navigatorKey.currentState!.context)
          .setHasError(true);

      return [];
    } catch (e) {
      Provider.of<VODsProvider>(navigatorKey.currentState!.context)
          .setHasError(true);
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  static Future<List<dynamic>> getAllTrending() async {
    String baseUrl = 'https://kanemaonline.com/clone';
    const headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/trends'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body) as List<dynamic>;
        return data;
      }
      debugPrint(response.body);
      return [];
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }
}
