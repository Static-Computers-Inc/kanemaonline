import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';

class HeroSearchAppBar {
  static PreferredSizeWidget appBar({required Function searchOnTap}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Bounceable(
              onTap: () => searchOnTap(),
              child: BlurryContainer(
                color: black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
                child: SvgPicture.asset(
                  "assets/svg/search.svg",
                  color: white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        )
      ],
    );
  }
}
