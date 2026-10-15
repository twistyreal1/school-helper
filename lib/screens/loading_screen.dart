import 'dart:async';
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

  double _progressValue = 0.0;
  String _statusText = 'Инициализация приложения...';
  Timer? _tipTimer;
  int _tipIndex = 0;

  final List<String> _loadingTips = [
    'Инициализация справочника...',
    'Загрузка формул по алгебре и геометрии...',
    'Подготовка интерактивных 2D чертежей...',
    'Сборка шпаргалок 5–11 классов...',
    'Настройка интерфейса Liquid Glass...',
    'Всё готово к отличной учебе! ✨',
  ];

  @override
  void initState() {
    super.initState();

    // 1. Анимация мягкого дыхания логотипа
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    // 2. Анимация прогресса загрузки
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _progressController.addListener(() {
      setState(() {
        _progressValue = _progressController.value;
      });
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onLoadingCompleted();
      }
    });

    _progressController.forward();

    // 3. Смена обучающих подсказок в процессе загрузки
    _tipTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!mounted) return;
      final newIndex = ((_progressValue * (_loadingTips.length - 1)).clamp(0, _loadingTips.length - 1)).toInt();
      if (newIndex != _tipIndex) {
        setState(() {
          _tipIndex = newIndex;
          _statusText = _loadingTips[_tipIndex];
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _tipTimer?.cancel();
    super.dispose();
  }

  void _onLoadingCompleted() async {
    await Future.delayed(const Duration(milliseconds: 300));
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
                                    widthFactor: _progressValue.clamp(0.02, 1.0),
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
                                  // Блик света на прогресс-баре
                                  FractionallySizedBox(
                                    widthFactor: _progressValue.clamp(0.02, 1.0),
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

                          // Процент выполнения
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
                                '${(_progressValue * 100).toInt()}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
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
