import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:maintain_chat_app/bloc/theme/themeState.dart';
import 'package:maintain_chat_app/utils/colorUtils.dart';
import 'package:maintain_chat_app/utils/localeUtils.dart';
import 'package:maintain_chat_app/utils/themeUtils.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final Box box = Hive.box('settings');

  ThemeCubit()
    : super(
        ThemeState(
          color: ColorUtils.parseColor(
            Hive.box('settings').get('color', defaultValue: '0xFF29B6F6'),
          ),
          fontSize: Hive.box('settings').get('fontSize', defaultValue: 16.0),
          themeMode: ThemeUtils.staticThemeDataFromString(
            Hive.box('settings').get('themeMode', defaultValue: 'Light'),
          ),
          lang: LocaleUtils.stringToLocale(
            Hive.box('settings').get('lang', defaultValue: 'vi'),
          ),
        ),
      );
  void changeThemeMode(String mode) {
    log('Change theme mode to: $mode');
    box.put('themeMode', mode);
    emit(state.copyWith(themeMode: ThemeUtils.staticThemeDataFromString(mode)));
  }
  void changeColor(String colorHex) {
    log('Change color to: $colorHex');
    box.put('color', colorHex);
    emit(state.copyWith(color: ColorUtils.parseColor(colorHex)));
  }
  void changeFontSize(double fontSize) {
    log('Change font size to: $fontSize');
    box.put('fontSize', fontSize);
    emit(state.copyWith(fontSize: fontSize));
  }
  void changeLanguage(String langCode) {
    log('Change language to: $langCode');
    box.put('lang', langCode);
    emit(state.copyWith(lang: LocaleUtils.stringToLocale(langCode)));
  } 

  void changeSetting(
    String? lang,
    String? themeMode,
    double? fontSize,
    String? color,
  ) {
    // Lưu vào Hive nếu có giá trị mới
    if (lang != null) box.put('lang', lang);
    if (themeMode != null) box.put('themeMode', themeMode);
    if (fontSize != null) box.put('fontSize', fontSize);
    if (color != null) box.put('color', color);

    // Lấy giá trị hiện tại nếu tham số là null
    // final String newLang =
    //     lang ?? LocaleUtils.localeToString(state.lang ?? Locale('vi'));
    
    final String newThemeMode =
        themeMode ??
        ThemeUtils.themeModeToString(state.themeMode ?? ThemeMode.light);
    final double? newFontSize = fontSize ?? state.fontSize;
    final String newColor =
        color ?? ColorUtils.colorToHex(state.color ?? Color(0xFF2196F3));

    emit(
      state.copyWith(
        // lang: LocaleUtils.stringToLocale(newLang),
        color: ColorUtils.parseColor(newColor),
        fontSize: newFontSize,
        themeMode: ThemeUtils.staticThemeDataFromString(newThemeMode),
      ),
    );
  }
}
