import 'package:flutter/cupertino.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class OverlayLoader extends StatelessWidget {
  const OverlayLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: CupertinoActivityIndicator(
              radius: 15,
              color: black,
            ),
          ),
        ),
      ),
    );
  }
}
