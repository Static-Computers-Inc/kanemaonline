import 'package:dlibphonenumber/dlibphonenumber.dart' as dlibphone;
import 'package:flutter/cupertino.dart';

class PhoneEmailValidator {
  static String? validateEmailOrPhone({
    required String value,
    required String isoCode,
  }) {
    if (value.isEmpty) {
      return 'Field cannot be empty';
    }

    // Regular expression for email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

    debugPrint(value.startsWith('0').toString());

    if (emailRegex.hasMatch(value)) {
      return null; // Valid email
    }

    // Valid email message

    try {
      // Validate phone number
      debugPrint('Trying to Validate');
      dlibphone.PhoneNumberUtil.instance.parse(value, "MW");
      debugPrint('finished');
    } catch (err) {
      debugPrint('Not valid phone number');
      if (!emailRegex.hasMatch(value)) {
        return 'Enter a valid Email';
      }
    }

    // Validate international phone number
    try {
      bool isValidPhone = dlibphone.PhoneNumberUtil.instance
          .isValidNumberForRegion(
              dlibphone.PhoneNumberUtil.instance.parse(value, isoCode),
              isoCode);

      if (isValidPhone) {
        return null;
      } else {
        return 'Enter a valid Phone number or Email';
      }
    } catch (e) {
      return 'Enter a valid Phone number or Email';
    }
  }
}
