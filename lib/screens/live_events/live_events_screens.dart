import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class LiveEventsScreen extends StatefulWidget {
  const LiveEventsScreen({super.key});

  @override
  State<LiveEventsScreen> createState() => _LiveEventsScreenState();
}

class _LiveEventsScreenState extends State<LiveEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
      ),
    );
  }
}
