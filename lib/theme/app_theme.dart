import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/topic_model.dart';

class AppTheme {
  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.modernBlue:
        return _buildLightTheme(
          primary: const Color(0xFF2563EB),
          secondary: const Color(0xFF0284C7),
          background: const Color(0xFFF8FAFC),
          cardColor: Colors.white,
          accentColor: const Color(0xFF4F46E5),
          textPrimary: const Color(0xFF0F172A),
          textSecondary: const Color(0xFF64748B),
          brightness: Brightness.light,
        );
      case AppThemeMode.midnightCyber:
        return _buildDarkTheme(
          primary: const Color(0xFF38BDF8),
          secondary: const Color(0xFF6366F1),
          background: const Color(0xFF07090E),
          cardColor: const Color(0xFF111420),
          accentColor: const Color(0xFFA855F7),
          textPrimary: const Color(0xFFF8FAFC),
          textSecondary: const Color(0xFF94A3B8),
          brightness: Brightness.dark,
        );
      case AppThemeMode.emeraldMatcha:
        return _buildLightTheme(
          primary: const Color(0xFF059669),
          secondary: const Color(0xFF10B981),
          background: const Color(0xFFF2F7F4),
          cardColor: Colors.white,
          accentColor: const Color(0xFF047857),
          textPrimary: const Color(0xFF132A1C),
          textSecondary: const Color(0xFF4A6253),
          brightness: Brightness.light,
        );
      case AppThemeMode.warmNotebook:
        return _buildLightTheme(
          primary: const Color(0xFFD97706),
          secondary: const Color(0xFFEA580C),
          background: const Color(0xFFFAF7EE),
          cardColor: const Color(0xFFFFFDF8),
          accentColor: const Color(0xFFB45309),
          textPrimary: const Color(0xFF2E2722),
          textSecondary: const Color(0xFF786F66),
          brightness: Brightness.light,
        );
    }
  }

  static ThemeData _buildLightTheme({
    required Color primary,
    required Color secondary,
    required Color background,
    required Color cardColor,
    required Color accentColor,
    required Color textPrimary,
    required Color textSecondary,
    required Brightness brightness,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: cardColor,
        surfaceContainerHighest: background,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: false,
        ),
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: textSecondary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide.none,
      ),
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData _buildDarkTheme({
    required Color primary,
    required Color secondary,
    required Color background,
    required Color cardColor,
    required Color accentColor,
    required Color textPrimary,
    required Color textSecondary,
    required Brightness brightness,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: cardColor,
        surfaceContainerHighest: const Color(0xFF181C2E),
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarContrastEnforced: false,
        ),
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide.none,
      ),
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
