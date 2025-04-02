import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'theme_event.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.system) {
    on<SetInitialTheme>(
      (event, emit) => emit(state),
    );

    on<ChangeTheme>((event, emit) {
      emit(event.themeMode);
    });
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    switch (json['themeMode'] as String?) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'themeMode': state.toString().split('.').last};
  }
}
