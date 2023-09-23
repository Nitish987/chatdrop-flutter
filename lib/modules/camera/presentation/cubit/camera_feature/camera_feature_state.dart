abstract class CameraFeatureState {
  late bool isProcessing;
}

class PhotoCameraState extends CameraFeatureState {
  PhotoCameraState({bool isClicking = false}) {
    isProcessing = isClicking;
  }
}

class VideoCameraState extends CameraFeatureState {
  VideoCameraState({bool isRecording = false}) {
    isProcessing = isRecording;
  }
}

class ReelCameraState extends CameraFeatureState {
  bool isSetupFinish;
  ReelCameraState({this.isSetupFinish = false, bool isRecording = false}) {
    isProcessing = isRecording;
  }
}