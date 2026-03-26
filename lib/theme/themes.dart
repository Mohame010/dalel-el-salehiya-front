import 'package:flutter/material.dart';

class AppTheme {

  static BoxDecoration background = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xff0f2027),
        Color(0xff203a43),
        Color(0xff2c5364),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static BoxDecoration card = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: Colors.white.withOpacity(0.1),
    border: Border.all(color: Colors.white24),
  );

  static InputDecoration input(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}