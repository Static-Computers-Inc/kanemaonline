import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class BotToasts {
  static showToast({required String message, required bool isError}) {
    BotToast.showCustomNotification(
        onlyOne: true,
        duration: const Duration(seconds: 5),
        toastBuilder: (context) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: isError ? red : green,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          );
        });
  }

  static void showText({required String message}) {}
}
