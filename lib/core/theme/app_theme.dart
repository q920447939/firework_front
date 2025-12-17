import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFD32F2F);
  static const Color festiveRed = Color(0xFFC62828);
  static const Color accentGold = Color(0xFFFFC107);
  static const Color backgroundWhite = Color(0xFFFAFAFA);
  static const Color textBlack = Color(0xFF333333);
  static const Color textGrey = Color(0xFF999999);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryRed,
      scaffoldBackgroundColor: backgroundWhite,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryRed,
        secondary: accentGold,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryRed,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // Attempt to use a rounded font style if available, otherwise fallback to system
      fontFamily: 'PingFang SC', // Common for Chinese users on Apple devices
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textBlack),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textBlack),
        bodyMedium: TextStyle(fontSize: 14, color: textBlack),
        bodySmall: TextStyle(fontSize: 12, color: textGrey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
