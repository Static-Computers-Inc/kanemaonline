import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MyListAPI {
  String baseUrl = "https://kanemaonline.com/clone";

  Future<List> getAllIDs() async {
    final url = Uri.parse(
        '$baseUrl/users/${Provider.of<AuthProvider>(navigatorKey.currentState!.context, listen: false).userid}/favorites');

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body;
      } else {
        return [];
      }
    } on SocketException {
      throw Exception("Please Check Your Internet Connection");
      // Handle network connection issues
    } on FormatException {
      // Handle JSON decoding issues
      debugPrint("something went wrong with the request body");
    }
    return [];
  }

  Future<Map<dynamic, dynamic>> getItemByID({required String id}) async {
    final url = Uri.parse('$baseUrl/search/$id');
    debugPrint(url.toString());
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body == []) {
          return body[0];
        }

        return {};
      } else {
        throw Exception("Couldn't get item:${response.body}");
      }
    } on SocketException {
      throw Exception("Please Check Your Internet Connection");
      // Handle network connection issues
    } on FormatException {
      // Handle JSON decoding issues
      debugPrint("something went wrong with the request body");
    }
    return {};
  }

  Future<bool> addItem({required String id}) async {
    final url = Uri.parse(
        '$baseUrl/users/${Provider.of<AuthProvider>(navigatorKey.currentState!.context, listen: false).userid}/favorites');
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = {
      'item': id,
    };

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
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
}
