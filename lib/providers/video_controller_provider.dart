import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';

class VideoControllerProvider with ChangeNotifier {
  VideoPlayerController controller = VideoPlayerController.network('');
  VolumeController volumeController = VolumeController();

  double get volume => _volume;
  double _volume = 0.0;

  bool get isBuffering => _isBuffering;
  bool _isBuffering = false;

  bool get isPlaying => _isPlaying;
  final bool _isPlaying = true;

  bool get isVideoLoading => _isVideoLoading;
  bool _isVideoLoading = false;

  Duration get videoDuration => _videoDuration;
  Duration _videoDuration = const Duration(seconds: 0);

  double _playBackDuration = 0;
  double get playDuration => _playBackDuration;

  loadVideo({required String videoUrl}) {
    _isVideoLoading = true;
    notifyListeners();

    controller = VideoPlayerController.network(videoUrl);
    controller.initialize().then((value) {
      controller.play();

      controller.addListener(videoPlaybackListener);
    });
    volumeController.listener((volume) => volumeListener(volume));
    _isVideoLoading = false;
    notifyListeners();
  }

  disposeVideo() {
    controller.dispose();
    volumeController.removeListener();
    _videoDuration = Duration.zero;
    _playBackDuration = 0;
    _isBuffering = controller.value.isBuffering;

    notifyListeners();
  }

  videoPlaybackListener() async {
    _videoDuration = (await controller.position)!;
    _playBackDuration = (controller.value.duration.inSeconds).toDouble();
    notifyListeners();
  }

  pausePlayVideo() {
    _isPlaying ? controller.pause() : controller.play();
    notifyListeners();
  }

  volumeListener(double volumeVal) {
    _volume = volumeVal;
    notifyListeners();
  }
}
