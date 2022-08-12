import 'package:flutter/material.dart';

const brightness = Brightness.dark;
const primaryColor = Color(0xFF00C569);
const lightColor = Color(0xFFFFFFFF);
const backgroundColor = Color(0xFFF5F5F5);

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.deepPurple,
  brightness: brightness,
  inputDecorationTheme: const InputDecorationTheme(
    border:
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
  ),
  appBarTheme: const AppBarTheme(centerTitle: true),
);
