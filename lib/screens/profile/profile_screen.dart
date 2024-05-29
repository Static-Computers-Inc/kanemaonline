import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:kanemaonline/screens/screens.dart';
import 'package:kanemaonline/screens/tests_screen.dart';
import 'package:kanemaonline/services/auth_service.dart';
import 'package:kanemaonline/wrapper.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint(
        Provider.of<UserInfoProvider>(context, listen: false)
            .userData
            .toString(),
      );
      if (Provider.of<UserInfoProvider>(context, listen: false).userData ==
          {}) {
        Provider.of<UserInfoProvider>(context, listen: false).refreshUserData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        title: const Text("Profile"),
      ),
      body: Consumer<UserInfoProvider>(builder: (context, value, _) {
        if (value.isLoading) {
          return Center(
            child: CupertinoActivityIndicator(
              color: white,
              radius: 15,
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<UserInfoProvider>(builder: (context, value, _) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        value.userData['message'][0]['name'] ?? "User",
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
                );
              }),

              const SizedBox(
                height: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
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
                onTap: () async {
                  await AuthService.signout(context: context);
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const Wrapper(),
                    ),
                  );
                },
                leading: const Icon(Icons.logout_rounded),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: red,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  "Logout from your account",
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

              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       CupertinoPageRoute(
              //         builder: (context) => const TestsScreen(),
              //       ),
              //     );
              //   },
              //   child: Text(
              //     "Test Screen",
              //     style: TextStyle(
              //       color: white,
              //     ),
              //   ),
              // ),

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
              _buildMyList(),

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
        );
      }),
    );
  }

  Widget _buildMyList() {
    return Consumer<MyListProvider>(builder: (context, value, child) {
      debugPrint(value.myList.length.toString());
      if (value.myList.isEmpty) {
        return Center(
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
        );
      } else {
        return Container(
          color: white,
          height: 30,
          width: 30,
        );
      }
    });
  }
}
