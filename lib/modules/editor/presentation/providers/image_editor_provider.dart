import 'package:flutter/material.dart';

import '../../data/models/draw_point_model.dart';
import '../../data/models/text_model.dart';

class ImageEditorProvider extends ChangeNotifier {
  /// Pen Properties
  bool isPenActive = false;
  Color penColor = Colors.black;
  double penStrokeWidth = 5;
  final List<DrawPointModel?> drawPoints = <DrawPointModel?>[];

  /// Text Adder Properties
  bool isTextAdderActive = false;
  TextStyle textStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  int selectedTextIndex = -1;
  List<TextModel> texts = <TextModel>[];

  /// Sketch pen tool state
  void activeSketchPen() {
    isPenActive = true;
    isTextAdderActive = false;
    notifyListeners();
  }

  void deActiveSketchPen() {
    isPenActive = false;
    notifyListeners();
  }

  void addPenSketchPoints(DrawPointModel? drawPoint) {
    drawPoints.add(drawPoint);
    notifyListeners();
  }

  void changePenColor(Color color) {
    penColor = color;
    notifyListeners();
  }

  void undoPenSketchPoints() {
    int i = drawPoints.length - 1;
    if (drawPoints.isNotEmpty) {
      drawPoints.removeLast();
    }
    while (drawPoints.isNotEmpty && drawPoints[i - 1] != null) {
      drawPoints.removeAt(i - 1);
      i--;
    }
    notifyListeners();
  }

  /// Text Adder tool State
  void activeTextAdder() {
    isPenActive = false;
    isTextAdderActive = true;
    notifyListeners();
  }

  void deActiveTextAdder() {
    isTextAdderActive = false;
    notifyListeners();
  }

  void setSelectTextAdder(int index) {
    selectedTextIndex = index;
    textStyle = texts[index].style;
    notifyListeners();
  }

  void addTextAdder(String text) {
    texts.add(TextModel(xAxis: 20, yAxis: 20, text: text, style: textStyle));
    selectedTextIndex = texts.length - 1;
    notifyListeners();
  }

  void changeTextColor(Color color) {
    TextStyle style = TextStyle(
      fontSize: textStyle.fontSize,
      fontWeight: textStyle.fontWeight,
      color: color,
    );
    texts[selectedTextIndex].style = style;
    textStyle = style;
    notifyListeners();
  }

  void changeSelectedTextFontSize(double fontSize) {
    TextStyle style = TextStyle(
      fontSize: fontSize,
      fontWeight:textStyle.fontWeight,
      color: textStyle.color,
    );
    texts[selectedTextIndex].style = style;
    textStyle = style;
    notifyListeners();
  }

  void changeTextAdderPosition(int index, double xAxis, double yAxis) {
    texts[index].xAxis = xAxis;
    texts[index].yAxis = yAxis;
    notifyListeners();
  }
}
