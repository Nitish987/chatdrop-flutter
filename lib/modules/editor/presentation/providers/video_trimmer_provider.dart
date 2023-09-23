import 'package:flutter/cupertino.dart';

class VideoTrimmerProvider extends ChangeNotifier {
  double startValue = 0.0;
  double endValue = 0.0;

  bool isPlaying = false;
  bool progressVisibility = false;

  void setStartValue(double startValue) {
    this.startValue = startValue;
    notifyListeners();
  }

  void setEndValue(double endValue) {
    this.endValue = endValue;
    notifyListeners();
  }

  void setIsPlaying(bool isPlaying) {
    this.isPlaying = isPlaying;
    notifyListeners();
  }

  void setProgressVisibility(bool progressVisibility) {
    this.progressVisibility = progressVisibility;
    notifyListeners();
  }
}