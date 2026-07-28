import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:q_slope_calculator/src/logic/cubit/settings/settings_cubit.dart';

void main() {
  group('SettingsCubit', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is ThemeMode.system', () {
      final cubit = SettingsCubit();
      expect(cubit.state.themeMode, ThemeMode.system);
      cubit.close();
    });

    blocTest<SettingsCubit, SettingsState>(
      'loadSettings emits state with saved ThemeMode.dark',
      build: () {
        SharedPreferences.setMockInitialValues({'themeMode': ThemeMode.dark.index});
        return SettingsCubit();
      },
      act: (cubit) => cubit.loadSettings(),
      expect: () => [
        isA<SettingsState>().having((state) => state.themeMode, 'themeMode', ThemeMode.dark),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'setThemeMode updates state and SharedPreferences',
      build: () => SettingsCubit(),
      act: (cubit) => cubit.setThemeMode(ThemeMode.light),
      expect: () => [
        isA<SettingsState>().having((state) => state.themeMode, 'themeMode', ThemeMode.light),
      ],
      verify: (_) async {
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('themeMode'), ThemeMode.light.index);
      },
    );
  });
}
