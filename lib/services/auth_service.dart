import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthService {
  static signout({required BuildContext context}) async {
    Provider.of<AuthProvider>(context, listen: false).deleteAuth();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static register({
    required BuildContext context,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {}
}
