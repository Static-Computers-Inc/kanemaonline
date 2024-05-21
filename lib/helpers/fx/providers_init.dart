import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:provider/provider.dart';

class ProvidersInit {
  static initOnFirstLoad({required BuildContext context}) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<AuthProvider>(context, listen: false).getAuthData();
      Provider.of<UserInfoProvider>(context, listen: false).refreshUserData();
    });
  }

  static refreshProviders({required BuildContext context}) async {
    Provider.of<AuthProvider>(context, listen: false).getAuthData();
    Provider.of<UserInfoProvider>(context, listen: false).refreshUserData();
  }

  static updateAfterPayment({required BuildContext context}) {
    Provider.of<UserInfoProvider>(context, listen: false).refreshUserData();
  }
}
