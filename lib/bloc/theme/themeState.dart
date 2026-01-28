import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final Color? color;
  final double? fontSize;
  final ThemeMode? themeMode;
  final Locale? lang;

  const ThemeState({this.color, this.fontSize, this.themeMode, this.lang});

  @override
  List<Object?> get props => [color, fontSize, themeMode, lang];

  ThemeState copyWith({
    Color? color,
    double? fontSize,
    ThemeMode? themeMode,
    Locale? lang,
  }) {
    return ThemeState(
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
      themeMode: themeMode ?? this.themeMode,
      lang: lang ?? this.lang,
    );
  }
}
