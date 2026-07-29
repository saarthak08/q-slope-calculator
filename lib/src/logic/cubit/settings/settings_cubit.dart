import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(themeMode: ThemeMode.system));
  final String themeModeSettingKey = "themeMode";

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex =
        prefs.getInt(themeModeSettingKey) ?? ThemeMode.system.index;
    emit(SettingsState(themeMode: ThemeMode.values[themeIndex]));
  }

  void setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeModeSettingKey, mode.index);
    emit(state.copyWith(themeMode: mode));
  }
}
