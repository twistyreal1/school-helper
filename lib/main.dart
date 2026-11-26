import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/topic_model.dart';
import 'screens/loading_screen.dart';
import 'services/user_prefs_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Включаем edge-to-edge для прозрачной навигационной панели на Android
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final prefs = UserPrefsService();
  await prefs.init();

  runApp(const SchoolHelperApp());
}

class SchoolHelperApp extends StatelessWidget {
  final Widget? homeOverride;

  const SchoolHelperApp({
    super.key,
    this.homeOverride,
  });

  @override
  Widget build(BuildContext context) {
    final prefs = UserPrefsService();

    return ListenableBuilder(
      listenable: prefs,
      builder: (context, _) {
        final isDark = prefs.themeMode == AppThemeMode.midnightCyber;
        final overlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarContrastEnforced: false,
        );

        SystemChrome.setSystemUIOverlayStyle(overlayStyle);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlayStyle,
          child: MaterialApp(
            title: 'Классмейт',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(prefs.themeMode),
            themeAnimationDuration: const Duration(milliseconds: 380),
            themeAnimationCurve: Curves.easeInOutCubic,
            scrollBehavior: const SmoothScrollBehavior(),
            home: homeOverride ?? const LoadingScreen(),
          ),
        );
      },
    );
  }
}

/// Глобальное плавное поведение прокрутки с физикой Bouncing и кинематической инерцией
class SmoothScrollBehavior extends MaterialScrollBehavior {
  const SmoothScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}
