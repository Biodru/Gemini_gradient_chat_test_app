import 'package:flutter/material.dart';

class AppConstants {
  static final Shader appGradient = const LinearGradient(
    colors: <Color>[Color(0xff74ebd5), Color(0xffACB6E5)],
  ).createShader(
    const Rect.fromLTWH(0.0, 0.0, 250.0, 50.0),
  );
}
