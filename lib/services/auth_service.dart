import 'package:flutter/material.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthService {
  static signout({required BuildContext context}) async {
    Provider.of<AuthProvider>(context, listen: false).deleteAuth();
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
