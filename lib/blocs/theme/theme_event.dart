import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class SetInitialTheme extends ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  final ThemeMode themeMode;
  ChangeTheme(this.themeMode);
}
