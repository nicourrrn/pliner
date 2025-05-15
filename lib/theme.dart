import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

bool isDesktop() {
  return !kIsWeb &&
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
}

bool isLowWidthSize(BuildContext context) {
  return MediaQuery.of(context).size.width < 800;
}

// final _baseFont = GoogleFonts.manrope();
final _baseFont = GoogleFonts.inter();
// final _baseFont = GoogleFonts.montserrat();
// final _baseFont = GoogleFonts.raleway();
// final _baseFont = GoogleFonts.merriweather();
// final _baseFont = GoogleFonts.robotoSlab();
// final _baseFont = GoogleFonts.comfortaa();

final desctopTheme = ThemeData(
  textTheme: TextTheme(
    bodySmall: _baseFont.copyWith(fontSize: 14, color: Colors.black),
    bodyMedium: _baseFont.copyWith(fontSize: 16, color: Colors.black54),
    bodyLarge: _baseFont.copyWith(fontSize: 18, color: Colors.black),
    titleSmall: _baseFont.copyWith(fontSize: 16, color: Colors.black),
    titleMedium: _baseFont.copyWith(fontSize: 18, color: Colors.black),
    titleLarge: _baseFont.copyWith(fontSize: 20, color: Colors.black),
    displaySmall: _baseFont.copyWith(fontSize: 20, color: Colors.black),
    displayMedium: _baseFont.copyWith(fontSize: 23, color: Colors.black),
    displayLarge: _baseFont.copyWith(fontSize: 26, color: Colors.black),
    headlineSmall: _baseFont.copyWith(fontSize: 28, color: Colors.black),
    headlineMedium: _baseFont.copyWith(fontSize: 30, color: Colors.black),
    headlineLarge: _baseFont.copyWith(fontSize: 32, color: Colors.black),
    labelSmall: _baseFont.copyWith(fontSize: 10, color: Colors.black),
    labelMedium: _baseFont.copyWith(fontSize: 12, color: Colors.black),
    labelLarge: _baseFont.copyWith(fontSize: 14, color: Colors.black),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);

final mobileTheme = ThemeData(
  textTheme: TextTheme(
    bodySmall: _baseFont.copyWith(fontSize: 14, color: Colors.black),
    bodyMedium: _baseFont.copyWith(fontSize: 12, color: Colors.black54),
    bodyLarge: _baseFont.copyWith(fontSize: 16, color: Colors.black),
    titleSmall: _baseFont.copyWith(fontSize: 18, color: Colors.black),
    titleMedium: _baseFont.copyWith(fontSize: 20, color: Colors.black),
    titleLarge: _baseFont.copyWith(fontSize: 22, color: Colors.black),
    displaySmall: _baseFont.copyWith(fontSize: 24, color: Colors.black),
    displayMedium: _baseFont.copyWith(fontSize: 26, color: Colors.black),
    displayLarge: _baseFont.copyWith(fontSize: 28, color: Colors.black),
    headlineSmall: _baseFont.copyWith(fontSize: 30, color: Colors.black),
    headlineMedium: _baseFont.copyWith(fontSize: 32, color: Colors.black),
    headlineLarge: _baseFont.copyWith(fontSize: 34, color: Colors.black),
    labelSmall: _baseFont.copyWith(fontSize: 10, color: Colors.black),
    labelMedium: _baseFont.copyWith(fontSize: 12, color: Colors.black),
    labelLarge: _baseFont.copyWith(fontSize: 14, color: Colors.black),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);
