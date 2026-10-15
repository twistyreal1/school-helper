import 'package:flutter/material.dart';

/// Красивый маршрут перехода из Онбординга в Главное меню
PageRouteBuilder<void> createOnboardingToHomeRoute(Widget target) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) => target,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.05),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}

/// Плавный слайд-маршрут для открытия категорий и тем
class SmoothSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SmoothSlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 320),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            // Плавное выкатывание справа + легкий фейд
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.25, 0.0),
                end: Offset.zero,
              ).animate(curved),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
        );
}

/// Обертка для экранов с возможностью выйти свайпом влево (или вправо)
class SwipeBackWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onBack;

  const SwipeBackWrapper({
    super.key,
    required this.child,
    this.onBack,
  });

  @override
  State<SwipeBackWrapper> createState() => _SwipeBackWrapperState();
}

class _SwipeBackWrapperState extends State<SwipeBackWrapper> {
  double _dragDistance = 0.0;
  bool _isExiting = false;

  void _triggerPop() {
    if (_isExiting) return;
    _isExiting = true;
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (_) {
        _dragDistance = 0.0;
      },
      onHorizontalDragUpdate: (details) {
        _dragDistance += details.primaryDelta ?? 0;
      },
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;

        // Пользователь просил: свайп влево для выхода (палец движется влево, _dragDistance < -60)
        // Также поддерживаем и классический жест вправо (velocity > 300 или _dragDistance > 80)
        final isSwipeLeft = _dragDistance < -60 || velocity < -350;
        final isSwipeRight = _dragDistance > 70 || velocity > 350;

        if (isSwipeLeft || isSwipeRight) {
          _triggerPop();
        }
        _dragDistance = 0.0;
      },
      child: widget.child,
    );
  }
}
