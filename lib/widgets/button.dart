import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class Button extends StatelessWidget {
  final Function onTap;
  final String text;
  const Button({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: green,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: white,
            ),
          ),
        ),
      ),
    );
  }
}
