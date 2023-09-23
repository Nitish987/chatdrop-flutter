import 'dart:ui';
import 'package:flutter/material.dart';

import '../../data/models/draw_point_model.dart';

/// Custom Painter for sketching on screen
class SketchCanvasPainter extends CustomPainter {
  late List<DrawPointModel?> drawPoints;

  SketchCanvasPainter(this.drawPoints);

  @override
  void paint(Canvas canvas, Size size) {
    for(int i = 0; i < drawPoints.length; i++) {
      if (i == 0) {
        canvas.drawPoints(PointMode.points, [drawPoints[i]!.position], drawPoints[i]!.paint);
      } else if (drawPoints[i - 1] != null && drawPoints[i] != null) {
        canvas.drawLine(drawPoints[i]!.position, drawPoints[i - 1]!.position, drawPoints[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}