import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/services/auth_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () async {
              await AuthService.signout(context: context);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            title: Text(
              "Logout",
              style: TextStyle(
                color: red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
