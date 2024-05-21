import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/providers_init.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/providers/live_events_provider.dart';
import 'package:kanemaonline/providers/my_list_provider.dart';
import 'package:kanemaonline/providers/navigation_bar_provider.dart';
import 'package:kanemaonline/providers/packages_provider.dart';
import 'package:kanemaonline/providers/trending_provider.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:kanemaonline/providers/user_info_provider.dart';
import 'package:kanemaonline/providers/vods_provider.dart';
import 'package:kanemaonline/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:statusbarz/statusbarz.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TVsProvider()..init()),
        ChangeNotifierProvider(
          create: (_) => TrendingProvider()..getAllTrends(),
        ),
        ChangeNotifierProvider(create: (_) => VODsProvider()..init()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..getAuthData()),
        ChangeNotifierProvider(create: (_) => LiveEventsProvider()..init()),
        ChangeNotifierProvider(
          create: (_) => PackagesProvider()..getPackages(),
        ),
        ChangeNotifierProvider(create: (_) => MyListProvider()),
        ChangeNotifierProvider(
          create: (_) => UserInfoProvider()..refreshUserData(),
        ),
        ChangeNotifierProvider(create: (_) => NavigationBarProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn) {
      ProvidersInit.initOnFirstLoad(context: context);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return StatusbarzCapturer(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Kanema Online',
        themeMode: ThemeMode.dark,
        builder: (context, child) {
          child = botToastBuilder(context, child);
          return child;
        },
        navigatorObservers: [
          Statusbarz.instance.observer,
          BotToastNavigatorObserver(),
        ],
        darkTheme: ThemeData(
          scaffoldBackgroundColor: black,
          useMaterial3: true,
          textTheme: const TextTheme(),
          fontFamily: "Urbanist",
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: black,
            scrolledUnderElevation: 0,
            centerTitle: true,
            foregroundColor: white,
            titleTextStyle: const TextStyle(
              fontSize: 17,
              fontFamily: "Urbanist",
              fontWeight: FontWeight.w800,
            ),
          ),
          listTileTheme: ListTileThemeData(
              titleTextStyle: TextStyle(
                color: white,
                fontFamily: "Urbanist",
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
              subtitleTextStyle: TextStyle(
                color: darkGrey,
                fontWeight: FontWeight.w600,
                fontFamily: "Urbanist",
              )),
        ),
        home: const Wrapper(),
      ),
    );
  }
}
