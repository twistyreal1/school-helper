import 'package:flutter/material.dart';

/// Фирменная иконка приложения: шапочка выпускника / студенческая шляпа (конфедератка)
/// на гладком сквиркле с ярко-синим градиентом в точности как на референсе пользователя.
class AppLogo extends StatelessWidget {
  final double size;
  final bool hasShadow;

  const AppLogo({
    super.key,
    this.size = 56,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(size * 0.28);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2F6FED), // Яркий электрик / королевский синий
            Color(0xFF1B4CD0), // Насыщенный синий
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: (size * 0.02).clamp(1.0, 2.5),
        ),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: const Color(0xFF1B4CD0).withValues(alpha: 0.4),
                  blurRadius: size * 0.28,
                  offset: Offset(0, size * 0.12),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: size * 0.1,
                  offset: Offset(0, size * 0.04),
                ),
              ]
            : null,
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.72,
          height: size * 0.72,
          child: CustomPaint(
            painter: const GraduationCapPainter(),
          ),
        ),
      ),
    );
  }
}

/// Векторный рендерер студенческой шляпы (конфедератки) с кисточкой
class GraduationCapPainter extends CustomPainter {
  final Color color;

  const GraduationCapPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = (w * 0.055).clamp(1.5, 5.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // 1. Нижняя часть шапочки (ободок / купол под ромбом)
    final capPath = Path();
    capPath.moveTo(w * 0.23, h * 0.52);
    capPath.lineTo(w * 0.23, h * 0.67);
    capPath.cubicTo(
      w * 0.33, h * 0.81,
      w * 0.67, h * 0.81,
      w * 0.77, h * 0.67,
    );
    capPath.lineTo(w * 0.77, h * 0.52);
    capPath.cubicTo(
      w * 0.67, h * 0.61,
      w * 0.33, h * 0.61,
      w * 0.23, h * 0.52,
    );
    capPath.close();
    canvas.drawPath(capPath, fillPaint);

    // 2. Верхняя 4-угольная плоскость (ромб конфедератки)
    final boardPath = Path();
    boardPath.moveTo(w * 0.50, h * 0.22); // верхний угол
    boardPath.lineTo(w * 0.89, h * 0.43); // правый угол
    boardPath.lineTo(w * 0.50, h * 0.64); // нижний угол
    boardPath.lineTo(w * 0.11, h * 0.43); // левый угол
    boardPath.close();
    canvas.drawPath(boardPath, fillPaint);

    // 3. Кисточка шляпы (шнурок + кисточка)
    final tasselPath = Path();
    tasselPath.moveTo(w * 0.50, h * 0.43); // пуговка
    tasselPath.lineTo(w * 0.84, h * 0.48); // край ромба
    tasselPath.lineTo(w * 0.84, h * 0.74); // свисает вниз
    canvas.drawPath(tasselPath, strokePaint);

    // Наконечник кисточки (свисающая капля / пучок)
    final tipRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.84, h * 0.79),
        width: w * 0.08,
        height: h * 0.13,
      ),
      Radius.circular(w * 0.04),
    );
    canvas.drawRRect(tipRect, fillPaint);

    // Центральная пуговица на ромбе
    canvas.drawCircle(Offset(w * 0.50, h * 0.43), w * 0.04, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

