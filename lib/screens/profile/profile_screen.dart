import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/betterlogger.dart';
import 'package:kanemaonline/helpers/fx/url_launcher.dart';
import 'package:kanemaonline/helpers/fx/watch_bridge_functions.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:kanemaonline/providers/watchlist_provider.dart';
import 'package:kanemaonline/screens/players/mini_player_popup.dart';
import 'package:kanemaonline/screens/screens.dart';
import 'package:kanemaonline/services/auth_service.dart';
import 'package:kanemaonline/wrapper.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
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
                      // Icon(
                      //   CupertinoIcons.pen,
                      //   color: white,
                      //   size: 13,
                      // )
                    ],
                  ),
                );
              }),

              const SizedBox(
                height: 10,
              ),
              _divider(),
//// account actions

              ListTile(
                dense: true,
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
                // contentPadding: EdgeInsets.zero,
                dense: true,
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

              //// account actions
              ListTile(
                dense: true,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const HelpScreen(),
                    ),
                  );
                },
                leading: const Icon(CupertinoIcons.person),
                title: Text(
                  "Help",
                  style: TextStyle(
                    color: white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  "Help center, contact us, privacy policy",
                  style: TextStyle(
                    fontSize: 13,
                    color: white.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              ListTile(
                dense: true,
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
              //     "test screem",
              //     style: TextStyle(
              //       color: white,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              _divider(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
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

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child:
                    Consumer<WatchListProvider>(builder: (context, value, _) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        children: List.generate(
                          value.myList.length,
                          (index) => AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: darkAccent,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    value.myList[index]['thumb_nail'],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              // Center(
              //   child: Padding(
              //     padding: const EdgeInsets.all(35.0),
              //     child: Text(
              //       "TVs, shows and events you watch, will show up here",
              //       style: TextStyle(
              //         color: white.withOpacity(0.4),
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),

              _divider(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              _buildMoreFrom(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            ],
          ),
        );
      }),
    );
  }

  Widget _divider() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      height: 0.6,
      color: white.withOpacity(0.2),
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
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: List.generate(
                  value.myList.length,
                  (index) => AspectRatio(
                    aspectRatio: 1 / 1,
                    child: GestureDetector(
                      onTap: () {
                        Map<dynamic, dynamic> mediaInfo = value.myList[index];
                        if (mediaInfo['category'] == 'events') {
                          WatchBridgeFunctions.watchLiveBridge(
                            id: mediaInfo['_id'],
                            watchLive: () {
                              showCupertinoModalBottomSheet(
                                topRadius: Radius.zero,
                                backgroundColor: black,
                                barrierColor: black,
                                context: context,
                                builder: (context) => MiniPlayerPopUp(
                                  title: mediaInfo['name'],
                                  videoUrl: mediaInfo['stream_key'],
                                  data: mediaInfo,
                                ),
                              );
                            },
                            packages: [
                              "KanemaSupa",
                              "KanemaEvents",
                              mediaInfo['name']
                            ],
                            contentName: mediaInfo['name'],
                            thumbnail: mediaInfo['thumb_nail'],
                            price: mediaInfo['price'] ?? 100,
                            isPublished:
                                mediaInfo['status']['publish'] ?? false,
                          );
                        } else if (mediaInfo['category'] == "live_tv") {
                          WatchBridgeFunctions.watchTVBridge(
                            id: mediaInfo['_id'],
                            watchTV: () {
                              showCupertinoModalBottomSheet(
                                topRadius: Radius.zero,
                                backgroundColor: black,
                                barrierColor: black,
                                context: context,
                                builder: (context) => MiniPlayerPopUp(
                                  title: mediaInfo['name'],
                                  videoUrl: mediaInfo['stream_key'],
                                  data: mediaInfo,
                                ),
                              );
                            },
                            packages: [
                              "Kiliye Kiliye",
                              "KanemaSupa",
                              mediaInfo['name']
                            ],
                            contentName: mediaInfo['name'],
                            thumbnail: mediaInfo['thumb_nail'],
                            price: mediaInfo['price'] ?? 100,
                            isPublished:
                                mediaInfo['status']['publish'] ?? false,
                          );
                        } else {
                          WatchBridgeFunctions.watchLiveBridge(
                            id: mediaInfo['_id'],
                            watchLive: () {
                              showCupertinoModalBottomSheet(
                                topRadius: Radius.zero,
                                backgroundColor: black,
                                barrierColor: black,
                                context: context,
                                builder: (context) => MiniPlayerPopUp(
                                  title: mediaInfo['name'],
                                  videoUrl: mediaInfo['stream_key'],
                                  data: mediaInfo,
                                ),
                              );
                            },
                            packages: [
                              "Kiliye Kiliye",
                              "KanemaEvents",
                              mediaInfo['name']
                            ],
                            contentName: mediaInfo['name'],
                            thumbnail: mediaInfo['thumb_nail'],
                            price: mediaInfo['price'] ?? 100,
                            isPublished:
                                mediaInfo['status']['publish'] ?? false,
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: darkAccent,
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              value.myList[index]['thumb_nail'],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  Widget _buildMoreFrom() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Also From ",
                  style: TextStyle(
                    color: white.withOpacity(
                      0.5,
                    ),
                  ),
                ),
                const TextSpan(
                    text: " Static Computers Inc",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
              ],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                fontFamily: "Urbanist",
              ),
            ),
          ),
          const SizedBox(height: 15),
          ListTile(
            onTap: () {
              LaunchUrlHelper.launch("https://nkhani.app");
            },
            leading: SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/kanemanews.png",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              "Kanema News",
              style: TextStyle(
                color: white,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              LaunchUrlHelper.launch("https://katswiri.com");
            },
            leading: SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/katswiri.png",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              "Katswiri",
              style: TextStyle(
                color: white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
