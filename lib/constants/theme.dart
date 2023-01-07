import 'package:flutter/material.dart';

class AppTheme {
  static var lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    toggleButtonsTheme: ToggleButtonsThemeData(
      borderWidth: 1.5,
      borderColor: Colors.black,
      selectedBorderColor: Colors.black,
      borderRadius: BorderRadius.circular(16),
      fillColor: Colors.indigo,
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.black87,
      thickness: 1,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.indigo,
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      margin: const EdgeInsets.all(4),
      color: Colors.white70,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        padding: const EdgeInsets.all(12),
        maximumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
  static var darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black,
    toggleButtonsTheme: ToggleButtonsThemeData(
      borderWidth: 1.5,
      borderColor: Colors.white,
      selectedBorderColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      fillColor: Colors.indigo,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.indigo,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(21),
      ),
      margin: const EdgeInsets.all(4),
      color: Colors.black87,
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1.5,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        padding: const EdgeInsets.all(12),
        maximumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}
