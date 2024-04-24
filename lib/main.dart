import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/providers/tvs_provider.dart';
import 'package:kanemaonline/screens/screens.dart';
import 'package:kanemaonline/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TVsProvider()..init()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..getAuthData())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kanema Online',
      themeMode: ThemeMode.dark,
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
          titleTextStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const Wrapper(),
    );
  }
}
