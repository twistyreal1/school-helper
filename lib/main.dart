import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';
import 'services/user_prefs_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        return MaterialApp(
          title: 'Классмейт',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(prefs.themeMode),
          themeAnimationDuration: const Duration(milliseconds: 250),
          themeAnimationCurve: Curves.easeInOut,
          home: homeOverride ?? const LoadingScreen(),
        );
      },
    );
  }
}
