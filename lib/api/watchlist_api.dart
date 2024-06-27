import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kanemaonline/helpers/fx/betterlogger.dart';
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:provider/provider.dart';

class WatchListAPI {
  String baseUrl = "https://kanemaonline.com/clone";

  Future<Map<dynamic, dynamic>> getItemByID({required String id}) async {
    final url = Uri.parse('$baseUrl/content/$id');
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
        List body = jsonDecode(response.body);

        console.log(body);
        if (body.isNotEmpty) {
          return body[0];
        }
        BotToasts.showToast(
          message: "Error getting error by ID",
          isError: false,
        );
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
      '$baseUrl/users/${Provider.of<AuthProvider>(navigatorKey.currentState!.context, listen: false).userid}/watchlist',
    );
    final headers = {
      'Content-Type': 'application/json',
    };

    if (id == "") {
      BotToasts.showToast(
        message: "Failed to add item to favorites",
        isError: true,
      );
      throw "Could not add item to favorites";
    }
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
