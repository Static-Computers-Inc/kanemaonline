// // ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

// import 'dart:async';
// import 'dart:io';

// import 'package:animate_do/animate_do.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
// import 'package:kanemaonline/helpers/constants/colors.dart';
// import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
// import 'package:screen_brightness/screen_brightness.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'package:video_player/video_player.dart';
// import 'package:volume_controller/volume_controller.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//   final String title;
//   final int duration;
//   const VideoPlayerScreen({
//     super.key,
//     required this.videoUrl,
//     required this.title,
//     required this.duration,
//   });

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController controller;
//   VolumeController volumeController = VolumeController();
//   ScreenBrightness brightnessContrroller = ScreenBrightness();

//   //values,
//   ValueNotifier<List<DeviceOrientation>> deviceOrientation = ValueNotifier(
//       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//   ValueNotifier<bool> isVideoPaused = ValueNotifier(false);
//   ValueNotifier<Duration> videoDuration =
//       ValueNotifier(const Duration(seconds: 0));

//   ValueNotifier<double> playBackDuration = ValueNotifier(0.0);
//   ValueNotifier<double> volume = ValueNotifier(0.0);

//   ValueNotifier<bool> showControls = ValueNotifier(false);

//   //brightness
//   ValueNotifier<double> brightness = ValueNotifier(0.0);
//   late StreamSubscription<double> _brightnessSubscription;

//   @override
//   void initState() {
//     super.initState();
//     controller = VideoPlayerController.network(widget.videoUrl);
//     controller.initialize().then((value) {
//       controller.play();
//       controller.seekTo(Duration(seconds: widget.duration));
//       controller.addListener(videoPlaybackListener);
//       setState(() {});
//     });
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//     //     overlays: [SystemUiOverlay.top]);

//     volumeController.listener((volume) => volumeListener(volume));

//     _brightnessSubscription =
//         brightnessContrroller.onCurrentBrightnessChanged.listen((value) {
//       brightnessListener(value);
//     });

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       if (Platform.isAndroid) {
//         await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     volumeController.removeListener();
//     super.dispose();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     controller.dispose();

//     if (Platform.isAndroid) {
//       FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
//     }
//   }

//   brightnessListener(double brightnessVal) async {
//     brightness.value = await brightnessContrroller.system;
//     brightness.notifyListeners();
//     brightnessContrroller.setAnimate(true);
//     brightness.value = brightnessVal;
//     brightness.notifyListeners();
//   }

//   volumeListener(double volumeVal) {
//     volume.value = volumeVal;
//     volume.notifyListeners();
//   }

//   videoPlaybackListener() async {
//     videoDuration.value = (await controller.position)!;
//     videoDuration.notifyListeners();

//     playBackDuration.value = (controller.value.duration.inSeconds).toDouble();
//     playBackDuration.notifyListeners();
//   }

//   pauseAndPlayVideo() {
//     // if video is paused
//     if (isVideoPaused.value) {
//       controller.play();
//       isVideoPaused.value = false;
//     } else {
//       controller.pause();
//       isVideoPaused.value = true;
//     }

//     isVideoPaused.notifyListeners();
//   }

//   changeOrientation() {
//     if (MediaQuery.of(context).orientation == Orientation.landscape) {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);

//       deviceOrientation.value = [
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown
//       ];
//       deviceOrientation.notifyListeners();
//     } else {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);

//       deviceOrientation.value = [
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight
//       ];
//       deviceOrientation.notifyListeners();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (showControls.value) {
//           showControls.value = false;
//         } else {
//           showControls.value = true;
//         }

//         showControls.notifyListeners();
//       },
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         body: Stack(
//           children: [
//             Center(
//               child: controller.value.isInitialized
//                   ? Hero(
//                       tag: widget.title,
//                       child: AspectRatio(
//                         aspectRatio: 16 / 9, // controller.value.aspectRatio,
//                         child: InteractiveViewer(
//                           clipBehavior: Clip.none,
//                           panEnabled: false,
//                           maxScale: 2,
//                           minScale: 0.4,
//                           child: VideoPlayer(controller),
//                         ),
//                       ),
//                     )
//                   : CupertinoActivityIndicator(
//                       color: white,
//                       radius: 15,
//                     ),
//             ),
//             Positioned(child: actions()),
//             Positioned(
//               top: 0,
//               left: 0,
//               right: 0,
//               child: toolBar(),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: seekSelector(),
//             ),
//           ],
//         ), // This trailing comma makes auto-formatting nicer for build methods.
//       ),
//     );
//   }

//   Widget actions() {
//     return !controller.value.isInitialized
//         ? Container()
//         : MultiValueListenableBuilder(
//             valueListenables: [
//                 isVideoPaused,
//                 volume,
//                 brightness,
//                 showControls,
//                 deviceOrientation
//               ],
//             builder: (context, val, _) {
//               bool isPaused = val.elementAt(0);
//               double volume = val.elementAt(1);
//               double brightnessVall = val.elementAt(2);
//               bool showControls = val.elementAt(3);
//               List<DeviceOrientation> orientation = val.elementAt(4);
//               return AnimatedOpacity(
//                 opacity: showControls ? 1.0 : 0.0,
//                 duration: const Duration(milliseconds: 200),
//                 child: IgnorePointer(
//                   ignoring: !showControls,
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                     decoration: BoxDecoration(
//                       color: black.withOpacity(0.5),
//                     ),
//                     child: Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // volume controller
//                           //
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 CupertinoIcons.speaker_2_fill,
//                                 color: white,
//                                 size: 17,
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.1,
//                                 height: orientation
//                                         .contains(DeviceOrientation.portraitUp)
//                                     ? MediaQuery.of(context).size.height * 0.25
//                                     : MediaQuery.of(context).size.height * 0.4,
//                                 child: SfSliderTheme(
//                                   data: const SfSliderThemeData(
//                                     inactiveTrackHeight: 3,
//                                     activeTrackHeight: 3,
//                                     thumbRadius: 0,
//                                   ),
//                                   child: SfSlider.vertical(
//                                     value: volume,
//                                     activeColor: white,
//                                     inactiveColor: white.withOpacity(0.45),
//                                     onChanged: (value) => {
//                                       volumeController.setVolume(value),
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           //
//                           SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.15),
//                           Bounceable(
//                             onTap: () async {
//                               controller.seekTo(
//                                 Duration(
//                                   seconds:
//                                       ((await controller.position)?.inSeconds ??
//                                               0) -
//                                           10,
//                                 ),
//                               );
//                             },
//                             child: ZoomIn(
//                               key: const Key("rewind"),
//                               child: SvgPicture.asset(
//                                 "assets/svg/rewind.svg",
//                                 width: orientation.contains(
//                                   DeviceOrientation.portraitUp,
//                                 )
//                                     ? 35
//                                     : 50,
//                                 color: white.withOpacity(0.65),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 20),
//                           //
//                           SizedBox(
//                             width: 65,
//                             child: GestureDetector(
//                               onTap: () => pauseAndPlayVideo(),
//                               child: isPaused
//                                   ? ZoomIn(
//                                       key: const Key("play"),
//                                       child: SvgPicture.asset(
//                                         "assets/svg/play_playback.svg",
//                                         width: orientation.contains(
//                                                 DeviceOrientation.portraitUp)
//                                             ? 45
//                                             : 60,
//                                         color: white.withOpacity(0.65),
//                                       ),
//                                     )
//                                   : ZoomIn(
//                                       key: const Key("pause"),
//                                       child: SvgPicture.asset(
//                                         "assets/svg/pause.svg",
//                                         width: orientation.contains(
//                                                 DeviceOrientation.portraitUp)
//                                             ? 45
//                                             : 60,
//                                         color: white.withOpacity(0.65),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                           //
//                           const SizedBox(width: 20),

//                           Bounceable(
//                             onTap: () async {
//                               controller.seekTo(
//                                 Duration(
//                                   seconds:
//                                       ((await controller.position)?.inSeconds ??
//                                               0) +
//                                           10,
//                                 ),
//                               );
//                             },
//                             child: ZoomIn(
//                               key: const Key("forward"),
//                               child: SvgPicture.asset(
//                                 "assets/svg/forward.svg",
//                                 width: orientation
//                                         .contains(DeviceOrientation.portraitUp)
//                                     ? 35
//                                     : 50,
//                                 color: white.withOpacity(0.65),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.15),

//                           // brightness controller
//                           //
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 CupertinoIcons.brightness_solid,
//                                 color: white,
//                                 size: 17,
//                               ),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width * 0.1,
//                                 height: orientation
//                                         .contains(DeviceOrientation.portraitUp)
//                                     ? MediaQuery.of(context).size.height * 0.25
//                                     : MediaQuery.of(context).size.height * 0.4,
//                                 child: SfSliderTheme(
//                                   data: const SfSliderThemeData(
//                                     inactiveTrackHeight: 3,
//                                     activeTrackHeight: 3,
//                                     thumbRadius: 0,
//                                   ),
//                                   child: SfSlider.vertical(
//                                     value: brightnessVall,
//                                     activeColor: white,
//                                     inactiveColor: white.withOpacity(0.45),
//                                     onChanged: (value) => {
//                                       brightnessContrroller
//                                           .setScreenBrightness(value)
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             });
//   }

//   Widget toolBar() {
//     return MultiValueListenableBuilder(
//         valueListenables: [showControls, deviceOrientation],
//         builder: (context, value, _) {
//           bool showControls = value.elementAt(0);
//           List<DeviceOrientation> orientation = value.elementAt(1);
//           return AnimatedOpacity(
//             duration: const Duration(milliseconds: 200),
//             opacity: showControls ? 1.0 : 0,
//             child: IgnorePointer(
//               ignoring: !showControls,
//               child: Container(
//                 padding: orientation.contains(DeviceOrientation.portraitUp)
//                     ? const EdgeInsets.symmetric(
//                         vertical: kToolbarHeight,
//                         horizontal: 15,
//                       )
//                     : EdgeInsets.symmetric(
//                         vertical: 25,
//                         horizontal: MediaQuery.of(context).padding.left,
//                       ),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       black.withOpacity(0.8),
//                       black.withOpacity(0.6),
//                       transparent,
//                     ],
//                   ),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     orientation.contains(DeviceOrientation.portraitUp)
//                         ? Container()
//                         : SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.1,
//                             child: Image.asset(
//                               "assets/images/logo-white.png",
//                             ),
//                           ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       flex: 3,
//                       child: Container(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: Text(
//                           widget.title,
//                           style: TextStyle(
//                               color: white.withOpacity(0.8),
//                               fontSize: 17,
//                               fontWeight: FontWeight.w800),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                     Expanded(child: Container()),
//                     Bounceable(
//                       onTap: () {
//                         changeOrientation();
//                       },
//                       child: Icon(CupertinoIcons.rotate_right,
//                           color: white.withOpacity(0.7)),
//                     ),
//                     const SizedBox(width: 20),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: SvgPicture.asset(
//                         "assets/svg/exit_fullscreen.svg",
//                         color: white.withOpacity(0.7),
//                         width: 22,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   Widget seekSelector() {
//     return ValueListenableBuilder(
//       valueListenable: deviceOrientation,
//       builder: (context, value, _) {
//         if (value.contains(DeviceOrientation.landscapeRight) ||
//             value.contains(DeviceOrientation.landscapeLeft)) {
//           return seekBar();
//         } else {
//           return seekBarPotrait();
//         }
//       },
//     );
//   }

//   Widget seekBar() {
//     return ValueListenableBuilder(
//         valueListenable: showControls,
//         builder: (context, values, _) {
//           return AnimatedOpacity(
//             opacity: values ? 1.0 : 0,
//             duration: const Duration(milliseconds: 200),
//             child: IgnorePointer(
//               ignoring: !values,
//               child: Container(
//                 padding: const EdgeInsets.only(top: 30),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       transparent,
//                       black.withOpacity(0.5),
//                       black.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: SafeArea(
//                   child: MultiValueListenableBuilder(
//                       valueListenables: [videoDuration, playBackDuration],
//                       builder: (context, value, _) {
//                         Duration videoD = value.elementAt(0);
//                         double playbackD = value.elementAt(1);
//                         return Row(
//                           children: [
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.085,
//                               child: Text(
//                                 "${videoD.inHours.toString().padLeft(2, "0")}:${(videoD.inSeconds ~/ 60).toString().padLeft(2, "0")}:${(videoD.inSeconds % 60).toString().padLeft(2, "0")}",
//                                 style: TextStyle(
//                                   color: white.withOpacity(0.6),
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                             // const SizedBox(width: 10),

//                             // const Text(""),

//                             !controller.value.isInitialized
//                                 ? Expanded(
//                                     child: Padding(
//                                     padding: const EdgeInsets.only(right: 15),
//                                     child: LinearProgressIndicator(
//                                       minHeight: 2,
//                                       backgroundColor: white.withOpacity(0.2),
//                                       color: white.withOpacity(0.5),
//                                     ),
//                                   ))
//                                 : Expanded(
//                                     child: SliderTheme(
//                                       data: SliderTheme.of(context).copyWith(
//                                         trackHeight: 3,
//                                         thumbShape: const RoundSliderThumbShape(
//                                             enabledThumbRadius: 5,
//                                             elevation: 0),
//                                       ),
//                                       child: Slider(
//                                           value: videoD.inSeconds.toDouble(),
//                                           max: playbackD,
//                                           thumbColor: red,
//                                           secondaryTrackValue:
//                                               controller.value.isInitialized
//                                                   ? controller.value.buffered[0]
//                                                       .end.inSeconds
//                                                       .toDouble()
//                                                   : 0,
//                                           secondaryActiveColor:
//                                               white.withOpacity(0.7),
//                                           inactiveColor: white.withOpacity(0.4),
//                                           activeColor: red,
//                                           allowedInteraction:
//                                               SliderInteraction.slideThumb,
//                                           // onChangeStart: (value) {
//                                           //   controller.seekTo(Duration(seconds: value.toInt()));
//                                           // },
//                                           onChanged: (value) {
//                                             controller.seekTo(Duration(
//                                                 seconds: value.toInt()));
//                                           }),
//                                     ),
//                                   ),

//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.085,
//                               child: Text(
//                                 "${(playbackD ~/ 3600).toString().padLeft(2, "0")}:${((playbackD ~/ 60) % 60).toString().padLeft(2, "0")}:${(playbackD % 60).toInt().toString().padLeft(2, "0")}",
//                                 style: TextStyle(
//                                   color: white.withOpacity(0.6),
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   Widget seekBarPotrait() {
//     return ValueListenableBuilder(
//         valueListenable: showControls,
//         builder: (context, values, _) {
//           return AnimatedOpacity(
//             opacity: values ? 1.0 : 0,
//             duration: const Duration(milliseconds: 200),
//             child: IgnorePointer(
//               ignoring: !values,
//               child: Container(
//                 padding: const EdgeInsets.only(top: 30),
//                 decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                       transparent,
//                       black.withOpacity(0.5),
//                       black.withOpacity(0.7),
//                     ])),
//                 child: SafeArea(
//                   child: MultiValueListenableBuilder(
//                       valueListenables: [videoDuration, playBackDuration],
//                       builder: (context, value, _) {
//                         Duration videoD = value.elementAt(0);
//                         double playbackD = value.elementAt(1);
//                         return Column(
//                           children: [
//                             // const SizedBox(width: 10),

//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 25),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     "${videoD.inHours.toString().padLeft(2, "0")}:${(videoD.inSeconds ~/ 60).toString().padLeft(2, "0")}:${(videoD.inSeconds % 60).toString().padLeft(2, "0")}",
//                                     style: TextStyle(
//                                       color: white.withOpacity(0.6),
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                   Expanded(child: Container()),
//                                   Text(
//                                     "${(playbackD ~/ 3600).toString().padLeft(2, "0")}:${((playbackD ~/ 60) % 60).toString().padLeft(2, "0")}:${(playbackD % 60).toInt().toString().padLeft(2, "0")}",
//                                     style: TextStyle(
//                                       color: white.withOpacity(0.6),
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 trackHeight: 3,
//                                 thumbShape: const RoundSliderThumbShape(
//                                     enabledThumbRadius: 5, elevation: 0),
//                               ),
//                               child: Slider(
//                                   value: videoD.inSeconds.toDouble(),
//                                   max: playbackD,
//                                   thumbColor: red,
//                                   secondaryTrackValue: controller
//                                       .value.buffered[0].end.inSeconds
//                                       .toDouble(),
//                                   secondaryActiveColor: white.withOpacity(0.7),
//                                   inactiveColor: white.withOpacity(0.4),
//                                   activeColor: red,
//                                   allowedInteraction:
//                                       SliderInteraction.slideThumb,
//                                   // onChangeStart: (value) {
//                                   //   controller.seekTo(Duration(seconds: value.toInt()));
//                                   // },
//                                   onChanged: (value) {
//                                     controller.seekTo(
//                                         Duration(seconds: value.toInt()));
//                                   }),
//                             ),
//                           ],
//                         );
//                       }),
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
