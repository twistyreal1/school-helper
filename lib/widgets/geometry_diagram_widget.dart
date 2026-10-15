import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Виджет для векторной отрисовки геометрических фигур
class GeometryDiagramWidget extends StatelessWidget {
  final String figureType;
  final String? caption;

  const GeometryDiagramWidget({
    super.key,
    required this.figureType,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : const Color(0xFFF3F7FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.architecture_rounded, color: primary, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getFigureTitle(figureType),
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: primary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: CustomPaint(
              painter: _GeometryPainter(
                figureType: figureType,
                primaryColor: primary,
                textColor: onSurface,
                accentColor: Colors.deepOrange,
                isDark: isDark,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          if (caption != null && caption!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                caption!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: onSurface.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _getFigureTitle(String type) {
    switch (type) {
      case 'parallelogram':
        return 'Параллелограмм: стороны, углы и диагонали';
      case 'trapezoid':
        return 'Трапеция: основания a, b, высота h и средняя линия';
      case 'rectangle':
        return 'Прямоугольник: прямые углы и равные диагонали';
      case 'rhombus':
        return 'Ромб: равные стороны и перпендикулярные диагонали';
      case 'square':
        return 'Квадрат: все стороны равны, углы 90°';
      case 'right_triangle':
        return 'Прямоугольный треугольник и теорема Пифагора';
      case 'similar_triangles':
        return 'Подобные треугольники: соответственные углы и стороны';
      case 'triangle_midline':
        return 'Средняя линия треугольника: MN = ½ AC, MN ∥ AC';
      case 'trig_triangle':
        return 'Тригонометрические функции острого угла (sin, cos, tg)';
      case 'circle_tangent':
        return 'Касательная к окружности: радиус перпендикулярен касательной';
      case 'circle_angles':
        return 'Вписанный и центральный углы окружности';
      case 'inscribed_quad':
        return 'Вписанный четырехугольник (сумма противоположных углов 180°)';
      case 'circumscribed_quad':
        return 'Описанный четырехугольник (суммы противоположных сторон равны)';
      default:
        return 'Геометрический чертёж';
    }
  }
}

class _GeometryPainter extends CustomPainter {
  final String figureType;
  final Color primaryColor;
  final Color textColor;
  final Color accentColor;
  final bool isDark;

  _GeometryPainter({
    required this.figureType,
    required this.primaryColor,
    required this.textColor,
    required this.accentColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = primaryColor.withValues(alpha: isDark ? 0.15 : 0.1)
      ..style = PaintingStyle.fill;

    final auxPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    switch (figureType) {
      case 'parallelogram':
        _drawParallelogram(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'trapezoid':
        _drawTrapezoid(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'rectangle':
        _drawRectangle(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'rhombus':
        _drawRhombus(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'square':
        _drawSquare(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'right_triangle':
        _drawRightTriangle(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'similar_triangles':
        _drawSimilarTriangles(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'triangle_midline':
        _drawTriangleMidline(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'trig_triangle':
        _drawTrigTriangle(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'circle_tangent':
        _drawCircleTangent(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'circle_angles':
        _drawCircleAngles(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'inscribed_quad':
        _drawInscribedQuad(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      case 'circumscribed_quad':
        _drawCircumscribedQuad(canvas, size, strokePaint, fillPaint, auxPaint);
        break;
      default:
        _drawParallelogram(canvas, size, strokePaint, fillPaint, auxPaint);
    }
  }

  void _drawParallelogram(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final pA = Offset(w * 0.18, h * 0.82);
    final pB = Offset(w * 0.38, h * 0.22);
    final pC = Offset(w * 0.86, h * 0.22);
    final pD = Offset(w * 0.66, h * 0.82);

    final path = Path()
      ..moveTo(pA.dx, pA.dy)
      ..lineTo(pB.dx, pB.dy)
      ..lineTo(pC.dx, pC.dy)
      ..lineTo(pD.dx, pD.dy)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    // Диагонали
    final dashPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pA, pC, dashPaint);
    canvas.drawLine(pB, pD, dashPaint);

    // Высота
    final pH = Offset(pB.dx, pA.dy);
    canvas.drawLine(pB, pH, aux);
    _drawRightAngle(canvas, pH, true, aux);

    // Подписи
    _drawLabel(canvas, 'A', Offset(pA.dx - 16, pA.dy - 6));
    _drawLabel(canvas, 'B', Offset(pB.dx - 14, pB.dy - 18));
    _drawLabel(canvas, 'C', Offset(pC.dx + 6, pC.dy - 18));
    _drawLabel(canvas, 'D', Offset(pD.dx + 6, pD.dy - 6));
    _drawLabel(canvas, 'h', Offset(pB.dx + 4, (pB.dy + pH.dy) / 2 - 8), color: accentColor);
    _drawLabel(canvas, 'a', Offset((pA.dx + pD.dx) / 2, pA.dy + 4));
    _drawLabel(canvas, 'b', Offset((pA.dx + pB.dx) / 2 - 16, (pA.dy + pB.dy) / 2 - 8));
  }

  void _drawTrapezoid(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final pA = Offset(w * 0.12, h * 0.82);
    final pB = Offset(w * 0.32, h * 0.24);
    final pC = Offset(w * 0.72, h * 0.24);
    final pD = Offset(w * 0.88, h * 0.82);

    final path = Path()
      ..moveTo(pA.dx, pA.dy)
      ..lineTo(pB.dx, pB.dy)
      ..lineTo(pC.dx, pC.dy)
      ..lineTo(pD.dx, pD.dy)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    // Высота
    final pH = Offset(pB.dx, pA.dy);
    canvas.drawLine(pB, pH, aux);
    _drawRightAngle(canvas, pH, true, aux);

    // Средняя линия MN
    final pM = Offset((pA.dx + pB.dx) / 2, (pA.dy + pB.dy) / 2);
    final pN = Offset((pC.dx + pD.dx) / 2, (pC.dy + pD.dy) / 2);
    final midPaint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pM, pN, midPaint);

    // Подписи
    _drawLabel(canvas, 'A', Offset(pA.dx - 16, pA.dy - 6));
    _drawLabel(canvas, 'B', Offset(pB.dx - 14, pB.dy - 18));
    _drawLabel(canvas, 'C', Offset(pC.dx + 6, pC.dy - 18));
    _drawLabel(canvas, 'D', Offset(pD.dx + 6, pD.dy - 6));
    _drawLabel(canvas, 'b (верхнее)', Offset((pB.dx + pC.dx) / 2 - 32, pB.dy - 18));
    _drawLabel(canvas, 'a (нижнее)', Offset((pA.dx + pD.dx) / 2 - 30, pA.dy + 4));
    _drawLabel(canvas, 'h', Offset(pB.dx + 4, (pB.dy + pH.dy) / 2 - 8), color: accentColor);
    _drawLabel(canvas, 'm = (a+b)/2', Offset((pM.dx + pN.dx) / 2 - 30, pM.dy - 16), color: Colors.teal);
  }

  void _drawRectangle(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final pA = Offset(w * 0.18, h * 0.8);
    final pB = Offset(w * 0.18, h * 0.22);
    final pC = Offset(w * 0.82, h * 0.22);
    final pD = Offset(w * 0.82, h * 0.8);

    final rect = Rect.fromPoints(pB, pD);
    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, stroke);

    // Диагонали
    final diagPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.4;
    canvas.drawLine(pA, pC, diagPaint);
    canvas.drawLine(pB, pD, diagPaint);

    // Прямой угол в А
    _drawRightAngle(canvas, pA, false, aux, flipY: true);

    _drawLabel(canvas, 'A', Offset(pA.dx - 16, pA.dy - 6));
    _drawLabel(canvas, 'B', Offset(pB.dx - 16, pB.dy - 16));
    _drawLabel(canvas, 'C', Offset(pC.dx + 6, pC.dy - 16));
    _drawLabel(canvas, 'D', Offset(pD.dx + 6, pD.dy - 6));
    _drawLabel(canvas, 'a', Offset((pA.dx + pD.dx) / 2, pA.dy + 4));
    _drawLabel(canvas, 'b', Offset(pA.dx - 16, (pA.dy + pB.dy) / 2 - 8));
    _drawLabel(canvas, 'd₁ = d₂', Offset((pA.dx + pC.dx) / 2 - 20, (pA.dy + pC.dy) / 2 - 16), color: accentColor);
  }

  void _drawRhombus(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final pTop = Offset(w * 0.5, h * 0.15);
    final pRight = Offset(w * 0.86, h * 0.52);
    final pBottom = Offset(w * 0.5, h * 0.88);
    final pLeft = Offset(w * 0.14, h * 0.52);

    final path = Path()
      ..moveTo(pTop.dx, pTop.dy)
      ..lineTo(pRight.dx, pRight.dy)
      ..lineTo(pBottom.dx, pBottom.dy)
      ..lineTo(pLeft.dx, pLeft.dy)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    // Диагонали (взаимно перпендикулярны)
    canvas.drawLine(pTop, pBottom, aux);
    canvas.drawLine(pLeft, pRight, aux);

    final pO = Offset(w * 0.5, h * 0.52);
    _drawRightAngle(canvas, pO, false, stroke);

    _drawLabel(canvas, 'B', Offset(pTop.dx - 6, pTop.dy - 18));
    _drawLabel(canvas, 'C', Offset(pRight.dx + 6, pRight.dy - 8));
    _drawLabel(canvas, 'D', Offset(pBottom.dx - 6, pBottom.dy + 4));
    _drawLabel(canvas, 'A', Offset(pLeft.dx - 16, pLeft.dy - 8));
    _drawLabel(canvas, 'd₁ ⊥ d₂', Offset(pO.dx + 6, pO.dy + 6), color: accentColor);
  }

  void _drawSquare(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final side = math.min(w * 0.55, h * 0.7);
    final left = (w - side) / 2;
    final top = (h - side) / 2;

    final rect = Rect.fromLTWH(left, top, side, side);
    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, stroke);

    // Диагонали
    canvas.drawLine(rect.topLeft, rect.bottomRight, aux);
    canvas.drawLine(rect.bottomLeft, rect.topRight, aux);

    _drawLabel(canvas, 'a', Offset(rect.center.dx, rect.bottom + 4));
    _drawLabel(canvas, 'a', Offset(rect.left - 16, rect.center.dy - 8));
    _drawLabel(canvas, 'S = a²', Offset(rect.center.dx - 22, rect.center.dy - 18), color: accentColor);
  }

  void _drawRightTriangle(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final pC = Offset(w * 0.2, h * 0.82); // Прямой угол
    final pA = Offset(w * 0.82, h * 0.82);
    final pB = Offset(w * 0.2, h * 0.2);

    final path = Path()
      ..moveTo(pC.dx, pC.dy)
      ..lineTo(pA.dx, pA.dy)
      ..lineTo(pB.dx, pB.dy)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    // Прямой угол в С
    _drawRightAngle(canvas, pC, true, aux);

    // Высота к гипотенузе
    // Проекция точки С на АВ
    final abVec = pA - pB;
    final cbVec = pC - pB;
    final t = (cbVec.dx * abVec.dx + cbVec.dy * abVec.dy) / (abVec.dx * abVec.dx + abVec.dy * abVec.dy);
    final pH = Offset(pB.dx + abVec.dx * t, pB.dy + abVec.dy * t);

    final dashPaint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 1.8;
    canvas.drawLine(pC, pH, dashPaint);

    _drawLabel(canvas, 'C (90°)', Offset(pC.dx - 20, pC.dy + 4));
    _drawLabel(canvas, 'A', Offset(pA.dx + 6, pA.dy - 6));
    _drawLabel(canvas, 'B', Offset(pB.dx - 16, pB.dy - 18));
    _drawLabel(canvas, 'a (катет)', Offset(pC.dx - 32, (pC.dy + pB.dy) / 2 - 8));
    _drawLabel(canvas, 'b (катет)', Offset((pC.dx + pA.dx) / 2 - 20, pC.dy + 4));
    _drawLabel(canvas, 'c (гипотенуза)', Offset((pA.dx + pB.dx) / 2 + 10, (pA.dy + pB.dy) / 2 - 12), color: accentColor);
    _drawLabel(canvas, 'h_c', Offset((pC.dx + pH.dx) / 2 - 14, (pC.dy + pH.dy) / 2 - 14), color: Colors.teal);
  }

  void _drawSimilarTriangles(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    // Первый треугольник ABC (меньший)
    final pA1 = Offset(w * 0.08, h * 0.82);
    final pB1 = Offset(w * 0.22, h * 0.35);
    final pC1 = Offset(w * 0.38, h * 0.82);

    final path1 = Path()
      ..moveTo(pA1.dx, pA1.dy)
      ..lineTo(pB1.dx, pB1.dy)
      ..lineTo(pC1.dx, pC1.dy)
      ..close();
    canvas.drawPath(path1, fill);
    canvas.drawPath(path1, stroke);

    // Второй треугольник A'B'C' (больший, подобный с коэффициентом k)
    final pA2 = Offset(w * 0.48, h * 0.82);
    final pB2 = Offset(w * 0.7, h * 0.16);
    final pC2 = Offset(w * 0.94, h * 0.82);

    final path2 = Path()
      ..moveTo(pA2.dx, pA2.dy)
      ..lineTo(pB2.dx, pB2.dy)
      ..lineTo(pC2.dx, pC2.dy)
      ..close();
    canvas.drawPath(path2, fill);
    canvas.drawPath(path2, stroke);

    _drawLabel(canvas, 'A', Offset(pA1.dx - 14, pA1.dy - 6));
    _drawLabel(canvas, 'B', Offset(pB1.dx - 6, pB1.dy - 18));
    _drawLabel(canvas, 'C', Offset(pC1.dx + 4, pC1.dy - 6));

    _drawLabel(canvas, 'A₁', Offset(pA2.dx - 16, pA2.dy - 6));
    _drawLabel(canvas, 'B₁', Offset(pB2.dx - 6, pB2.dy - 18));
    _drawLabel(canvas, 'C₁', Offset(pC2.dx + 4, pC2.dy - 6));

    _drawLabel(canvas, '△ABC ~ △A₁B₁C₁', Offset(w * 0.35, h * 0.06), color: accentColor);
    _drawLabel(canvas, 'k = A₁B₁/AB', Offset(w * 0.38, h * 0.9), color: primaryColor);
  }

  void _drawTriangleMidline(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final pA = Offset(w * 0.14, h * 0.82);
    final pB = Offset(w * 0.46, h * 0.18);
    final pC = Offset(w * 0.86, h * 0.82);

    final path = Path()
      ..moveTo(pA.dx, pA.dy)
      ..lineTo(pB.dx, pB.dy)
      ..lineTo(pC.dx, pC.dy)
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    // Средняя линия MN
    final pM = Offset((pA.dx + pB.dx) / 2, (pA.dy + pB.dy) / 2);
    final pN = Offset((pB.dx + pC.dx) / 2, (pB.dy + pC.dy) / 2);

    canvas.drawLine(pM, pN, aux);

    _drawLabel(canvas, 'A', Offset(pA.dx - 16, pA.dy - 6));
    _drawLabel(canvas, 'B', Offset(pB.dx - 6, pB.dy - 18));
    _drawLabel(canvas, 'C', Offset(pC.dx + 6, pC.dy - 6));
    _drawLabel(canvas, 'M', Offset(pM.dx - 18, pM.dy - 8), color: accentColor);
    _drawLabel(canvas, 'N', Offset(pN.dx + 6, pN.dy - 8), color: accentColor);
    _drawLabel(canvas, 'MN = ½ AC', Offset((pM.dx + pN.dx) / 2 - 28, pM.dy - 16), color: accentColor);
  }

  void _drawTrigTriangle(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final pC = Offset(w * 0.2, h * 0.82);
    final pA = Offset(w * 0.82, h * 0.82);
    final pB = Offset(w * 0.2, h * 0.22);

    final path = Path()
      ..moveTo(pC.dx, pC.dy)
      ..lineTo(pA.dx, pA.dy)
      ..lineTo(pB.dx, pB.dy)
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);

    _drawRightAngle(canvas, pC, true, aux);

    // Дуга угла альфа при вершине А
    final arcPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawArc(
      Rect.fromCircle(center: pA, radius: 32),
      math.pi,
      math.atan2(pB.dy - pA.dy, pB.dx - pA.dx) - math.pi,
      false,
      arcPaint,
    );

    _drawLabel(canvas, 'α', Offset(pA.dx - 44, pA.dy - 16), color: accentColor);
    _drawLabel(canvas, 'противолежащий катет (a)', Offset(pC.dx - 90, (pC.dy + pB.dy) / 2 - 8));
    _drawLabel(canvas, 'прилежащий катет (b)', Offset((pC.dx + pA.dx) / 2 - 40, pC.dy + 4));
    _drawLabel(canvas, 'гипотенуза (c)', Offset((pA.dx + pB.dx) / 2 + 10, (pA.dy + pB.dy) / 2 - 12), color: primaryColor);
  }

  void _drawCircleTangent(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final center = Offset(w * 0.44, h * 0.46);
    final radius = h * 0.36;

    // Окружность
    canvas.drawCircle(center, radius, fill);
    canvas.drawCircle(center, radius, stroke);

    // Центр О
    canvas.drawCircle(center, 3.5, Paint()..color = primaryColor);
    _drawLabel(canvas, 'O', Offset(center.dx - 16, center.dy - 14));

    // Точка касания А (снизу)
    final pA = Offset(center.dx, center.dy + radius);
    canvas.drawCircle(pA, 3.5, Paint()..color = accentColor);

    // Радиус OA
    canvas.drawLine(center, pA, aux);

    // Касательная прямая l
    final pLeft = Offset(w * 0.1, pA.dy);
    final pRight = Offset(w * 0.9, pA.dy);
    final linePaint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2.2;
    canvas.drawLine(pLeft, pRight, linePaint);

    // Прямой угол между радиусом и касательной
    _drawRightAngle(canvas, pA, true, aux, flipY: true);

    _drawLabel(canvas, 'A', Offset(pA.dx + 6, pA.dy + 4), color: accentColor);
    _drawLabel(canvas, 'R', Offset(center.dx + 4, center.dy + radius / 2 - 8), color: accentColor);
    _drawLabel(canvas, 'касательная прямая l', Offset(w * 0.58, pA.dy + 6), color: Colors.teal);
    _drawLabel(canvas, 'R ⊥ l', Offset(w * 0.65, center.dy - 10), color: accentColor);
  }

  void _drawCircleAngles(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final center = Offset(w * 0.5, h * 0.5);
    final radius = h * 0.38;

    canvas.drawCircle(center, radius, fill);
    canvas.drawCircle(center, radius, stroke);

    final pO = center;
    canvas.drawCircle(pO, 3.5, Paint()..color = primaryColor);

    // Точки дуги A и C
    final pA = Offset(pO.dx - radius * 0.8, pO.dy + radius * 0.6);
    final pC = Offset(pO.dx + radius * 0.8, pO.dy + radius * 0.6);

    // Точка В на окружности сверху (вписанный угол)
    final pB = Offset(pO.dx - radius * 0.3, pO.dy - radius * 0.95);

    // Центральный угол AOC
    canvas.drawLine(pO, pA, aux);
    canvas.drawLine(pO, pC, aux);

    // Вписанный угол ABC
    final inscribedPaint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2.0;
    canvas.drawLine(pB, pA, inscribedPaint);
    canvas.drawLine(pB, pC, inscribedPaint);

    _drawLabel(canvas, 'O', Offset(pO.dx - 14, pO.dy - 16));
    _drawLabel(canvas, 'A', Offset(pA.dx - 16, pA.dy));
    _drawLabel(canvas, 'C', Offset(pC.dx + 6, pC.dy));
    _drawLabel(canvas, 'B', Offset(pB.dx - 4, pB.dy - 18), color: Colors.teal);

    _drawLabel(canvas, '2α (центр.)', Offset(pO.dx - 18, pO.dy + 6), color: accentColor);
    _drawLabel(canvas, 'α (впис.)', Offset(pB.dx - 10, pB.dy + 14), color: Colors.teal);
  }

  void _drawInscribedQuad(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final center = Offset(w * 0.5, h * 0.5);
    final radius = h * 0.38;

    canvas.drawCircle(center, radius, fill);
    canvas.drawCircle(center, radius, Paint()..color = primaryColor.withValues(alpha: 0.4)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    final pA = Offset(center.dx - radius * 0.9, center.dy + radius * 0.4);
    final pB = Offset(center.dx - radius * 0.5, center.dy - radius * 0.86);
    final pC = Offset(center.dx + radius * 0.8, center.dy - radius * 0.6);
    final pD = Offset(center.dx + radius * 0.7, center.dy + radius * 0.7);

    final path = Path()
      ..moveTo(pA.dx, pA.dy)
      ..lineTo(pB.dx, pB.dy)
      ..lineTo(pC.dx, pC.dy)
      ..lineTo(pD.dx, pD.dy)
      ..close();

    canvas.drawPath(path, stroke);

    _drawLabel(canvas, 'A', Offset(pA.dx - 16, pA.dy));
    _drawLabel(canvas, 'B', Offset(pB.dx - 6, pB.dy - 18));
    _drawLabel(canvas, 'C', Offset(pC.dx + 6, pC.dy - 12));
    _drawLabel(canvas, 'D', Offset(pD.dx + 6, pD.dy + 4));

    _drawLabel(canvas, '∠A + ∠C = 180°', Offset(center.dx - 42, center.dy - 14), color: accentColor);
    _drawLabel(canvas, '∠B + ∠D = 180°', Offset(center.dx - 42, center.dy + 6), color: primaryColor);
  }

  void _drawCircumscribedQuad(Canvas canvas, Size size, Paint stroke, Paint fill, Paint aux) {
    final w = size.width;
    final h = size.height;

    final center = Offset(w * 0.5, h * 0.5);
    final radius = h * 0.32;

    // Вписанная окружность
    canvas.drawCircle(center, radius, fill);
    canvas.drawCircle(center, radius, Paint()..color = Colors.teal..style = PaintingStyle.stroke..strokeWidth = 1.8);

    // Четырехугольник вокруг
    final pA = Offset(w * 0.16, h * 0.84);
    final pB = Offset(w * 0.26, h * 0.18);
    final pC = Offset(w * 0.78, h * 0.18);
    final pD = Offset(w * 0.84, h * 0.84);

    final path = Path()
      ..moveTo(pA.dx, pA.dy)
      ..lineTo(pB.dx, pB.dy)
      ..lineTo(pC.dx, pC.dy)
      ..lineTo(pD.dx, pD.dy)
      ..close();

    canvas.drawPath(path, stroke);

    _drawLabel(canvas, 'a + c = b + d', Offset(center.dx - 36, center.dy - 8), color: accentColor);
    _drawLabel(canvas, 'a', Offset((pA.dx + pD.dx) / 2, pA.dy + 4));
    _drawLabel(canvas, 'b', Offset(pA.dx - 14, (pA.dy + pB.dy) / 2));
    _drawLabel(canvas, 'c', Offset((pB.dx + pC.dx) / 2, pB.dy - 18));
    _drawLabel(canvas, 'd', Offset(pD.dx + 6, (pC.dy + pD.dy) / 2));
  }

  void _drawRightAngle(Canvas canvas, Offset p, bool toRight, Paint paint, {bool flipY = false}) {
    const s = 10.0;
    final dx = toRight ? s : -s;
    final dy = flipY ? s : -s;

    final path = Path()
      ..moveTo(p.dx, p.dy + dy)
      ..lineTo(p.dx + dx, p.dy + dy)
      ..lineTo(p.dx + dx, p.dy);
    canvas.drawPath(path, paint);
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, {Color? color}) {
    final labelColor = color ?? textColor;
    final subSupRegex = RegExp(r'(_\{([^\}]+)\}|_([a-zA-Zа-яА-Я0-9]+)|\^\{([^\}]+)\}|\^([a-zA-Zа-яА-Я0-9]+))');

    InlineSpan span;
    if (subSupRegex.hasMatch(text)) {
      final children = <InlineSpan>[];
      int lastIndex = 0;
      for (final match in subSupRegex.allMatches(text)) {
        if (match.start > lastIndex) {
          children.add(TextSpan(
            text: text.substring(lastIndex, match.start),
            style: TextStyle(
              color: labelColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ));
        }

        final raw = match.group(2) ?? match.group(3) ?? match.group(4) ?? match.group(5) ?? '';
        children.add(TextSpan(
          text: raw,
          style: TextStyle(
            color: labelColor,
            fontSize: 8.5,
            fontWeight: FontWeight.w800,
          ),
        ));
        lastIndex = match.end;
      }
      if (lastIndex < text.length) {
        children.add(TextSpan(
          text: text.substring(lastIndex),
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ));
      }
      span = TextSpan(children: children);
    } else {
      span = TextSpan(
        text: text,
        style: TextStyle(
          color: labelColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _GeometryPainter oldDelegate) {
    return oldDelegate.figureType != figureType ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.isDark != isDark;
  }
}
