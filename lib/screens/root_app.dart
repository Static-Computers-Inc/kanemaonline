import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/providers_init.dart';
import 'package:kanemaonline/providers/navigation_bar_provider.dart';
import 'package:kanemaonline/screens/screens.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'dart:io' as io;

import 'package:provider/provider.dart';
import 'package:rotating_icon_button/rotating_icon_button.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  var navItems = [
    {
      "title": "Home",
      "icon": "assets/svg/home.svg",
    },
    {
      "title": "Live TV",
      "icon": "assets/svg/tv.svg",
    },
    {
      "title": "Live Events",
      "icon": "assets/svg/live_signals.svg",
    },
    {
      "title": "Videos",
      "icon": "assets/svg/play_outline.svg",
    },
    {
      "title": "Profile",
      "icon": "assets/svg/profile.svg",
    }
  ];

  var screens = <Widget>[
    const HomeScreen(),
    const LiveTVScreen(),
    const LiveEventsScreen(),
    const VideosScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<NavigationBarProvider>(builder: (context, value, child) {
        return Stack(
          children: [
            Positioned.fill(child: screens[value.currentIndex]),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: io.Platform.isIOS
                      ? MediaQuery.of(context).padding.bottom
                      : MediaQuery.of(context).padding.bottom + 10,
                  top: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.black,
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: navItems.map(
                    (e) {
                      // REFRESH
                      if (navItems.indexOf(e) == 0 && value.currentIndex == 0) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width /
                              navItems.length,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  RotatingIconButton(
                                    padding: EdgeInsets.zero,
                                    background: transparent,
                                    onTap: () async {
                                      await ProvidersInit.refreshProviders(
                                        context: context,
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      "assets/svg/refresh.svg",
                                      width: navItems.indexOf(e) == 2 ? 24 : 20,
                                      color: value.currentIndex ==
                                              navItems.indexOf(e)
                                          ? white
                                          : white.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Refersh",
                                    style: TextStyle(
                                      color: value.currentIndex ==
                                              navItems.indexOf(e)
                                          ? white
                                          : white.withOpacity(0.5),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        width:
                            MediaQuery.of(context).size.width / navItems.length,
                        child: Center(
                          child: GestureDetector(
                            onTap: () => {
                              Provider.of<NavigationBarProvider>(
                                context,
                                listen: false,
                              ).changeIndex(
                                navItems.indexOf(e),
                              )
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  e['icon']!,
                                  width: navItems.indexOf(e) == 2 ? 24 : 20,
                                  color:
                                      value.currentIndex == navItems.indexOf(e)
                                          ? white
                                          : white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  e['title'].toString(),
                                  style: TextStyle(
                                    color: value.currentIndex ==
                                            navItems.indexOf(e)
                                        ? white
                                        : white.withOpacity(0.5),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
