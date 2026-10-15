import 'package:flutter/material.dart';

/// Виджет для профессионального отображения математических формул
/// с настоящими вертикальными дробями и типографскими знаками корня (радикала) с надчеркиванием (vinculum).
class MathFormulaWidget extends StatelessWidget {
  final String formula;
  final TextStyle? baseStyle;
  final Color? accentColor;
  final double fontSize;

  const MathFormulaWidget({
    super.key,
    required this.formula,
    this.baseStyle,
    this.accentColor,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = baseStyle?.color ?? theme.colorScheme.onSurface;
    final primary = accentColor ?? theme.colorScheme.primary;

    final lines = formula.split('\n');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((line) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _buildFormulaLine(trimmed, color, primary),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFormulaLine(String line, Color textColor, Color primaryColor) {
    // Регулярное выражение для дробей:
    // Поддерживает:
    // 1) \frac{...}{...}
    // 2) (числитель) / (знаменатель)
    // 3) слово/число / слово/число
    final latexFracRegex = RegExp(r'\\frac\{([^\}]+)\}\{([^\}]+)\}');
    final slashFracRegex = RegExp(
      r'(\((?:[^()]|\([^()]*\))+\)|[a-zA-Zа-яА-Я0-9_ⁿ²³⁴\u2070-\u209F\u221A\·\*\+\-\±\s]+?)\s*/\s*(\((?:[^()]|\([^()]*\))+\)|[a-zA-Zа-яА-Я0-9_ⁿ²³⁴\u2070-\u209F\u221A\·\*\+\-\±]+)',
    );

    // Если есть \frac{...}{...}
    if (latexFracRegex.hasMatch(line)) {
      return _renderWithRegex(line, latexFracRegex, textColor, primaryColor, isLatex: true);
    }

    // Если есть слэш '/', проверяем, похож ли он на математическую дробь
    if (line.contains('/') && !line.startsWith('http')) {
      final matches = slashFracRegex.allMatches(line).toList();
      if (matches.isNotEmpty) {
        return _renderWithMatches(line, matches, textColor, primaryColor);
      }
    }

    // Обычная строка без дробей
    return _buildMathText(line, textColor, primaryColor, fontSize: fontSize);
  }

  Widget _renderWithMatches(
    String line,
    List<RegExpMatch> matches,
    Color textColor,
    Color primaryColor,
  ) {
    final widgets = <Widget>[];
    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        final prefix = line.substring(lastIndex, match.start);
        if (prefix.isNotEmpty) {
          widgets.add(_buildMathText(prefix, textColor, primaryColor, fontSize: fontSize));
        }
      }

      var numStr = match.group(1)!.trim();
      var denStr = match.group(2)!.trim();

      // Убираем внешние скобки если они обрамляют всё выражение
      numStr = _stripOuterParentheses(numStr);
      denStr = _stripOuterParentheses(denStr);

      widgets.add(_buildFraction(numStr, denStr, textColor, primaryColor));
      lastIndex = match.end;
    }

    if (lastIndex < line.length) {
      final suffix = line.substring(lastIndex);
      if (suffix.isNotEmpty) {
        widgets.add(_buildMathText(suffix, textColor, primaryColor, fontSize: fontSize));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  Widget _renderWithRegex(
    String line,
    RegExp regex,
    Color textColor,
    Color primaryColor, {
    required bool isLatex,
  }) {
    final matches = regex.allMatches(line).toList();
    final widgets = <Widget>[];
    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        final prefix = line.substring(lastIndex, match.start);
        if (prefix.isNotEmpty) {
          widgets.add(_buildMathText(prefix, textColor, primaryColor, fontSize: fontSize));
        }
      }

      final numStr = match.group(1)!.trim();
      final denStr = match.group(2)!.trim();

      widgets.add(_buildFraction(numStr, denStr, textColor, primaryColor));
      lastIndex = match.end;
    }

    if (lastIndex < line.length) {
      final suffix = line.substring(lastIndex);
      if (suffix.isNotEmpty) {
        widgets.add(_buildMathText(suffix, textColor, primaryColor, fontSize: fontSize));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  String _stripOuterParentheses(String s) {
    s = s.trim();
    if (s.startsWith('(') && s.endsWith(')')) {
      int depth = 0;
      bool balancedBeforeEnd = false;
      for (int i = 0; i < s.length - 1; i++) {
        if (s[i] == '(') depth++;
        if (s[i] == ')') depth--;
        if (depth == 0) {
          balancedBeforeEnd = true;
          break;
        }
      }
      if (!balancedBeforeEnd) {
        return s.substring(1, s.length - 1).trim();
      }
    }
    return s;
  }

  Widget _buildFraction(
    String numerator,
    String denominator,
    Color textColor,
    Color primaryColor,
  ) {
    final fracFontSize = (fontSize * 0.88).clamp(11.0, 20.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Числитель
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            child: _buildMathText(
              numerator,
              primaryColor,
              primaryColor,
              fontSize: fracFontSize,
            ),
          ),
          // Черта дроби
          Container(
            height: 1.8,
            constraints: const BoxConstraints(minWidth: 16),
            color: textColor.withValues(alpha: 0.85),
            margin: const EdgeInsets.symmetric(vertical: 2.5),
          ),
          // Знаменатель
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            child: _buildMathText(
              denominator,
              primaryColor,
              primaryColor,
              fontSize: fracFontSize,
            ),
          ),
        ],
      ),
    );
  }

  String _cleanLatex(String text) {
    return text
        .replaceAll(r'\cdot', '·')
        .replaceAll(r'\times', '×')
        .replaceAll(r'\pm', '±')
        .replaceAll(r'\mp', '∓')
        .replaceAll(r'\approx', '≈')
        .replaceAll(r'\neq', '≠')
        .replaceAll(r'\ne', '≠')
        .replaceAll(r'\le', '≤')
        .replaceAll(r'\ge', '≥')
        .replaceAll(r'\Delta', 'Δ')
        .replaceAll(r'\alpha', 'α')
        .replaceAll(r'\beta', 'β')
        .replaceAll(r'\gamma', 'γ')
        .replaceAll(r'\pi', 'π')
        .replaceAll(r'\rho', 'ρ')
        .replaceAll(r'\mu', 'μ')
        .replaceAll(r'\perp', '⊥')
        .replaceAll(r'\cap', '∩')
        .replaceAll(r'\cup', '∪')
        .replaceAll(r'\in', '∈')
        .replaceAll(r'\infty', '∞')
        .replaceAll(r'\degree', '°')
        .replaceAll('<=>', ' ⇔ ')
        .replaceAll('<==>', ' ⇔ ')
        .replaceAll('=>', ' ⇒ ')
        .replaceAll('==>', ' ⇒ ')
        .replaceAll('->', ' → ')
        .replaceAll('<-', ' ← ');
  }

  /// Поиск всех корней в выражении: \sqrt[n]{...}, \sqrt{...}, √( ... ), √a, √49
  List<_RootMatch> _findRoots(String text) {
    final results = <_RootMatch>[];
    int i = 0;
    final n = text.length;

    while (i < n) {
      if (text.startsWith(r'\sqrt', i)) {
        final start = i;
        int idx = i + 5;
        String? degree;

        // Опциональная степень корня, например \sqrt[3]{8}
        if (idx < n && text[idx] == '[') {
          final endDeg = text.indexOf(']', idx);
          if (endDeg != -1) {
            degree = text.substring(idx + 1, endDeg).trim();
            idx = endDeg + 1;
          }
        }

        // Подкоренное выражение в фигурных скобках \sqrt{...}
        if (idx < n && text[idx] == '{') {
          int depth = 1;
          final cStart = idx + 1;
          int j = cStart;
          while (j < n && depth > 0) {
            if (text[j] == '{') depth++;
            if (text[j] == '}') depth--;
            j++;
          }
          if (depth == 0) {
            final content = text.substring(cStart, j - 1);
            results.add(_RootMatch(start: start, end: j, degree: degree, content: content));
            i = j;
            continue;
          }
        }

        // \sqrt без фигурных скобок, например \sqrt 2 или \sqrt a
        final m = RegExp(r'^\\sqrt\s*([a-zA-Z0-9]+)').firstMatch(text.substring(i));
        if (m != null) {
          results.add(_RootMatch(start: i, end: i + m.group(0)!.length, degree: null, content: m.group(1)!));
          i += m.group(0)!.length;
          continue;
        }

        i += 5;
      } else if (text.startsWith('√', i)) {
        final start = i;
        final idx = i + 1;

        // Корень с круглыми скобками √(a) или √(x + 1)
        if (idx < n && text[idx] == '(') {
          int depth = 1;
          final cStart = idx + 1;
          int j = cStart;
          while (j < n && depth > 0) {
            if (text[j] == '(') depth++;
            if (text[j] == ')') depth--;
            j++;
          }
          if (depth == 0) {
            final content = text.substring(cStart, j - 1);
            results.add(_RootMatch(start: start, end: j, degree: null, content: content));
            i = j;
            continue;
          }
        }

        // Корень со слитным выражением/числом: √a, √2, √49, √121, √x, √D
        final m = RegExp(r'^√([a-zA-Z0-9_]+)').firstMatch(text.substring(i));
        if (m != null) {
          results.add(_RootMatch(start: i, end: i + m.group(0)!.length, degree: null, content: m.group(1)!));
          i += m.group(0)!.length;
          continue;
        }

        i += 1;
      } else {
        i++;
      }
    }

    return results;
  }

  Widget _buildMathText(
    String text,
    Color color,
    Color primaryColor, {
    required double fontSize,
  }) {
    final cleaned = _cleanLatex(text);
    final roots = _findRoots(cleaned);

    final baseStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      fontFamily: 'monospace',
      letterSpacing: 0.3,
      color: color,
      height: 1.2,
    );

    // Если корней нет, выполняем только разбор индексов
    if (roots.isEmpty) {
      final spans = _buildSubSupSpans(cleaned, color, fontSize, baseStyle);
      return Text.rich(TextSpan(children: spans));
    }

    // Если есть корни, чередуем текст и виджеты радикалов с vinculum
    final spans = <InlineSpan>[];
    int lastIndex = 0;

    for (final root in roots) {
      if (root.start > lastIndex) {
        final prefix = cleaned.substring(lastIndex, root.start);
        if (prefix.isNotEmpty) {
          spans.addAll(_buildSubSupSpans(prefix, color, fontSize, baseStyle));
        }
      }

      // Содержимое подкоренного выражения
      final trimmedContent = root.content.trim();
      Widget innerChild;

      if (trimmedContent.contains(r'\frac')) {
        innerChild = _buildFormulaLine(trimmedContent, color, primaryColor);
      } else {
        innerChild = _buildMathText(trimmedContent, color, primaryColor, fontSize: fontSize * 0.95);
      }

      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: RadicalWidget(
          color: color,
          fontSize: fontSize,
          degree: root.degree,
          child: innerChild,
        ),
      ));

      lastIndex = root.end;
    }

    if (lastIndex < cleaned.length) {
      final suffix = cleaned.substring(lastIndex);
      if (suffix.isNotEmpty) {
        spans.addAll(_buildSubSupSpans(suffix, color, fontSize, baseStyle));
      }
    }

    return Text.rich(TextSpan(children: spans));
  }

  List<InlineSpan> _buildSubSupSpans(
    String text,
    Color color,
    double fontSize,
    TextStyle baseStyle,
  ) {
    final subSupRegex = RegExp(
      r'(_\{([^\}]+)\}|_([a-zA-Zа-яА-Я0-9]+)|\^\{([^\}]+)\}|\^([a-zA-Zа-яА-Я0-9]+))',
    );

    if (!subSupRegex.hasMatch(text)) {
      return [TextSpan(text: text, style: baseStyle)];
    }

    final spans = <InlineSpan>[];
    int lastIndex = 0;

    for (final match in subSupRegex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }

      final isSubscript = match.group(0)!.startsWith('_');
      final rawIndex = match.group(2) ?? match.group(3) ?? match.group(4) ?? match.group(5) ?? '';
      final cleanIdx = rawIndex
          .replaceAll(r'\text{', '')
          .replaceAll('}', '')
          .replaceAll(r'\Delta', 'Δ')
          .trim();

      final indexFontSize = (fontSize * 0.60).clamp(9.0, 14.0);

      if (isSubscript) {
        // Подстрочный индекс (опущен вниз)
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Transform.translate(
            offset: Offset(0, fontSize * 0.28),
            child: Text(
              cleanIdx,
              style: TextStyle(
                fontSize: indexFontSize,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ));
      } else {
        // Надстрочный индекс (поднят вверх)
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Transform.translate(
            offset: Offset(0, -fontSize * 0.32),
            child: Text(
              cleanIdx,
              style: TextStyle(
                fontSize: indexFontSize,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ));
      }

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: baseStyle,
      ));
    }

    return spans;
  }
}

class _RootMatch {
  final int start;
  final int end;
  final String? degree;
  final String content;

  _RootMatch({
    required this.start,
    required this.end,
    this.degree,
    required this.content,
  });
}

/// Настоящий математический корень с левой галочкой, надчеркиванием (vinculum) и концевым штрихом.
class RadicalWidget extends StatelessWidget {
  final Widget child;
  final Color color;
  final double fontSize;
  final String? degree;

  const RadicalWidget({
    super.key,
    required this.child,
    required this.color,
    required this.fontSize,
    this.degree,
  });

  @override
  Widget build(BuildContext context) {
    // Ширина левой галочки знака радикала
    final tickWidth = (fontSize * 0.65).clamp(9.5, 15.0);
    final strokeWidth = (fontSize * 0.088).clamp(1.5, 2.2);

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.5),
      child: CustomPaint(
        painter: _RadicalPainter(
          color: color,
          strokeWidth: strokeWidth,
          tickWidth: tickWidth,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: tickWidth + 2.5,
            top: 4.0, // Зазор под горизонтальной чертой корня
            right: 4.0, // Зазор до концевого штриха
            bottom: 1.5,
          ),
          child: child,
        ),
      ),
    );

    if (degree != null && degree!.isNotEmpty) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          content,
          Positioned(
            left: 0,
            top: -fontSize * 0.20,
            child: Text(
              degree!,
              style: TextStyle(
                fontSize: fontSize * 0.52,
                fontWeight: FontWeight.w900,
                color: color,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      );
    }

    return content;
  }
}

class _RadicalPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double tickWidth;

  _RadicalPainter({
    required this.color,
    required this.strokeWidth,
    required this.tickWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final h = size.height;
    final w = size.width;

    final path = Path();
    // 1. Левый хвостик знака радикала
    path.moveTo(1.0, h * 0.52);
    // 2. Внутренний изгиб галочки
    path.lineTo(tickWidth * 0.32, h * 0.64);
    // 3. Нижний острый угол галочки корня
    path.lineTo(tickWidth * 0.68, h - 0.5);
    // 4. Взлет к верхнему левому углу горизонтальной черты
    path.lineTo(tickWidth, 2.0);
    // 5. Горизонтальная черта над всем выражением (vinculum)
    path.lineTo(w - 1.0, 2.0);
    // 6. Аккуратный типографский вертикальный штрих вниз
    path.lineTo(w - 1.0, 4.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RadicalPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.tickWidth != tickWidth;
  }
}
