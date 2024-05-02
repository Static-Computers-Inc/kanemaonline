import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class AllMediaSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  const AllMediaSearchBar({
    super.key,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: transparent,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: black,
          fontWeight: FontWeight.w700,
        ),
        cursorColor: black,
        decoration: InputDecoration(
          hintText: title,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
