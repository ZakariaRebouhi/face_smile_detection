import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Color> colors;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces, this.colors) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    List<Paint> paints = [];

    for (var i = 0; i < faces.length; i++) {
      paints.add(Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7.0
        ..color = colors[i]);
    }
    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paints[i]);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}
