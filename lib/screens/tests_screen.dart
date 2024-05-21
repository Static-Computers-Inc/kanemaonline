import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:provider/provider.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tests"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                // var data = await UsersAPI.getUserData(context: context);
                Provider.of<UserInfoProvider>(context, listen: false)
                    .refreshUserData();
                // print(data);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: white,
                ),
                child: const Text("Test User Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
