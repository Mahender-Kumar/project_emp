import 'package:flutter/material.dart';
import 'package:project_emp/core/app_theme/colors.dart';
import 'package:project_emp/core/constants/sizes.dart'; 

class AppTheme {
  final AppColors chosenColor;

  AppTheme(this.chosenColor);

  ThemeData getTheme() {
    final sizes = AppValues();

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: chosenColor.primary,
        primary: chosenColor.primary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: chosenColor.background,
      ),
      cardColor: chosenColor.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: chosenColor.primaryColor,
        foregroundColor: chosenColor.backgroundColor,
        titleTextStyle: TextStyle(
          fontSize: sizes.appBarText,
          color: chosenColor.whiteColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        labelStyle: TextStyle(
          color: chosenColor.textColor,
          fontSize: sizes.normalText,
        ),
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: chosenColor.textColor,
          fontSize: sizes.normalText,
        ),
        headlineLarge: TextStyle(
          color: chosenColor.textColor,
          fontSize: sizes.largeText,
        ),
      ),

      // filledButtonTheme: FilledButtonThemeData(
      //   style: FilledButton.styleFrom(
      //     // backgroundColor: chosenColor.primaryColor,
      //     // foregroundColor: chosenColor.whiteColor,
      //     textStyle: TextStyle(
      //       fontSize: sizes.smallText,
      //       color: chosenColor.whiteColor,
      //     ),
      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //   ),
      // ),
      listTileTheme: ListTileThemeData(dense: true),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all<Color>(chosenColor.primaryColor),
        overlayColor: WidgetStateProperty.all<Color>(
          chosenColor.backgroundColor,
        ),
        trackColor: WidgetStateProperty.all<Color>(chosenColor.backgroundColor),
        trackOutlineColor: WidgetStateProperty.all<Color>(
          chosenColor.backgroundColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: chosenColor.primaryColor,
        foregroundColor: chosenColor.whiteColor,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: chosenColor.backgroundColor,
      ),
      bottomAppBarTheme: BottomAppBarTheme(color: chosenColor.primary),
      scaffoldBackgroundColor: chosenColor.background,
      cardTheme: CardTheme(
        color: chosenColor.surface,
        elevation: 2,
        shadowColor: chosenColor.onSurface,
      ),
    );
  }
}
