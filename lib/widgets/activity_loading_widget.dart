import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class CustomIndicatorWidget extends StatelessWidget {
  const CustomIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: transparent,
        child: CupertinoActivityIndicator(
          color: white,
          radius: 15,
        ),
      ),
    );
  }
}
