import 'package:flutter/material.dart';

ThemeData getLightTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.blue,
    primaryColorDark: Colors.blue.shade700,
    primaryColorLight: Colors.blue.shade100,

    /// appbar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      brightness: Brightness.light,
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
      thumbColor: MaterialStateColor.resolveWith((states) => Colors.white),
      overlayColor: MaterialStateColor.resolveWith((states) => Colors.white),
    ),

    /// chip theme
    chipTheme: ChipThemeData(
      backgroundColor: Colors.blue.shade50,
      brightness: Brightness.light,
      labelStyle: const TextStyle(
        color: Colors.blue
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
