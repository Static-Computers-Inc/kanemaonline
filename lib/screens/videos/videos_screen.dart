import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
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
