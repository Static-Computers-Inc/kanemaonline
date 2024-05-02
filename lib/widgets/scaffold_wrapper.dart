import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:palette_generator/palette_generator.dart';

class ScaffoldWrapper extends StatefulWidget {
  final Widget child;
  final Color? toolbarColor;
  const ScaffoldWrapper({
    super.key,
    required this.child,
    this.toolbarColor,
  });

  @override
  State<ScaffoldWrapper> createState() => _ScaffoldWrapperState();
}

class _ScaffoldWrapperState extends State<ScaffoldWrapper> {
  PaletteGenerator? paletteGenerator;
  @override
  void initState() {
    super.initState();

    _generatePalette();
  }

  _generatePalette() {
    //  paletteGenerator = await PaletteGenerator.fromImageProvider(
    //   widget.image,
    //   size: widget.imageSize,
    //   region: newRegion,
    //   maximumColorCount: 20,
    // );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        Positioned(
          child: BlurryContainer(
            height: MediaQuery.of(context).padding.top,
            color:
                black.withOpacity(0), //widget.toolbarColor?.withOpacity(0.6) ??
            // Colors.brown[400]!.withOpacity(0.3),
            borderRadius: BorderRadius.zero,
            blur: 15,
            child: Container(),
          ),
        ),
      ],
    );
  }
}
