import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/screens/screens.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int selectedIndex = 0;

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
      body: Stack(
        children: [
          Positioned.fill(child: screens[selectedIndex]),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 10,
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
                children: navItems
                    .map(
                      (e) => GestureDetector(
                        onTap: () => {
                          setState(() {
                            selectedIndex = navItems.indexOf(e);
                          }),
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              e['icon']!,
                              width: navItems.indexOf(e) == 2 ? 24 : 20,
                              color: selectedIndex == navItems.indexOf(e)
                                  ? white
                                  : white.withOpacity(0.5),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              e['title'].toString(),
                              style: TextStyle(
                                  color: selectedIndex == navItems.indexOf(e)
                                      ? white
                                      : white.withOpacity(0.5),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
