import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LiveEventsAPI {
  static Future<List<dynamic>> getAllTVs() async {
    String baseUrl = 'https://kanemaonline.com/clone';

    const headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tvs'),
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

  static Future<List<dynamic>> getAllTrending() async {
    String baseUrl = 'https://kanemaonline.com/clone';
    const headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events'),
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
