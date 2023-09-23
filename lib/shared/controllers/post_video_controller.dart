import 'package:video_player/video_player.dart';

class PostVideoController {
  late VideoPlayerController playerController;
  bool isInitialized = false;
  bool _autoPausingState = false;
  late Function _changeState;

  void initialize(VideoPlayerController playerController, Function changeState) {
    this.playerController = playerController;
    _changeState = changeState;
    isInitialized = true;
  }

  void play() {
    if (isInitialized) {
      playerController.play();
      _changeState();
    }
  }

  void autoStatePlay() {
    if (_autoPausingState) {
      play();
      _autoPausingState = false;
    }
  }

  void pause() {
    if (isInitialized) {
      playerController.pause();
      _autoPausingState = false;
      _changeState();
    }
  }

  void autoStatePause() {
    pause();
    _autoPausingState = true;
  }
}