import 'package:flutter/material.dart';

const appBackgroundColor = Color(0xFF1c1c27);
const grey = Color(0xFF373741);
const buttonColor = Color(0xFFffb43b);

// for time

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String digitHours = duration.inHours.remainder(60).toString();
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return "${digitHours}h ${twoDigitMinutes}m";
}

// Text Styles
class AppTextStyles {
  static const TextStyle headerLarge = TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle headerMedium = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headerSmall = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyLarge = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle caption = TextStyle(
    color: Colors.white54,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle buttonText = TextStyle(
    color: buttonColor,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );
}