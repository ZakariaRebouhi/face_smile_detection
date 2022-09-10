import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class DetailsViewModel {
  Future<ui.Image> loadImage(File file) async {
    final data = await file.readAsBytes();
    ui.Image? image;

    image = await decodeImageFromList(data);
    return image;
  }

  List<Color> colorsGeneratedList(List<Face> faces) {
    List<Color> colorsList = [];
    for (int i = 0; i < faces.length; i++) {
      colorsList
          .add(Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    }
    return colorsList;
  }

  IconData faceMotion(double smileProb) {
    if (smileProb <= 20) {
      return FontAwesomeIcons.faceFrown;
    } else if (smileProb > 20 && smileProb <= 40) {
      return FontAwesomeIcons.faceMeh;
    } else if (smileProb > 40 && smileProb <= 60) {
      return FontAwesomeIcons.faceGrin;
    } else if (smileProb > 60 && smileProb <= 80) {
      return FontAwesomeIcons.faceSmile;
    } else if (smileProb > 80) {
      return FontAwesomeIcons.faceLaughBeam;
    }
    return FontAwesomeIcons.faceMehBlank;
  }
}
