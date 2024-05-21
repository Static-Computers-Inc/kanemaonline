// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';

class EventsPlayer extends StatefulWidget {
  final String streamKey;
  final String name;
  const EventsPlayer({
    super.key,
    required this.streamKey,
    required this.name,
  });

  @override
  State<EventsPlayer> createState() => _EventsPlayerState();
}

class _EventsPlayerState extends State<EventsPlayer> {
  late VideoPlayerController controller;
  VolumeController volumeController = VolumeController();
  ScreenBrightness brightnessContrroller = ScreenBrightness();

  //values,
  ValueNotifier<List<DeviceOrientation>> deviceOrientation = ValueNotifier(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  ValueNotifier<bool> isVideoPaused = ValueNotifier(false);
  ValueNotifier<Duration> videoDuration =
      ValueNotifier(const Duration(seconds: 0));

  ValueNotifier<double> playBackDuration = ValueNotifier(0.0);
  ValueNotifier<double> volume = ValueNotifier(0.0);

  ValueNotifier<bool> showControls = ValueNotifier(false);

  //brightness
  ValueNotifier<double> brightness = ValueNotifier(0.0);
  late StreamSubscription<double> _brightnessSubscription;

  @override
  void initState() {
    controller = VideoPlayerController.network(widget.streamKey);
    controller.initialize().then((value) {
      controller.play();
      controller.addListener(videoPlaybackListener);
      setState(() {});
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    volumeController.listener((volume) => volumeListener(volume));

    _brightnessSubscription =
        brightnessContrroller.onCurrentBrightnessChanged.listen((value) {
      brightnessListener(value);
    });

    super.initState();
  }

  @override
  void dispose() {
    volumeController.removeListener();
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    controller.dispose();
  }

  brightnessListener(double brightnessVal) async {
    brightness.value = await brightnessContrroller.system;
    brightness.notifyListeners();
    brightnessContrroller.setAnimate(true);
    brightness.value = brightnessVal;
    brightness.notifyListeners();
  }

  volumeListener(double volumeVal) {
    volume.value = volumeVal;
    volume.notifyListeners();
  }

  videoPlaybackListener() async {
    videoDuration.value = (await controller.position)!;
    videoDuration.notifyListeners();

    playBackDuration.value = (controller.value.duration.inSeconds).toDouble();
    playBackDuration.notifyListeners();
  }

  pauseAndPlayVideo() {
    // if video is paused
    if (isVideoPaused.value) {
      controller.play();
      isVideoPaused.value = false;
    } else {
      controller.pause();
      isVideoPaused.value = true;
    }

    isVideoPaused.notifyListeners();
  }

  changeOrientation() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      deviceOrientation.value = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ];
      deviceOrientation.notifyListeners();
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      deviceOrientation.value = [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ];
      deviceOrientation.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showControls.value) {
          showControls.value = false;
        } else {
          showControls.value = true;
        }

        showControls.notifyListeners();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Center(
              child: controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: InteractiveViewer(
                        clipBehavior: Clip.none,
                        panEnabled: false,
                        maxScale: 2,
                        minScale: 0.4,
                        child: VideoPlayer(controller),
                      ),
                    )
                  : CupertinoActivityIndicator(
                      color: white,
                      radius: 15,
                    ),
            ),
            // Positioned(child: actions()),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: toolBar(),
            ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: seekSelector(),
            // ),

            Positioned(
                bottom: 30,
                left: 40,
                child: ValueListenableBuilder(
                    valueListenable: showControls,
                    builder: (context, value, _) {
                      return AnimatedOpacity(
                        opacity: value ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                              color: red,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/live_signals.svg",
                                color: white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Live".toUpperCase(),
                                style: TextStyle(
                                  color: white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Widget toolBar() {
    return MultiValueListenableBuilder(
        valueListenables: [showControls, deviceOrientation],
        builder: (context, value, _) {
          bool showControls = value.elementAt(0);
          List<DeviceOrientation> orientation = value.elementAt(1);
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: showControls ? 1.0 : 0,
            child: IgnorePointer(
              ignoring: !showControls,
              child: Container(
                padding: orientation.contains(DeviceOrientation.portraitUp)
                    ? const EdgeInsets.symmetric(
                        vertical: kToolbarHeight,
                        horizontal: 15,
                      )
                    : EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: MediaQuery.of(context).padding.left,
                      ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      black.withOpacity(0.8),
                      black.withOpacity(0.6),
                      transparent,
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    orientation.contains(DeviceOrientation.portraitUp)
                        ? Container()
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Image.asset(
                              "assets/images/logo-white.png",
                            ),
                          ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          widget.name,
                          style: TextStyle(
                              color: white.withOpacity(0.8),
                              fontSize: 17,
                              fontWeight: FontWeight.w800),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Bounceable(
                      onTap: () {
                        changeOrientation();
                      },
                      child: Icon(CupertinoIcons.rotate_right,
                          color: white.withOpacity(0.7)),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        CupertinoIcons.clear,
                        color: white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
