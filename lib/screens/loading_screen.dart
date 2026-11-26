import 'package:flutter/material.dart';
import '../services/user_prefs_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/page_transitions.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

/// Экран с потрясающей анимацией загрузки в стиле Liquid Glass.
/// Загружает базу данных, инициализирует профиль и плавно переходит в приложение.
class LoadingScreen extends StatefulWidget {
  final bool isPreview;

  const LoadingScreen({
    super.key,
    this.isPreview = false,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;

  final String _statusText = 'Загрузка справочника...';

  @override
  void initState() {
    super.initState();

    // 1. Анимация мягкого дыхания логотипа
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    // 2. Анимация прогресса загрузки (быстрый запуск для слабых устройств)
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onLoadingCompleted();
      }
    });

    _progressController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _onLoadingCompleted() {
    if (!mounted) return;

    if (widget.isPreview) {
      Navigator.of(context).maybePop();
      return;
    }

    final prefs = UserPrefsService();
    final targetScreen = prefs.isOnboarded ? const HomeScreen() : const OnboardingScreen();

    Navigator.of(context).pushReplacement(
      createOnboardingToHomeRoute(targetScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: LiquidGlassBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Плавающий блок с логотипом и жидким сиянием
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Жидкое световое кольцо вокруг логотипа
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  theme.colorScheme.primary.withValues(alpha: isDark ? 0.45 : 0.25),
                                  theme.colorScheme.primary.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                          const AppLogo(size: 96, hasShadow: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Название приложения
                    Text(
                      'Классмейт',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Умный помощник по учебе 5–11 классов',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Карточка загрузки в стиле Liquid Glass
                    LiquidGlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                      borderRadius: 24,
                      opacity: isDark ? 0.65 : 0.75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Фирменный анимированный жидкий индикатор
                          const LiquidLoadingIndicator(size: 58),
                          const SizedBox(height: 20),

                          // Текст статуса загрузки
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              _statusText,
                              key: ValueKey<String>(_statusText),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Глянцевая полоса прогресса (Liquid Progress Bar)
                          AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, _) {
                              final progress = _progressController.value;
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Stack(
                                        children: [
                                          FractionallySizedBox(
                                            widthFactor: progress.clamp(0.02, 1.0),
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    theme.colorScheme.secondary,
                                                    theme.colorScheme.primary,
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          FractionallySizedBox(
                                            widthFactor: progress.clamp(0.02, 1.0),
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              height: 2,
                                              color: Colors.white.withValues(alpha: 0.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Загрузка компонентов',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                        ),
                                      ),
                                      Text(
                                        '${(progress * 100).toInt()}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    if (widget.isPreview) ...[
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        label: const Text('Закрыть предпросмотр'),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
