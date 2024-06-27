// import 'dart:async';
// import 'dart:io';

// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
// import 'package:kanemaonline/helpers/constants/colors.dart';
// import 'package:kanemaonline/providers/video_controller_provider.dart';
// import 'package:kanemaonline/screens/players/video_player.dart';
// import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
// import 'package:provider/provider.dart';
// import 'package:screen_brightness/screen_brightness.dart';

// import 'package:video_player/video_player.dart';
// import 'package:volume_controller/volume_controller.dart';

// class MiniVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final String title;
//   const MiniVideoPlayer({
//     super.key,
//     required this.videoUrl,
//     required this.title,
//   });

//   @override
//   State<MiniVideoPlayer> createState() => _MiniVideoPlayerState();
// }

// class _MiniVideoPlayerState extends State<MiniVideoPlayer> {
//   VolumeController volumeController = VolumeController();
//   ScreenBrightness brightnessController = ScreenBrightness();

//   ValueNotifier<bool> showControls = ValueNotifier(false);

//   //brightness
//   ValueNotifier<double> brightness = ValueNotifier(0.0);
//   late StreamSubscription<double> _brightnessSubscription;

//   //values,
//   ValueNotifier<List<DeviceOrientation>> deviceOrientation = ValueNotifier(
//       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       if (Platform.isAndroid) {
//         await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
//       }
//     });

//     final videoProvider =
//         Provider.of<VideoControllerProvider>(context, listen: false);
//     videoProvider.loadVideo(videoUrl: widget.videoUrl);
//   }

//   @override
//   void dispose() {
//     Provider.of<VideoControllerProvider>(context, listen: false).dispose();
//     _brightnessSubscription.cancel();
//     super.dispose();

//     if (Platform.isAndroid) {
//       FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
//     }
//   }

//   void brightnessListener(double brightnessVal) async {
//     brightness.value = await brightnessController.system;
//     brightnessController.setAnimate(true);
//     brightness.value = brightnessVal;
//   }

//   void pauseAndPlayVideo() {
//     Provider.of<VideoControllerProvider>(context, listen: false)
//         .pausePlayVideo();
//   }

//   void changeOrientation() {
//     if (MediaQuery.of(context).orientation == Orientation.landscape) {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);
//       deviceOrientation.value = [
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown
//       ];
//     } else {
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);
//       deviceOrientation.value = [
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight
//       ];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showControls.value = !showControls.value;
//       },
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         backgroundColor: darkerAccent.withOpacity(0.2),
//         body: Consumer<VideoControllerProvider>(builder: (context, value, _) {
//           return Stack(
//             children: [
//               Center(
//                 child: !value.isVideoLoading
//                     ? Hero(
//                         tag: widget.title,
//                         child: AspectRatio(
//                           aspectRatio: 16 / 9,
//                           child: InteractiveViewer(
//                             clipBehavior: Clip.none,
//                             panEnabled: false,
//                             maxScale: 2,
//                             minScale: 0.4,
//                             child: VideoPlayer(value.controller),
//                           ),
//                         ),
//                       )
//                     : CupertinoActivityIndicator(
//                         color: white,
//                         radius: 12,
//                       ),
//               ),
//               Positioned(
//                 child: actions(),
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: seekSelector(),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   Widget actions() {
//     return Consumer<VideoControllerProvider>(
//         builder: (context, videoProvider, child) {
//       return videoProvider.controller.value.isInitialized
//           ? Container()
//           : MultiValueListenableBuilder(
//               valueListenables: [
//                   showControls,
//                   deviceOrientation,
//                 ],
//               builder: (context, values, _) {
//                 bool showControls = values.elementAt(0);
//                 List<DeviceOrientation> orientation = values.elementAt(1);
//                 return AnimatedOpacity(
//                   opacity: showControls ? 1.0 : 0.0,
//                   duration: const Duration(milliseconds: 200),
//                   child: IgnorePointer(
//                     ignoring: !showControls,
//                     child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height,
//                       decoration: BoxDecoration(
//                         color: black.withOpacity(0.5),
//                       ),
//                       child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.15,
//                             ),
//                             Bounceable(
//                               onTap: () async {
//                                 videoProvider.controller.seekTo(
//                                   Duration(
//                                     seconds: ((await videoProvider
//                                                     .controller.position)
//                                                 ?.inSeconds ??
//                                             0) -
//                                         10,
//                                   ),
//                                 );
//                               },
//                               child: ZoomIn(
//                                 key: const Key("rewind"),
//                                 child: SvgPicture.asset(
//                                   "assets/svg/rewind.svg",
//                                   width: orientation.contains(
//                                     DeviceOrientation.portraitUp,
//                                   )
//                                       ? 25
//                                       : 35,
//                                   color: white.withOpacity(0.65),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             SizedBox(
//                               width: 65,
//                               child: GestureDetector(
//                                 onTap: () => pauseAndPlayVideo(),
//                                 child: !videoProvider.isPlaying
//                                     ? ZoomIn(
//                                         key: const Key("play"),
//                                         child: SvgPicture.asset(
//                                           "assets/svg/play_playback.svg",
//                                           width: orientation.contains(
//                                                   DeviceOrientation.portraitUp)
//                                               ? 35
//                                               : 45,
//                                           color: white.withOpacity(0.65),
//                                         ),
//                                       )
//                                     : ZoomIn(
//                                         key: const Key("pause"),
//                                         child: SvgPicture.asset(
//                                           "assets/svg/pause.svg",
//                                           width: orientation.contains(
//                                                   DeviceOrientation.portraitUp)
//                                               ? 35
//                                               : 50,
//                                           color: white.withOpacity(0.65),
//                                         ),
//                                       ),
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             Bounceable(
//                               onTap: () async {
//                                 videoProvider.controller.seekTo(
//                                   Duration(
//                                     seconds: ((await videoProvider
//                                                     .controller.position)
//                                                 ?.inSeconds ??
//                                             0) +
//                                         10,
//                                   ),
//                                 );
//                               },
//                               child: ZoomIn(
//                                 key: const Key("forward"),
//                                 child: SvgPicture.asset(
//                                   "assets/svg/forward.svg",
//                                   width: orientation.contains(
//                                           DeviceOrientation.portraitUp)
//                                       ? 25
//                                       : 35,
//                                   color: white.withOpacity(0.65),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                                 width:
//                                     MediaQuery.of(context).size.width * 0.15),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               });
//     });
//   }

//   Widget seekSelector() {
//     return ValueListenableBuilder(
//       valueListenable: deviceOrientation,
//       builder: (context, value, _) {
//         return seekBar();
//       },
//     );
//   }

//   Widget seekBar() {
//     return ValueListenableBuilder(
//       valueListenable: showControls,
//       builder: (context, values, _) {
//         return AnimatedOpacity(
//           opacity: values ? 1.0 : 0,
//           duration: const Duration(milliseconds: 200),
//           child: IgnorePointer(
//             ignoring: !values,
//             child: Container(
//               padding: const EdgeInsets.only(top: 30, bottom: 1),
//               child: Consumer<VideoControllerProvider>(
//                 builder: (context, videoProvider, child) {
//                   return Column(
//                     children: [
//                       _buildTime(),
//                       !videoProvider.controller.value.isInitialized
//                           ? Padding(
//                               padding: const EdgeInsets.only(right: 0, left: 0),
//                               child: LinearProgressIndicator(
//                                 minHeight: 2,
//                                 backgroundColor: white.withOpacity(0.2),
//                                 color: red.withOpacity(0.5),
//                               ),
//                             )
//                           : SizedBox(
//                               height: 5,
//                               child: SizedBox(
//                                 width: 400,
//                                 child: SliderTheme(
//                                   data: SliderTheme.of(context).copyWith(
//                                     trackHeight: 3,
//                                     thumbShape: const RoundSliderThumbShape(
//                                         enabledThumbRadius: 2, elevation: 2),
//                                     overlayShape: const RoundSliderOverlayShape(
//                                       overlayRadius: 0,
//                                     ),
//                                   ),
//                                   child: Slider(
//                                     thumbColor: red,
//                                     activeColor: red,
//                                     inactiveColor: red.withOpacity(0.5),
//                                     value: videoProvider
//                                         .controller.value.position.inSeconds
//                                         .toDouble(),
//                                     min: 0,
//                                     max: videoProvider
//                                         .controller.value.duration.inSeconds
//                                         .toDouble(),
//                                     onChanged: (val) {
//                                       videoProvider.controller.seekTo(Duration(
//                                         seconds: val.toInt(),
//                                       ));
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTime() {
//     return Consumer<VideoControllerProvider>(
//       builder: (context, videoProvider, child) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: !videoProvider.controller.value.isInitialized
//               ? Text(
//                   '00:00',
//                   style: TextStyle(
//                     color: white.withOpacity(0.5),
//                     fontSize: 10,
//                   ),
//                 )
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       videoProvider.controller.value.position
//                           .toString()
//                           .substring(2, 7),
//                       style: TextStyle(
//                         color: white.withOpacity(0.8),
//                         fontSize: 11,
//                       ),
//                     ),
//                     Text(
//                       videoProvider.controller.value.duration
//                           .toString()
//                           .substring(2, 7),
//                       style: TextStyle(
//                         color: white.withOpacity(0.8),
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//         );
//       },
//     );
//   }
// }

// USING FLICK VIDEO PLAYER

import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MiniVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;
  const MiniVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<MiniVideoPlayer> createState() => _MiniVideoPlayerState();
}

class _MiniVideoPlayerState extends State<MiniVideoPlayer> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
          videoPlayerOptions: VideoPlayerOptions()),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (Platform.isAndroid) {
        await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
        await FlutterWindowManager.addFlags(
            FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
      }
    });
  }

  @override
  void dispose() {
    flickManager.dispose();
    if (Platform.isAndroid) {
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: FlickVideoPlayer(
        flickManager: flickManager,
        flickVideoWithControls: FlickVideoWithControls(
          closedCaptionTextStyle: const TextStyle(fontSize: 8),
          controls: const FlickPortraitControls(),
          aspectRatioWhenLoading: 16 / 9,
          playerLoadingFallback: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: CupertinoActivityIndicator(color: white, radius: 13),
            ),
          ),
        ),
        flickVideoWithControlsFullscreen: const FlickVideoWithControls(
          controls: FlickLandscapeControls(),
          aspectRatioWhenLoading: 16 / 9,
        ),
      ),
    );
  }
}
