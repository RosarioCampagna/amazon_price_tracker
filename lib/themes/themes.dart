import 'package:flutter/material.dart';

ThemeData lightTheme =
    ThemeData(colorScheme: ColorScheme.dark(background: Colors.grey.shade800, primary: Colors.grey.shade300));

ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
  background: Color.fromARGB(255, 23, 18, 19),
  primary: Color.fromARGB(255, 83, 128, 131),
  secondary: Color.fromARGB(255, 49, 47, 47),
  tertiary: Color.fromARGB(255, 246, 244, 243),
));
