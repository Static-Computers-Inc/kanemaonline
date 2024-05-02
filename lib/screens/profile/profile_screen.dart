import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/screens/screens.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        title: const Text("Profile≈"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.brown[900],
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset("assets/images/logo-white.png"),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Account221",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: white,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    CupertinoIcons.pen,
                    color: white,
                    size: 13,
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              height: 0.6,
              color: white.withOpacity(0.2),
            ),

            //// account actions
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const AccountScreen(),
                  ),
                );
              },
              leading: const Icon(CupertinoIcons.person),
              title: Text(
                "Account",
                style: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "Security, change email or number",
                style: TextStyle(
                  fontSize: 13,
                  color: white.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const SubscriptionsScreen(),
                  ),
                );
              },
              leading: const Icon(CupertinoIcons.money_dollar),
              title: Text(
                "Subscriptions and packages",
                style: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "Payment options, active subscriptions",
                style: TextStyle(
                  fontSize: 13,
                  color: white.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const HelpScreen(),
                  ),
                );
              },
              leading: const Icon(Icons.support_agent),
              title: Text(
                "Help",
                style: TextStyle(
                  color: white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "Help centre, contact us, privacy policy",
                style: TextStyle(
                  fontSize: 13,
                  color: white.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "My List",
                style: TextStyle(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Text(
                  "You don't have any saved videos, streams or TVs",
                  style: TextStyle(
                    color: white.withOpacity(0.4),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Recent Watched",
                style: TextStyle(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Text(
                  "TVs, shows and events you watch, will show up here",
                  style: TextStyle(
                    color: white.withOpacity(0.4),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
