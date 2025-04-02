

import 'package:flutter/material.dart';

class AppColors {
  final Color whiteColor;
  final Color blackColor;
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color error;
  final Color onError;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Brightness brightness;

  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;

  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color secondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixed;
  final Color onSecondaryFixedVariant;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color tertiaryFixed;

  final Color tertiaryFixedDim;
  final Color onTertiaryFixed;
  final Color onTertiaryFixedVariant;

  final Color errorContainer;
  final Color onErrorContainer;

  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;
  final Color surfaceTint;

  AppColors({
    required this.whiteColor,
    required this.blackColor,
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.error,
    required this.onError,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.brightness,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixed,

    required this.onPrimaryFixedVariant,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.secondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixed,
    required this.onSecondaryFixedVariant,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.tertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixed,
    required this.onTertiaryFixedVariant,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,

    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.surfaceTint,
  });

  // ========================================================
  // Main color theme
  static final mainColors = AppColors(
    whiteColor: const Color(0xFFFFFFFF),
    blackColor: const Color(0xFF000000),
    backgroundColor: const Color(0xFFF5F5F5), // VS Code Light background
    textColor: const Color(0xFF2E2E2E), // Dark gray for readability
    primaryColor: const Color(0xFF007ACC), // VS Code accent blue
    primary: const Color(0xFF0066B8),
    onPrimary: Colors.white,
    secondary: const Color(0xFF5A5A5A), // Subtle secondary
    onSecondary: Colors.white,
    error: const Color(0xFFB00020),
    onError: Colors.white,
    background: const Color(0xFFF5F5F5),
    onBackground: Colors.black,
    surface: const Color(0xFFFFFFFF),
    onSurface: const Color(0xFF2E2E2E),
    brightness: Brightness.light,

    primaryContainer: const Color(0xFFD0E9FF),
    onPrimaryContainer: Colors.black,
    primaryFixed: const Color(0xFFCCE0F5),
    primaryFixedDim: const Color(0xFFA3C2E0),
    onPrimaryFixed: const Color(0xFF1B2836),
    onPrimaryFixedVariant: const Color(0xFF2B3D50),

    secondaryContainer: const Color(0xFFE8E8E8),
    onSecondaryContainer: Colors.black,
    secondaryFixed: const Color(0xFFD8D8D8),
    secondaryFixedDim: const Color(0xFFBABABA),
    onSecondaryFixed: const Color(0xFF313131),
    onSecondaryFixedVariant: const Color(0xFF444444),

    tertiary: const Color(0xFF9E9E9E),
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFFE0E0E0),
    onTertiaryContainer: Colors.black,
    tertiaryFixed: const Color(0xFFD5D5D5),
    tertiaryFixedDim: const Color(0xFFB8B8B8),
    onTertiaryFixed: const Color(0xFF2D2D2D),
    onTertiaryFixedVariant: const Color(0xFF414141),

    errorContainer: const Color(0xFFFFDAD6),
    onErrorContainer: Colors.black,

    surfaceDim: const Color(0xFFE0E0E0),
    surfaceBright: const Color(0xFFFDFDFD),
    surfaceContainerLowest: const Color(0xFFFFFFFF),
    surfaceContainerLow: const Color(0xFFF8F8F8),
    surfaceContainer: const Color(0xFFF3F3F3),
    surfaceContainerHigh: const Color(0xFFEDEDED),
    surfaceContainerHighest: const Color(0xFFE7E7E7),

    onSurfaceVariant: const Color(0xFF393939),
    outline: const Color(0xFF919191),
    outlineVariant: const Color(0xFFD1D1D1),
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),

    inverseSurface: const Color(0xFF2A2A2A),
    onInverseSurface: const Color(0xFFF1F1F1),
    inversePrimary: const Color(0xFFF0E9FF),
    surfaceTint: const Color(0xFF007ACC),
  );

  // ========================================================
  // Dark color theme
  static final darkColors = AppColors(
    whiteColor: const Color(0xFFD4D4D4), // Softer white for better contrast
    blackColor: const Color(0xFF1E1E1E), // VS Code background
    backgroundColor: const Color(0xFF252526), // Main background
    textColor: const Color(0xFFCCCCCC), // Lighter grey text
    primaryColor: const Color(0xFF323233), // Sidebar grey
    background: const Color(0xFF1E1E1E),
    onBackground: Colors.white,
    brightness: Brightness.dark,
    primary: Color(0xFF569CD6), // VS Code accent blue
    onPrimary: Color(0xFFE0E0E0),
    primaryContainer: Color(0xFF3B3B3D), // Darker container
    onPrimaryContainer: Color(0xFFEDEDED),
    primaryFixed: Color(0xFF404041),
    primaryFixedDim: Color(0xFF2E2E2E),
    onPrimaryFixed: Color(0xFFC7C7C7),
    onPrimaryFixedVariant: Color(0xFF1E1E1E),
    secondary: Color(0xFF4E4E50), // Slightly lighter UI elements
    onSecondary: Color(0xFFE0E0E0),
    secondaryContainer: Color(0xFF3E3E40),
    onSecondaryContainer: Color(0xFFF1F1F1),
    secondaryFixed: Color(0xFF454547),
    secondaryFixedDim: Color(0xFF333335),
    onSecondaryFixed: Color(0xFFC4C4C4),
    onSecondaryFixedVariant: Color(0xFF252526),
    tertiary: Color(0xFF569CD6), // Accent blue for active elements
    onTertiary: Color(0xFFE0E0E0),
    tertiaryContainer: Color(0xFF3A3D41),
    onTertiaryContainer: Color(0xFFEDEDED),
    tertiaryFixed: Color(0xFF323233),
    tertiaryFixedDim: Color(0xFF252526),
    onTertiaryFixed: Color(0xFFC7C7C7),
    onTertiaryFixedVariant: Color(0xFF1E1E1E),
    error: Color(0xFFF44747), // VS Code error red
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFB00020),
    onErrorContainer: Color(0xFFFDE7E9),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFC7C7C7),
    surfaceDim: Color(0xFF252526), // Not fully black
    surfaceBright: Color(0xFF333335),
    surfaceContainerLowest: Color(0xFF1A1A1A),
    surfaceContainerLow: Color(0xFF232324),
    surfaceContainer: Color(0xFF2D2D2E),
    surfaceContainerHigh: Color(0xFF37373A),
    surfaceContainerHighest: Color(0xFF3B3B3D),
    onSurfaceVariant: Color(0xFFC4C4C4),
    outline: Color(0xFF5A5A5A), // Borders and separators
    outlineVariant: Color(0xFF3D3D3D),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFFAFAFA),
    onInverseSurface: Color(0xFF1E1E1E),
    inversePrimary: Color(0xFF569CD6), // VS Code's blue
    surfaceTint: Color(0xFF007ACC), // Used for highlights
  );
}
