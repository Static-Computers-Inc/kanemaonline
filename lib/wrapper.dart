import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/screens/screens.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    var isAuthLoading = Provider.of<AuthProvider>(context).isAuthLoading;
    var isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;

    if (isAuthLoading) {
      return Center(
        child: CupertinoActivityIndicator(
          color: white,
          radius: 20,
        ),
      );
    }

    if (isLoggedIn) {
      return const RootApp();
    } else {
      return const LandingScreen();
    }

    // return Consumer<AuthProvider>(
    //   builder: (context, authProvider, child) {
    //     if (authProvider.isAuthLoading) {
    //       return Center(
    //         child: CupertinoActivityIndicator(
    //           color: white,
    //           radius: 20,
    //         ),
    //       );
    //     } else {
    //       if (authProvider.isLoggedIn) {
    //       } else {
    //       }
    //     }
    //   },
    // );
  }
}
