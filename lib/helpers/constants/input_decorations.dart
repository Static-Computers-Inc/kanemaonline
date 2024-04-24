import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

InputDecoration inputDecoration = const InputDecoration(
  border: OutlineInputBorder(),
  enabledBorder: OutlineInputBorder(),
  focusedBorder: OutlineInputBorder(),
  errorBorder: OutlineInputBorder(),
  focusedErrorBorder: OutlineInputBorder(),
  isDense: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
);

InputDecoration authInputDecoration = InputDecoration(
  filled: true,
  fillColor: lightGrey,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(100),
    borderSide: BorderSide.none,
  ),
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 23,
    vertical: 2,
  ),
  hintText: "Email / Password",
  hintStyle: TextStyle(
    color: darkGrey,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  ),
);
