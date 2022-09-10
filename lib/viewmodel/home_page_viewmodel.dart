import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/z_colors.dart';

class HomePageViewModel {
  Future pickImage(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Select image from')),
            actions: [
              ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.camera),
                  style: ElevatedButton.styleFrom(
                    primary: ZColors.primary,
                    minimumSize: const Size.fromHeight(50),
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: pickImageFromGallery,
                  label: const Text("Camera")),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.solidFolder),
                  style: ElevatedButton.styleFrom(
                    primary: ZColors.second,
                    minimumSize: const Size.fromHeight(50),
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: pickImageFromCamera,
                  label: const Text("Gallery")),
            ],
          );
        });
  }

  Future<File?> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    File imageFile;
    XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return null;
    } else {
      imageFile = File(pickedImage.path);
      return imageFile;
    }
  }

  Future<File?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    File imageFile;
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    } else {
      imageFile = File(pickedImage.path);
      return imageFile;
    }
  }
}
