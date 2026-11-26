import 'package:flutter/material.dart';

/// Красивый маршрут перехода из Онбординга в Главное меню
PageRouteBuilder<void> createOnboardingToHomeRoute(Widget target) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 650),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) => target,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Плавная органичная кривая
      const fluidCurve = Cubic(0.16, 1.0, 0.3, 1.0);
      final curved = CurvedAnimation(
        parent: animation,
        curve: fluidCurve,
        reverseCurve: Curves.easeInCubic,
      );

      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}

/// Премиальный, ультра-плавный кинематический слайд-маршрут (iOS / Material 3 Fluid Style)
class SmoothSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SmoothSlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Элегантная кинематическая кривая без рывков
            const enterCurve = Cubic(0.2, 0.0, 0.0, 1.0);
            const exitCurve = Cubic(0.3, 0.0, 0.7, 0.0);

            final primaryCurved = CurvedAnimation(
              parent: animation,
              curve: enterCurve,
              reverseCurve: exitCurve,
            );

            // Анимация открываемой страницы (плавное кинематическое выплывание без тяжелых масштабирований)
            final enterSlide = Tween<Offset>(
              begin: const Offset(0.08, 0.0),
              end: Offset.zero,
            ).animate(primaryCurved);

            final enterFade = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(primaryCurved);

            return SlideTransition(
              position: enterSlide,
              child: FadeTransition(
                opacity: enterFade,
                child: child,
              ),
            );
          },
        );
}

/// Виджет интерактивного тактильного нажатия с приятным пружинным откликом (Spring Bounce)
class PressableBounce extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleFactor;
  final Duration duration;
  final HitTestBehavior behavior;

  const PressableBounce({
    super.key,
    required this.child,
    this.onTap,
    this.scaleFactor = 0.965,
    this.duration = const Duration(milliseconds: 110),
    this.behavior = HitTestBehavior.opaque,
  });

  @override
  State<PressableBounce> createState() => _PressableBounceState();
}

class _PressableBounceState extends State<PressableBounce> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: const Duration(milliseconds: 240),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) {
      return widget.child;
    }

    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
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

        // Поддержка быстрого свайпа для закрытия
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
