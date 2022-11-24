import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Constants{

  static const mobileBackgroundColor = Color.fromRGBO(0, 0, 0, 1);
  static const webBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
  static const mobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
  static const blueColor = Color.fromRGBO(0, 149, 246, 1);
  static const primaryColor = Colors.white;
  static const secondaryColor = Colors.grey;

  static const int screenWebSize=600;

  static getSnackBar(context, String title, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(title),
      backgroundColor: color,
    ));
  }

  static pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    print('No Image Selected');
  }

}