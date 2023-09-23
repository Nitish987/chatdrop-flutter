import 'package:flutter/material.dart';

ThemeData getDarkTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.blue,
    primaryColorDark: Colors.blue.shade700,
    primaryColorLight: Colors.blue.shade100,

    /// appbar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.blue,
      ),
      elevation: 0.5,
    ),

    /// color scheme
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      accentColor: Colors.blue,
      primaryColorDark: Colors.blue.shade700,
      backgroundColor: Colors.black,
      brightness: Brightness.dark,
      errorColor: Colors.red,
    ),

    /// icon theme
    iconTheme: const IconThemeData(
      color: Colors.blue,
    ),

    /// divider theme
    dividerTheme: const DividerThemeData(
      color: Colors.grey,
      thickness: 0.2,
    ),

    /// switch theme
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateColor.resolveWith((states) => Colors.blue),
      thumbColor: MaterialStateColor.resolveWith((states) => Colors.black),
      overlayColor: MaterialStateColor.resolveWith((states) => Colors.black),
    ),

    /// chip theme
    chipTheme: ChipThemeData(
      backgroundColor: Colors.blue.shade100,
      brightness: Brightness.dark,
      labelStyle: const TextStyle(
          color: Colors.black
      ),
      iconTheme: const IconThemeData(
        color: Colors.blue,
      ),
    ),

    /// icon button
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateColor.resolveWith((states) => Colors.blue),
      )
    ),

    /// input decoration
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade100),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade100),
      ),
    ),
  );
}
