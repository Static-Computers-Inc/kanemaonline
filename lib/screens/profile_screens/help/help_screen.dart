import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/values.dart';
import 'package:kanemaonline/helpers/fx/url_launcher.dart';
import 'package:kanemaonline/screens/profile_screens/help/app_info_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                LaunchUrl.launch(helpCenterURL);
              },
              title: const Text(
                "Help Centre",
              ),
              subtitle: const Text("contact us, get help"),
            ),
            ListTile(
              onTap: () {
                // Navigator.push(
                //   context,
                //   CupertinoPageRoute(
                //     builder: (context) => const BrowserScreen(
                //       url: termsPolicyURL,
                //       title: "Terms of use",
                //     ),
                //   ),
                // );
                LaunchUrl.launch(termsPolicyURL);
              },
              title: const Text("Terms of use"),
            ),
            ListTile(
              onTap: () {
                LaunchUrl.launch(privacyPolicyURL);
              },
              title: const Text("Privacy Policy"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const AppInfoScreen(),
                  ),
                );
              },
              title: const Text("App info"),
            )
          ],
        ),
      ),
    );
  }
}
