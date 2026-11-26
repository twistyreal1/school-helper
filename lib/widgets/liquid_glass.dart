import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Виджет динамического фона с легким градиентным свечением.
/// Оптимизирован для ультра-бюджетных устройств (0 FPS-просадок, без тикеров и без тяжелых шейдеров размытия).
class LiquidGlassBackground extends StatelessWidget {
  final Widget? child;
  final List<Color>? orbColors;
  final bool animate;

  const LiquidGlassBackground({
    super.key,
    this.child,
    this.orbColors,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final baseBg = theme.scaffoldBackgroundColor;

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Гарантированно непрозрачный базовый фон темы (устраняет просвечивание белого окна/браузера)
        ColoredBox(color: baseBg),

        // 2. Мягкое глубокое свечение сверху-слева (в темной теме - глубокий индиго/неон)
        Positioned(
          top: -140,
          left: -100,
          width: 520,
          height: 520,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isDark ? secondary : primary).withValues(alpha: isDark ? 0.24 : 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // 3. Мягкое глубокое свечение снизу-справа (в темной теме - лазурный сапфир)
        Positioned(
          bottom: -120,
          right: -80,
          width: 480,
          height: 480,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isDark ? primary : secondary).withValues(alpha: isDark ? 0.18 : 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // 4. Контент
        if (child != null) RepaintBoundary(child: child!),
      ],
    );
  }
}

/// Фирменный контейнер Liquid Glass с матовым размытием, глянцевыми бликами и градиентной каймой.
class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Border? border;
  final Color? tintColor;
  final List<BoxShadow>? shadows;
  final bool hasSpecularHighlight;
  final VoidCallback? onTap;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.blur = 20.0,
    this.opacity = 0.65,
    this.borderRadius = 24.0,
    this.padding,
    this.margin,
    this.border,
    this.tintColor,
    this.shadows,
    this.hasSpecularHighlight = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveTint = tintColor ??
        (isDark
            ? theme.colorScheme.surface.withValues(alpha: opacity)
            : Colors.white.withValues(alpha: opacity));

    final effectiveBorder = border ??
        Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.55),
          width: 1.2,
        );

    final effectiveShadows = shadows ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 28,
            offset: const Offset(0, 10),
            spreadRadius: -2,
          ),
          if (isDark)
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 36,
              offset: const Offset(0, 4),
            ),
        ];

    final bgTint = effectiveTint.withValues(
      alpha: (effectiveTint.a + (isDark ? 0.20 : 0.15)).clamp(0.0, 1.0),
    );

    Widget content = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgTint,
        borderRadius: BorderRadius.circular(borderRadius),
        border: effectiveBorder,
        boxShadow: effectiveShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
            if (hasSpecularHighlight)
              Positioned(
                top: 0,
                left: 12,
                right: 12,
                height: 1.5,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: isDark ? 0.40 : 0.75),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.08),
          child: content,
        ),
      );
    }

    return content;
  }
}

/// Карточка из жидкого стекла (Liquid Glass Card)
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? glowColor;
  final bool isSelected;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 24,
    this.onTap,
    this.glowColor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = glowColor ?? theme.colorScheme.primary;

    final border = Border.all(
      color: isSelected
          ? primary
          : (isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.65)),
      width: isSelected ? 2.0 : 1.2,
    );

    final shadows = <BoxShadow>[
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
      if (isSelected)
        BoxShadow(
          color: primary.withValues(alpha: isDark ? 0.35 : 0.22),
          blurRadius: 20,
          spreadRadius: 1,
        ),
    ];

    return LiquidGlassContainer(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      border: border,
      shadows: shadows,
      onTap: onTap,
      opacity: isDark ? (isSelected ? 0.75 : 0.60) : (isSelected ? 0.85 : 0.70),
      child: child,
    );
  }
}

class LiquidGlassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool isGlassy;

  const LiquidGlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.borderRadius = 18,
    this.isGlassy = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [
            bg,
            bg.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.38),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.28),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withValues(alpha: 0.25),
          highlightColor: Colors.white.withValues(alpha: 0.12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              children: [
                // Внутренний зеркальный блик
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 18,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.35),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: padding,
                  child: Center(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: foregroundColor ?? Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Анимированный индикатор загрузки из жидкого стекла (Liquid Loading Indicator)
class LiquidLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final Color? secondaryColor;

  const LiquidLoadingIndicator({
    super.key,
    this.size = 64,
    this.color,
    this.secondaryColor,
  });

  @override
  State<LiquidLoadingIndicator> createState() => _LiquidLoadingIndicatorState();
}

class _LiquidLoadingIndicatorState extends State<LiquidLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c1 = widget.color ?? theme.colorScheme.primary;
    final c2 = widget.secondaryColor ?? theme.colorScheme.secondary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _LiquidProgressPainter(
            rotation: _controller.value * 2 * math.pi,
            pulse: (math.sin(_controller.value * 2 * math.pi) + 1.0) / 2.0,
            primaryColor: c1,
            secondaryColor: c2,
          ),
        );
      },
    );
  }
}

class _LiquidProgressPainter extends CustomPainter {
  final double rotation;
  final double pulse;
  final Color primaryColor;
  final Color secondaryColor;

  _LiquidProgressPainter({
    required this.rotation,
    required this.pulse,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.10;

    // Фоновое полупрозрачное кольцо
    final bgPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Вращающаяся жидкая дуга с градиентом
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    final sweepRect = Rect.fromCircle(center: center, radius: radius);
    final sweepGradient = SweepGradient(
      colors: [
        primaryColor.withValues(alpha: 0.0),
        secondaryColor.withValues(alpha: 0.4),
        primaryColor,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final arcPaint = Paint()
      ..shader = sweepGradient.createShader(sweepRect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      0,
      math.pi * 1.5,
      false,
      arcPaint,
    );

    // Светящаяся жидкая капля на острие дуги
    final tipAngle = math.pi * 1.5;
    final tipR = radius - strokeWidth / 2;
    final tipCenter = Offset(
      center.dx + tipR * math.cos(tipAngle),
      center.dy + tipR * math.sin(tipAngle),
    );

    final tipGlow = Paint()
      ..color = primaryColor.withValues(alpha: 0.6 + 0.4 * pulse)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6.0 + 4.0 * pulse);
    canvas.drawCircle(tipCenter, strokeWidth * 0.8, tipGlow);

    final tipCore = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(tipCenter, strokeWidth * 0.45, tipCore);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LiquidProgressPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.pulse != pulse ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
