import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kanemaonline/main.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PaymentAPI {
  static String baseUrl = 'https://kanemaonline.com/clone';
  static Future<Map<String, dynamic>> getPaymentMethods() async {
    final url = Uri.parse('$baseUrl/payment-methods');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${Provider.of<AuthProvider>(navigatorKey.currentState!.context, listen: false).accessToken}",
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      }
    } catch (err) {
      throw Exception(err);
    }
    return {};
  }

  static Future<Map<String, dynamic>> initiateDirectPayment({
    required String userId,
    required double amount,
    required double duration,
    required String packageName,
    required String phoneNumber,
    required String paymentMethod,
  }) async {
    final accessToken = Provider.of<AuthProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).accessToken;

    debugPrint(accessToken);
    debugPrint(userId);
    final url = Uri.parse('$baseUrl/billing/subscriptions');
    final headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $accessToken',
    };
    final body = {
      "phone": phoneNumber,
      "userid": userId,
      "price": 100, // amount,
      "package_name": packageName,
      "duration": duration,
      "payment_gateway": paymentMethod,
      "gateway_mode": "direct",
    };

    debugPrint(body.toString());

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    debugPrint(response.body.toString());
    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to initiate direct payment');
    }
  }

  static Future<Map<String, dynamic>> initiatePayPalPayment({
    required String userId,
    required double amount,
    required double duration,
    required String packageName,
    required String phoneNumber,
    required String paymentMethod,
  }) async {
    final accessToken = Provider.of<AuthProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).accessToken;

    debugPrint(accessToken);
    debugPrint(userId);
    final url = Uri.parse('$baseUrl/billing/subscriptions');
    final headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $accessToken',
    };
    final body = {
      "phone": phoneNumber,
      "userid": userId,
      "price": amount,
      "package_name": packageName,
      "duration": duration,
      "payment_gateway": "PayPal",
      "gateway_mode": "direct",
    };

    debugPrint(body.toString());

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    debugPrint(response.body.toString());
    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to initiate direct payment');
    }
  }

  static Future<List<dynamic>> checkPaymentStatus(
      {required String depositID}) async {
    final url = Uri.parse('$baseUrl/billing/payment/$depositID');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          "Bearer ${Provider.of<AuthProvider>(navigatorKey.currentState!.context, listen: false).accessToken}",
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body) as List<dynamic>;
        return data;
      } else {
        throw Exception('Failed to check payment status');
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  static Future<Map<dynamic, dynamic>> initiateCardPayment({
    required String userId,
    required double amount,
    required double duration,
    required String packageName,
    required String phoneNumber,
    required String paymentMethod,
    required String creditCardNumber,
    required String creditCardExpiry,
    required String creditCardCVV,
    required String cardHolderName,
  }) async {
    final accessToken = Provider.of<AuthProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).accessToken;

    debugPrint(accessToken);
    debugPrint(userId);
    final url = Uri.parse('$baseUrl/billing/subscriptions');
    final headers = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $accessToken',
    };
    final body = {
      "phone": phoneNumber,
      "userid": userId,
      "price": amount,
      "package_name": packageName,
      "duration": duration,
      "payment_gateway": "DPO",
      "gateway_mode": "credit_card",
      "cc": {
        "creditCardNumber": creditCardNumber,
        "creditCardExpiry": creditCardExpiry,
        "creditCardCVV": creditCardCVV,
        "cardHolderName": cardHolderName,
      },
    };

    debugPrint(body.toString());

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    debugPrint(response.body.toString());
    if (response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to initiate direct payment');
    }
  }

  static Future notifyBackened(
      {required String ref, required String status}) async {
    final accessToken = Provider.of<AuthProvider>(
      navigatorKey.currentState!.context,
      listen: false,
    ).accessToken;

    final url = Uri.parse('$baseUrl/billing/create-payment-status');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = {
      "ref": ref,
      "status": status,
    };

    debugPrint(body.toString());

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to notify');
    }
  }
}
