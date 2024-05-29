import 'package:flutter/cupertino.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/screens/screens.dart';
import 'package:kanemaonline/widgets/activity_loading_widget.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthLoading) {
          return const Center(child: CustomIndicatorWidget());
        } else {
          if (authProvider.isLoggedIn) {
            return const RootApp();
          } else {
            return const LandingScreen();
          }
        }
      },
    );
  }
}
