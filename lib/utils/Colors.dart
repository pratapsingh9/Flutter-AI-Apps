import 'package:flutter/material.dart';

import 'dart:math';

class CustomColors {
  static Color LightRandomColor() {
    try {
      Random random = Random();
      int red = 128 + random.nextInt(128); // Range from 128 to 255
      int green = 128 + random.nextInt(128); // Range from 128 to 255
      int blue = 128 + random.nextInt(128); // Range from 128 to 255
      return Color.fromRGBO(red, green, blue, 1);
    } catch (e) {
      print(e);
      return Colors.white;
    }
  }
}
