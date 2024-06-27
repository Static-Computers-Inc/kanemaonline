import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanemaonline/widgets/bot_toasts.dart';

class SubscriptionsAPI {
  static String baseUrl = "https://kanemaonline.com/clone";
  static getSubscriptions({required String userid}) async {
    String url = "$baseUrl/billing/$userid/subscriptions";

    try {
      var response = await http.get(Uri.parse(url));

      var body = jsonDecode(response.body);

      if (body['status'] == "unsuccessful" || response.statusCode != 200) {
        throw body['message'];
      } else if (body['status'] == "success") {
        return body['message'];
      }
    } catch (err) {
      BotToasts.showToast(
        message: err.toString(),
        isError: true,
      );
      rethrow;
    }
  }
}
