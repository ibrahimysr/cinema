import 'package:cinema/core/theme/color.dart';
import 'package:flutter/material.dart';

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

  static TextStyle buttonText = const TextStyle(
    color: Appcolor.buttonColor,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );
}