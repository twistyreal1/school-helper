import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Виджет для профессионального отображения математических формул
/// с настоящими вертикальными дробями и типографскими знаками корня (радикала) с надчеркиванием (vinculum).
class MathFormulaWidget extends StatelessWidget {
  final String formula;
  final TextStyle? baseStyle;
  final Color? accentColor;
  final double fontSize;
  final bool isChemistry;
  final bool isInformatics;
  final bool allowSlashFractions;

  const MathFormulaWidget({
    super.key,
    required this.formula,
    this.baseStyle,
    this.accentColor,
    this.fontSize = 16,
    this.isChemistry = false,
    this.isInformatics = false,
    this.allowSlashFractions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = baseStyle?.color ?? theme.colorScheme.onSurface;
    final primary = accentColor ?? theme.colorScheme.primary;

    var normalizedFormula = formula
        .replaceAll(_beginEnvRegex, '')
        .replaceAll(_endEnvRegex, '')
        .replaceAll(_leadingAmpRegex, r'$1')
        .replaceAll(_midAmpRegex, '')
        .replaceAll(_trailingBackslashesRegex, '')
        .replaceAll(_newlineBackslashesRegex, '\n');
    final lines = normalizedFormula.split('\n');

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

  static final _trailingBackslashesRegex = RegExp(r'\\\\(?=\s*$)');
  static final _newlineBackslashesRegex = RegExp(r'\\\\\s*');
  static final _beginEnvRegex = RegExp(r'\\begin\{(?:aligned|cases|array|matrix)\}');
  static final _endEnvRegex = RegExp(r'\\end\{(?:aligned|cases|array|matrix)\}');
  static final _leadingAmpRegex = RegExp(r'(^|\n)\s*&');
  static final _midAmpRegex = RegExp(r'(?<=\s)&');
  static final _sqrtNoBraceRegex = RegExp(r'\\sqrt\s*([a-zA-Z0-9]+)');
  static final _sqrtSimpleRegex = RegExp(r'√([a-zA-Z0-9_]+)');
  static final _textCommandsRegex = RegExp(r'\\(?:text|textbf|mathbf|mathbb|mathcal)\{([^}]*)\}');
  static final _overlineRegex = RegExp(r'\\(?:overline|bar|widehat)\{([^}]*)\}');
  static final _tildeRegex = RegExp(r'\\tilde\{([^}]*)\}');
  static final _ddotRegex = RegExp(r'\\ddot\{([^}]*)\}');
  static final _acuteRegex = RegExp(r"\\'\{([^}]*)\}");
  static final _underbraceRegex = RegExp(r'\\underbrace\{([^}]*)\}_\{([^}]*)\}');
  static final _operatornameRegex = RegExp(r'\\operatorname\{([^}]*)\}');
  static final _vecRegex = RegExp(r'\\vec\{([^}]+)\}');
  static final _xrightarrowRegex = RegExp(r'\\xrightarrow(?:\[([^\]]*)\])?\{([^}]*)\}');

  static bool _hasAdvancedLatex(String line) {
    return line.contains(r'\parallel') ||
        line.contains(r'\iff') ||
        line.contains(r'\upuparrows') ||
        line.contains(r'\updownarrows') ||
        line.contains(r'\Leftarrow') ||
        line.contains(r'\Leftrightarrow');
  }

  String _preprocessTex(String line) {
    var s = line;
    s = s.replaceAll(r'\updownarrows', r'\uparrow\downarrow');
    s = s.replaceAll(r'\&', r'\text{\&}');
    s = s.replaceAll(r'\degree', r'^\circ');
    s = s.replaceAll(r'\rightarrow', r'\to');
    s = s.replaceAll(r'\longrightarrow', r'\to');
    return s;
  }

  Widget _buildTexLine(String line, Color textColor, Color primaryColor) {
    final preprocessed = _preprocessTex(line);
    return Math.tex(
      preprocessed,
      textStyle: TextStyle(
        fontSize: fontSize,
        color: textColor,
        fontWeight: FontWeight.w600,
        fontFamily: 'monospace',
      ),
      mathStyle: MathStyle.display,
      onErrorFallback: (err) {
        return _buildMathText(line, textColor, primaryColor, fontSize: fontSize);
      },
    );
  }

  Widget _buildFormulaLine(
    String line,
    Color textColor,
    Color primaryColor, {
    double? customFontSize,
  }) {
    final effectiveFontSize = customFontSize ?? fontSize;

    // 0. Если в строке присутствуют продвинутые математические/геометрические LaTeX конструкции
    // (векторы, стрелки эквивалентности, параллельность, текстовые блоки и т.д.),
    // отображаем через полноценный типографский движок flutter_math_fork.
    if (_hasAdvancedLatex(line)) {
      return _buildTexLine(line, textColor, primaryColor);
    }

    // 1. Поиск LaTeX дробей вида \frac{...}{...} с поддержкой вложенных фигурных скобок (например, \sqrt{D})
    final latexFractions = FractionParser.findLatexFractions(line);

    // 1a. Если на верхнем уровне есть корень (\sqrt{...} или √(...)), внутри которого находится \frac,
    // сначала разбираем этот корень, чтобы содержимое дроби рендерилось внутри RadicalWidget.
    final roots = _findRoots(line);
    if (roots.isNotEmpty) {
      _RootMatch? rootWithFrac;
      for (final r in roots) {
        if (r.content.contains(r'\frac') &&
            (latexFractions.isEmpty || r.start < latexFractions.first.start)) {
          rootWithFrac = r;
          break;
        }
      }
      if (rootWithFrac != null) {
        final widgets = <Widget>[];
        if (rootWithFrac.start > 0) {
          final prefix = line.substring(0, rootWithFrac.start);
          if (prefix.isNotEmpty) {
            widgets.add(_buildFormulaLine(prefix, textColor, primaryColor, customFontSize: effectiveFontSize));
          }
        }
        widgets.add(RadicalWidget(
          color: textColor,
          fontSize: effectiveFontSize,
          degree: rootWithFrac.degree,
          child: _buildFormulaLine(
            rootWithFrac.content.trim(),
            textColor,
            primaryColor,
            customFontSize: effectiveFontSize * 0.95,
          ),
        ));
        if (rootWithFrac.end < line.length) {
          final suffix = line.substring(rootWithFrac.end);
          if (suffix.isNotEmpty) {
            widgets.add(_buildFormulaLine(suffix, textColor, primaryColor, customFontSize: effectiveFontSize));
          }
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets,
        );
      }
    }

    if (latexFractions.isNotEmpty) {
      final widgets = <Widget>[];
      int lastIndex = 0;

      for (final match in latexFractions) {
        if (match.start > lastIndex) {
          final prefix = line.substring(lastIndex, match.start);
          if (prefix.isNotEmpty) {
            widgets.add(_buildFormulaLine(prefix, textColor, primaryColor, customFontSize: effectiveFontSize));
          }
        }

        widgets.add(_buildFormulaFraction(
          match.numerator,
          match.denominator,
          textColor,
          primaryColor,
          customFontSize: effectiveFontSize,
        ));
        lastIndex = match.end;
      }

      if (lastIndex < line.length) {
        final suffix = line.substring(lastIndex);
        if (suffix.isNotEmpty) {
          widgets.add(_buildFormulaLine(suffix, textColor, primaryColor, customFontSize: effectiveFontSize));
        }
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets,
      );
    }

    // 2. Поиск слэш-дробей после нормализации Δc / Δt, с отсеиванием не-дробей
    final normalized = formatFormulaOperators(
      formatChemistryAndSubscripts(
        line,
        isInformatics: isInformatics,
        isChemistry: isChemistry,
      ),
    );
    if (allowSlashFractions && normalized.contains('/') && !normalized.startsWith('http')) {
      final matches = FractionParser.findSlashFractions(normalized, allowSlashFractions: true);
      if (matches.isNotEmpty) {
        return _renderWithMatches(normalized, matches, textColor, primaryColor);
      }
    }

    // 3. Обычная строка без дробей
    return _buildMathText(line, textColor, primaryColor, fontSize: effectiveFontSize);
  }

  Widget _renderWithMatches(
    String line,
    List<SlashFractionMatch> matches,
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

      widgets.add(_buildFormulaFraction(match.numerator, match.denominator, textColor, primaryColor));
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

  Widget _buildFormulaFraction(
    String numerator,
    String denominator,
    Color textColor,
    Color primaryColor, {
    double? customFontSize,
  }) {
    final curFontSize = customFontSize ?? fontSize;
    final fracFontSize = (curFontSize * 0.90).clamp(11.0, 20.0);
    return MathFractionWidget(
      numerator: numerator,
      denominator: denominator,
      baseStyle: TextStyle(
        fontSize: curFontSize,
        color: textColor,
        fontWeight: FontWeight.w700,
        fontFamily: 'monospace',
      ),
      primaryColor: primaryColor,
      fontSize: fracFontSize,
      isChemistry: isChemistry,
      isInformatics: isInformatics,
      childBuilder: (expr, color) => _buildFormulaLine(
        expr,
        color,
        color,
        customFontSize: fracFontSize,
      ),
    );
  }

  String _cleanLatex(String text) {
    var s = formatChemistryAndSubscripts(
      text,
      isInformatics: isInformatics,
      isChemistry: isChemistry,
    );
    s = s.replaceAll(_beginEnvRegex, '');
    s = s.replaceAll(_endEnvRegex, '');
    s = s.replaceAll(_leadingAmpRegex, r'$1');
    s = s.replaceAll(_midAmpRegex, '');
    s = formatFormulaOperators(s);
    s = s.replaceAllMapped(_underbraceRegex, (m) => '${m.group(1)} (${m.group(2)})');
    s = s.replaceAllMapped(_textCommandsRegex, (m) => m.group(1) ?? '');
    s = s.replaceAllMapped(_overlineRegex, (m) => m.group(1) ?? '');
    s = s.replaceAllMapped(_tildeRegex, (m) => '${m.group(1)}\u0303');
    s = s.replaceAllMapped(_ddotRegex, (m) => '${m.group(1)}\u0308');
    s = s.replaceAllMapped(_acuteRegex, (m) => '${m.group(1)}\u0301');
    s = s.replaceAllMapped(_operatornameRegex, (m) => m.group(1) ?? '');
    s = s.replaceAllMapped(_vecRegex, (m) => '${m.group(1)}\u20D7');
    s = s.replaceAllMapped(_xrightarrowRegex, (m) {
      final cond = '${m.group(1) ?? ''}${m.group(2) ?? ''}'.trim();
      return cond.isNotEmpty ? ' —($cond)→ ' : ' → ';
    });
    s = s.replaceAll(r'\\', ' ');

    return s
        // Тригонометрические и математические функции (с поддержкой любого экранирования)
        .replaceAll(RegExp(r'\\+sin(?![a-zA-Z])'), 'sin')
        .replaceAll(RegExp(r'\\+cos(?![a-zA-Z])'), 'cos')
        .replaceAll(RegExp(r'\\+tan(?![a-zA-Z])'), 'tg')
        .replaceAll(RegExp(r'\\+cot(?![a-zA-Z])'), 'ctg')
        .replaceAll(RegExp(r'\\+tg(?![a-zA-Z])'), 'tg')
        .replaceAll(RegExp(r'\\+ctg(?![a-zA-Z])'), 'ctg')
        .replaceAll(RegExp(r'\\+arcsin(?![a-zA-Z])'), 'arcsin')
        .replaceAll(RegExp(r'\\+arccos(?![a-zA-Z])'), 'arccos')
        .replaceAll(RegExp(r'\\+arctan(?![a-zA-Z])'), 'arctg')
        .replaceAll(RegExp(r'\\+arctg(?![a-zA-Z])'), 'arctg')
        .replaceAll(RegExp(r'\\+ln(?![a-zA-Z])'), 'ln')
        .replaceAll(RegExp(r'\\+lg(?![a-zA-Z])'), 'lg')
        .replaceAll(RegExp(r'\\+log(?![a-zA-Z])'), 'log')
        .replaceAll(RegExp(r'\\+lim(?![a-zA-Z])'), 'lim')
        .replaceAll(RegExp(r'\\+max(?![a-zA-Z])'), 'max')
        .replaceAll(RegExp(r'\\+min(?![a-zA-Z])'), 'min')
        // Стрелки и отношения
        .replaceAll(RegExp(r'\\+rightarrow(?![a-zA-Z])'), ' → ')
        .replaceAll(RegExp(r'\\+longrightarrow(?![a-zA-Z])'), ' → ')
        .replaceAll(RegExp(r'\\+to(?![a-zA-Z])'), ' → ')
        .replaceAll(RegExp(r'\\+leftarrow(?![a-zA-Z])'), ' ← ')
        .replaceAll(RegExp(r'\\+longleftarrow(?![a-zA-Z])'), ' ← ')
        .replaceAll(RegExp(r'\\+uparrow(?![a-zA-Z])'), ' ↑ ')
        .replaceAll(RegExp(r'\\+downarrow(?![a-zA-Z])'), ' ↓ ')
        .replaceAll(RegExp(r'\\+leftrightarrow(?![a-zA-Z])'), ' ↔ ')
        .replaceAll(RegExp(r'\\+rightleftharpoons(?![a-zA-Z])'), ' ⇄ ')
        .replaceAll(RegExp(r'\\+iff(?![a-zA-Z])'), ' ⇔ ')
        .replaceAll(RegExp(r'\\+upuparrows(?![a-zA-Z])'), ' ↑↑ ')
        .replaceAll(RegExp(r'\\+updownarrows(?![a-zA-Z])'), ' ↑↓ ')
        .replaceAll(RegExp(r'\\+parallel(?![a-zA-Z])'), ' ∥ ')
        .replaceAll(RegExp(r'\\+Rightarrow(?![a-zA-Z])'), ' ⇒ ')
        .replaceAll(RegExp(r'\\+Leftarrow(?![a-zA-Z])'), ' ⇐ ')
        .replaceAll(RegExp(r'\\+Leftrightarrow(?![a-zA-Z])'), ' ⇔ ')
        .replaceAll(RegExp(r'\\+Longleftrightarrow(?![a-zA-Z])'), ' ⇔ ')
        .replaceAll(RegExp(r'\\+implies(?![a-zA-Z])'), ' ⇒ ')
        // Геометрия и символы
        .replaceAll(RegExp(r'\\+angle(?![a-zA-Z])'), '∠')
        .replaceAll(RegExp(r'\\+triangle(?![a-zA-Z])'), '△')
        .replaceAll(RegExp(r'\\+smile(?![a-zA-Z])'), '⌒')
        .replaceAll(RegExp(r'\\+setminus(?![a-zA-Z])'), ' ∖ ')
        .replaceAll(RegExp(r'\\+mapsto(?![a-zA-Z])'), ' ↦ ')
        .replaceAll(RegExp(r'\\+ll(?![a-zA-Z])'), ' ≪ ')
        .replaceAll(RegExp(r'\\+qquad(?![a-zA-Z])'), '      ')
        .replaceAll(RegExp(r'\\+quad(?![a-zA-Z])'), '   ')
        .replaceAll(r'\;', ' ')
        .replaceAll(r'\,', ' ')
        .replaceAll(r'\&', '&')
        .replaceAll(r'\%', '%')
        .replaceAll(r'\_', '_')
        .replaceAll(r'\big', '')
        .replaceAll('{}', '')
        .replaceAll(RegExp(r'\\+subset(?![a-zA-Z])'), '⊂')
        .replaceAll(RegExp(r'\\+subseteq(?![a-zA-Z])'), '⊆')
        .replaceAll(RegExp(r'\\+notin(?![a-zA-Z])'), '∉')
        .replaceAll(RegExp(r'\\+varnothing(?![a-zA-Z])'), '∅')
        .replaceAll(RegExp(r'\\+emptyset(?![a-zA-Z])'), '∅')
        .replaceAll(RegExp(r'\\+cdot(?![a-zA-Z])'), '·')
        .replaceAll(RegExp(r'\\+times(?![a-zA-Z])'), '×')
        .replaceAll(RegExp(r'\\+pm(?![a-zA-Z])'), '±')
        .replaceAll(RegExp(r'\\+mp(?![a-zA-Z])'), '∓')
        .replaceAll(RegExp(r'\\+approx(?![a-zA-Z])'), '≈')
        .replaceAll(RegExp(r'\\+neq(?![a-zA-Z])'), '≠')
        .replaceAll(RegExp(r'\\+ne(?![a-zA-Z])'), '≠')
        .replaceAll(RegExp(r'\\+le(?![a-zA-Z])'), '≤')
        .replaceAll(RegExp(r'\\+ge(?![a-zA-Z])'), '≥')
        .replaceAll(RegExp(r'\\+Delta(?![a-zA-Z])'), 'Δ')
        .replaceAll(RegExp(r'\\+delta(?![a-zA-Z])'), 'δ')
        .replaceAll(RegExp(r'\\+alpha(?![a-zA-Z])'), 'α')
        .replaceAll(RegExp(r'\\+beta(?![a-zA-Z])'), 'β')
        .replaceAll(RegExp(r'\\+gamma(?![a-zA-Z])'), 'γ')
        .replaceAll(RegExp(r'\\+Gamma(?![a-zA-Z])'), 'Γ')
        .replaceAll(RegExp(r'\\+pi(?![a-zA-Z])'), 'π')
        .replaceAll(RegExp(r'\\+rho(?![a-zA-Z])'), 'ρ')
        .replaceAll(RegExp(r'\\+mu(?![a-zA-Z])'), 'μ')
        .replaceAll(RegExp(r'\\+nu(?![a-zA-Z])'), 'ν')
        .replaceAll(RegExp(r'\\+omega(?![a-zA-Z])'), 'ω')
        .replaceAll(RegExp(r'\\+Omega(?![a-zA-Z])'), 'Ω')
        .replaceAll(RegExp(r'\\+lambda(?![a-zA-Z])'), 'λ')
        .replaceAll(RegExp(r'\\+sigma(?![a-zA-Z])'), 'σ')
        .replaceAll(RegExp(r'\\+phi(?![a-zA-Z])'), 'φ')
        .replaceAll(RegExp(r'\\+varphi(?![a-zA-Z])'), 'φ')
        .replaceAll(RegExp(r'\\+eta(?![a-zA-Z])'), 'η')
        .replaceAll(RegExp(r'\\+varepsilon(?![a-zA-Z])'), 'ε')
        .replaceAll(RegExp(r'\\+epsilon(?![a-zA-Z])'), 'ε')
        .replaceAll(RegExp(r'\\+tau(?![a-zA-Z])'), 'τ')
        .replaceAll(RegExp(r'\\+perp(?![a-zA-Z])'), '⊥')
        .replaceAll(RegExp(r'\\+cap(?![a-zA-Z])'), '∩')
        .replaceAll(RegExp(r'\\+cup(?![a-zA-Z])'), '∪')
        // ВАЖНО: \infty строго ДО \in!
        .replaceAll(RegExp(r'\\+infty(?![a-zA-Z])'), '∞')
        .replaceAll(RegExp(r'\\+in(?![a-zA-Z])'), '∈')
        .replaceAll(r'\degree', '°')
        .replaceAll(r'\deg', '°')
        .replaceAll(r'\circ', '°')
        .replaceAll(r'\dots', '...')
        .replaceAll(r'\ldots', '...')
        .replaceAll(r'\cdots', '···')
        .replaceAll(r'\mid', '|')
        .replaceAll(r'\sim', '~')
        .replaceAll(r'\sum', '∑')
        .replaceAll(r'\forall', '∀')
        .replaceAll(r'\exists', '∃')
        .replaceAll(r'\neg', '¬')
        .replaceAll(r'\equiv', '≡')
        .replaceAll(r'\left', '')
        .replaceAll(r'\right', '')
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
        final m = _sqrtNoBraceRegex.matchAsPrefix(text, i);
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
        final m = _sqrtSimpleRegex.matchAsPrefix(text, i);
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
    return buildMathSubSupSpans(
      text,
      baseStyle: baseStyle,
      indexColor: color,
      isInformatics: isInformatics,
    );
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

/// Результат сопоставления LaTeX дроби \frac{num}{den}
class LatexFractionMatch {
  final int start;
  final int end;
  final String numerator;
  final String denominator;

  const LatexFractionMatch({
    required this.start,
    required this.end,
    required this.numerator,
    required this.denominator,
  });
}

/// Результат сопоставления компактной слэш-дроби num / den
class SlashFractionMatch {
  final int start;
  final int end;
  final String numerator;
  final String denominator;

  const SlashFractionMatch({
    required this.start,
    required this.end,
    required this.numerator,
    required this.denominator,
  });
}

/// Виджет вертикальной дроби (числитель над чертой, знаменатель под чертой)
class MathFractionWidget extends StatelessWidget {
  final String numerator;
  final String denominator;
  final TextStyle baseStyle;
  final Color primaryColor;
  final double? fontSize;
  final bool isChemistry;
  final bool isInformatics;
  final Widget Function(String expr, Color color)? childBuilder;

  const MathFractionWidget({
    super.key,
    required this.numerator,
    required this.denominator,
    required this.baseStyle,
    required this.primaryColor,
    this.fontSize,
    this.isChemistry = false,
    this.isInformatics = false,
    this.childBuilder,
  });

  Widget _buildPart(String rawExpr, double fracFontSize) {
    if (childBuilder != null) {
      return childBuilder!(rawExpr, primaryColor);
    }

    final trimmed = rawExpr.trim();
    if (trimmed.contains(r'\frac')) {
      final subFractions = FractionParser.findLatexFractions(trimmed);
      if (subFractions.isNotEmpty) {
        final widgets = <Widget>[];
        int lastIndex = 0;
        for (final m in subFractions) {
          if (m.start > lastIndex) {
            final prefix = trimmed.substring(lastIndex, m.start);
            if (prefix.isNotEmpty) {
              widgets.add(_buildPart(prefix, fracFontSize));
            }
          }
          widgets.add(MathFractionWidget(
            numerator: m.numerator,
            denominator: m.denominator,
            baseStyle: baseStyle,
            primaryColor: primaryColor,
            fontSize: (fracFontSize * 0.88).clamp(10.0, 16.0),
            isChemistry: isChemistry,
            isInformatics: isInformatics,
          ));
          lastIndex = m.end;
        }
        if (lastIndex < trimmed.length) {
          final suffix = trimmed.substring(lastIndex);
          if (suffix.isNotEmpty) {
            widgets.add(_buildPart(suffix, fracFontSize));
          }
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets,
        );
      }
    }

    final formatted = formatChemistryAndSubscripts(
      prettifyMathSymbols(rawExpr),
      isInformatics: isInformatics,
      isChemistry: isChemistry,
    );
    final partStyle = baseStyle.copyWith(
      fontSize: fracFontSize,
      fontWeight: FontWeight.w700,
      color: primaryColor,
      fontFamily: 'monospace',
    );
    final spans = buildMathSubSupSpans(
      formatted,
      baseStyle: partStyle,
      indexColor: primaryColor,
      isInformatics: isInformatics,
    );
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(style: partStyle, children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = fontSize ?? baseStyle.fontSize ?? 14.0;
    final fracFontSize = (effectiveFontSize * 0.90).clamp(11.0, 18.0);
    final textColor = baseStyle.color ?? primaryColor;
    final hasNested = numerator.contains(r'\frac') ||
        denominator.contains(r'\frac') ||
        numerator.contains('/') ||
        denominator.contains('/');

    return IntrinsicWidth(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Числитель
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              child: _buildPart(numerator, fracFontSize),
            ),
            // Черта дроби — компактная черта строго по ширине числителя/знаменателя
            Container(
              height: hasNested ? 2.2 : 1.8,
              width: double.infinity,
              constraints: BoxConstraints(minWidth: hasNested ? 26 : 16),
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: hasNested ? 0.95 : 0.85),
                borderRadius: BorderRadius.circular(1),
              ),
              margin: const EdgeInsets.symmetric(vertical: 2.0),
            ),
            // Знаменатель
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              child: _buildPart(denominator, fracFontSize),
            ),
          ],
        ),
      ),
    );
  }
}

/// Универсальный парсер и визуализатор дробей для любого текста (формулы, правила, лайфхаки, примеры)
class FractionParser {
  static const _supSubChars = r'\u00B9\u00B2\u00B3\u2070-\u209F';
  static final _operandPattern =
      r'(?:[+\-±]?(?:[a-zA-Zа-яА-ЯёЁ0-9√_]+)?(?:\((?:[^()/]|\([^()]*\))+\))+[' +
      _supSubChars +
      r']*' +
      r'|[+\-±]?\d+(?: \d{3})*(?:[.,]\d+)?' +
      r'|[+\-±]?[a-zA-Zα-ωΑ-ΩΔρμνλπωφψθ√][a-zA-Z0-9α-ωΑ-ΩΔρμνλπωφψθ_а-яА-ЯёЁ' +
      _supSubChars +
      r']*(?:_(?:\([^()]+\)|[a-zA-Zа-яА-ЯёЁ0-9]+)|\([^()/\s]+\))?)';

  static final slashFracRegex = RegExp(
    '($_operandPattern)\\s*/\\s*($_operandPattern)',
  );

  static final _pureAsciiLetters = RegExp(r'^[A-Za-z]{2,}$');
  static final _pureAsciiWord = RegExp(r'^[A-Za-z]+$');
  static final _vNotationRegex = RegExp(r'^V[123]$');
  static final _leadingDashWord = RegExp(r'^-[A-Za-z]{2,}$');

  /// Возвращает отфильтрованный список валидных математических/научных слэш-дробей
  static List<SlashFractionMatch> findSlashFractions(
    String text, {
    bool allowSlashFractions = true,
  }) {
    if (!allowSlashFractions || !text.contains('/') || text.startsWith('http')) {
      return const [];
    }

    final result = <SlashFractionMatch>[];
    for (final m in slashFracRegex.allMatches(text)) {
      final rawNum = m.group(1)!.trim();
      final rawDen = m.group(2)!.trim();
      final full = text.substring(m.start, m.end);

      final prevChar = m.start > 0 ? text[m.start - 1] : '';
      final nextChar = m.end < text.length ? text[m.end] : '';

      // Исключаем URL, пути, цепные слэши (a/b/c, am/is/are) и диапазоны (16–60/65+)
      if (prevChar == '/' || nextChar == '/' || nextChar == ':') continue;
      if (prevChar == '–' || prevChar == '—' || nextChar == '+') continue;
      if (full == '103/112') continue;

      // Исключаем слэш-дроби внутри степеней вида gamma^((T2 - T1) / 10) и 2^(-t / T1/2)
      if (m.start >= 2 && text.substring(m.start - 2, m.start) == '^(') continue;
      if (prevChar == '^') continue;
      if (_isInsideCaretExponent(text, m.start)) continue;

      // Исключаем грамматические конструкции (-s/es, -ed/-ing, V2 / V, V3/ed, V / V-s/es)
      if (_leadingDashWord.hasMatch(rawNum) || _leadingDashWord.hasMatch(rawDen)) continue;
      if (nextChar == '-' && _pureAsciiWord.hasMatch(rawDen)) continue;
      if (_vNotationRegex.hasMatch(rawNum) && (rawDen == 'V' || rawDen == 'ed')) continue;

      // Исключаем пары обычных слов через слэш (Regular/habitual, do/does, BIOS/UEFI, Pt/Pd, True/False),
      // сохраняя физико-химические формулы вроде V / Vm
      final cleanNumCheck = stripOuterParentheses(rawNum);
      final cleanDenCheck = stripOuterParentheses(rawDen);
      if (_pureAsciiLetters.hasMatch(cleanNumCheck) &&
          _pureAsciiLetters.hasMatch(cleanDenCheck)) {
        continue;
      }

      result.add(SlashFractionMatch(
        start: m.start,
        end: m.end,
        numerator: stripOuterParentheses(rawNum),
        denominator: stripOuterParentheses(rawDen),
      ));
    }
    return result;
  }

  static bool _isInsideCaretExponent(String text, int pos) {
    int depth = 0;
    for (int i = pos - 1; i >= 0; i--) {
      final ch = text[i];
      if (ch == ')') {
        depth++;
      } else if (ch == '(') {
        if (depth == 0) {
          return i > 0 && text[i - 1] == '^';
        }
        depth--;
      }
    }
    return false;
  }

  /// Находит все LaTeX дроби \frac{...}{...} с поддержкой вложенных фигурных скобок
  static List<LatexFractionMatch> findLatexFractions(String text) {
    final matches = <LatexFractionMatch>[];
    int i = 0;
    final n = text.length;

    while (i < n) {
      final idx = text.indexOf(r'\frac', i);
      if (idx == -1) break;

      int cur = idx + 5;
      while (cur < n && (text[cur] == ' ' || text[cur] == '\t')) {
        cur++;
      }

      if (cur < n && text[cur] == '{') {
        int depth = 1;
        final numStart = cur + 1;
        int j = numStart;
        while (j < n && depth > 0) {
          if (text[j] == '{') depth++;
          if (text[j] == '}') depth--;
          j++;
        }

        if (depth == 0) {
          final numStr = text.substring(numStart, j - 1);
          cur = j;
          while (cur < n && (text[cur] == ' ' || text[cur] == '\t')) {
            cur++;
          }

          if (cur < n && text[cur] == '{') {
            depth = 1;
            final denStart = cur + 1;
            j = denStart;
            while (j < n && depth > 0) {
              if (text[j] == '{') depth++;
              if (text[j] == '}') depth--;
              j++;
            }

            if (depth == 0) {
              final denStr = text.substring(denStart, j - 1);
              matches.add(LatexFractionMatch(
                start: idx,
                end: j,
                numerator: numStr.trim(),
                denominator: denStr.trim(),
              ));
              i = j;
              continue;
            }
          }
        }
      }

      i = idx + 5;
    }

    return matches;
  }

  /// Проверяет, есть ли в строке любые дроби (\frac или математический /)
  static bool hasAnyFraction(String text, {bool allowSlashFractions = true}) {
    if (text.contains(r'\frac')) return true;
    return findSlashFractions(text, allowSlashFractions: allowSlashFractions).isNotEmpty;
  }

  /// Снимает обрамляющие круглые скобки
  static String stripOuterParentheses(String s) {
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
}

final _deltaRegex = RegExp(r'(?<!\\)\bDelta\s+([a-zA-Z])');
final _plusMinusRegex = RegExp(r'(^|[\s=(])\+\-\s*');
final _topXrightarrowRegex = RegExp(r'\\xrightarrow(?:\[([^\]]*)\])?\{([^}]*)\}');
final _sqrtInlineRegex = RegExp(r'\\sqrt\{([^{}]*)\}');

/// Нормализует операторные обозначения вида `Delta c` -> `Δc` и `+-` -> `±`
String formatFormulaOperators(String text) {
  return text
      .replaceAllMapped(_deltaRegex, (m) => 'Δ${m.group(1)}')
      .replaceAllMapped(_plusMinusRegex, (m) => '${m.group(1)}± ');
}

/// Преобразует математические спецсимволы в типографский вид
String prettifyMathSymbols(String text, {bool stripBraces = true}) {
  var s = formatFormulaOperators(text);
  s = s.replaceAllMapped(
    _topXrightarrowRegex,
    (m) {
      final cond = '${m.group(1) ?? ''}${m.group(2) ?? ''}'.trim();
      return cond.isNotEmpty ? ' —($cond)→ ' : ' → ';
    },
  );
  s = s.replaceAllMapped(_sqrtInlineRegex, (m) => '√(${m.group(1)})');
  s = s
      .replaceAll(r'\sin', 'sin')
      .replaceAll(r'\cos', 'cos')
      .replaceAll(r'\tan', 'tg')
      .replaceAll(r'\cot', 'ctg')
      .replaceAll(r'\tg', 'tg')
      .replaceAll(r'\ctg', 'ctg')
      .replaceAll(r'\rightarrow', ' → ')
      .replaceAll(r'\to', ' → ')
      .replaceAll(r'\longrightarrow', ' → ')
      .replaceAll(r'\uparrow', '↑')
      .replaceAll(r'\downarrow', '↓')
      .replaceAll(r'\sqrt{', '√(')
      .replaceAll(r'\sqrt', '√')
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
      .replaceAll(r'\smile', '⌒')
      .replaceAll(r'\setminus', ' ∖ ')
      .replaceAll(r'\mapsto', ' ↦ ')
      .replaceAll(r'\ll', ' ≪ ')
      .replaceAll(r'\degree', '°');
  if (stripBraces) {
    s = s.replaceAll('{', '').replaceAll('}', '');
  }
  return s;
}

const _subscriptDigitMap = {
  '0': '₀',
  '1': '₁',
  '2': '₂',
  '3': '₃',
  '4': '₄',
  '5': '₅',
  '6': '₆',
  '7': '₇',
  '8': '₈',
  '9': '₉',
};

const _superscriptCharMap = {
  '0': '⁰',
  '1': '¹',
  '2': '²',
  '3': '³',
  '4': '⁴',
  '5': '⁵',
  '6': '⁶',
  '7': '⁷',
  '8': '⁸',
  '9': '⁹',
  '+': '⁺',
  '-': '⁻',
};

String _toSuperscript(String raw) =>
    raw.split('').map((c) => _superscriptCharMap[c] ?? c).join();

String _toSubscriptDigits(String raw) =>
    raw.split('').map((c) => _subscriptDigitMap[c] ?? c).join();

final _protectedTechTokenRegex = RegExp(
  r'^(?:mp[34]|MP[34]|IPv[46]|Win(?:32|64)|x(?:86|64)|UTF8|HTML5|CSS3|HTTP[23]|Base64|DDR\d+|doc\d+|param\d+|F(?:[1-9]|1[0-2]))$',
);

final _chemArrowEqRegex = RegExp(r'\s*=\(([^)]+)\)=>\s*');
final _chemEquilibriumRegex = RegExp(r'\s*<=>\s*');
final _chemArrowRegex = RegExp(r'\s*(?:->|=>)\s*');
final _chemGasRegex = RegExp(r'((?:[A-Z][a-z]?\d*|\)\d*))\^(?=\s|$|\+|,|\.|\)|;)');
final _chemPrecipRegex = RegExp(r'((?:[A-Z][a-z]?\d*|\)\d*))v(?=\s|$|\+|,|\.|\)|;)');
final _chemChargeParenRegex = RegExp(r'\^\(([+\-]?\d+[+\-]?|[+\-])\)');
final _chemChargeBareRegex = RegExp(r'\^([23]?[+\-])(?=\s|$|\+|,|\.|;|\)|\\)');
final _chemSuperscriptRegex = RegExp(r'\^([+\-]?\d+)(?![A-Za-zа-яА-ЯёЁ])');
final _chemSubscriptDigitsRegex = RegExp(r'([A-Za-z]+|\))(\d+)');

final _subSupRegexInformatics = RegExp(r'(_\{([^\}]+)\}|(?<=\d)_([0-9]+)|\^\{([^\}]+)\}|\^([a-zA-Z0-9]+))');
final _subSupRegexGeneral = RegExp(
  r'(_\{([^\}]+)\}|_\(([^\)]+)\)|_([0-9]+)|_([a-zA-Zа-яА-ЯёЁ]+[0-9]*)|\^\{([^\}]+)\}|\^\(([^\)]+)\)|\^([+\-]?[0-9]+)|\^([+\-]?[a-zA-Zа-яА-ЯёЁ]+[0-9]*))',
);

/// Интеллектуальное форматирование химических формул и уравнений:
/// H2O -> H₂O, CaCl2 -> CaCl₂, CO2 -> CO₂, Ca(OH)2 -> Ca(OH)₂,
/// SO4^(2-) -> SO₄²⁻, Na^+ -> Na⁺, 10^-10 -> 10⁻¹⁰, =(t)=> -> —(t)→
String formatChemistryAndSubscripts(
  String text, {
  bool isInformatics = false,
  bool isChemistry = false,
}) {
  var s = text;

  // Стрелки условий реакций =(t)=>, =(Pt, t)=> и т.д.
  s = s.replaceAllMapped(_chemArrowEqRegex, (m) {
    final cond = m.group(1)!.trim();
    return ' —($cond)→ ';
  });

  // Стрелки реакций и логических переходов (сохраняем одиночные пробелы)
  s = s.replaceAll(_chemEquilibriumRegex, isChemistry ? ' ⇄ ' : ' ⇔ ');
  s = s.replaceAll(_chemArrowRegex, ' → ');
  s = s.replaceAll(r'\rightarrow', ' → ');
  s = s.replaceAll(r'\to', ' → ');
  s = s.replaceAll(r'\longrightarrow', ' → ');
  s = s.replaceAll(r'\uparrow', '↑');
  s = s.replaceAll(r'\downarrow', '↓');
  s = s.replaceAllMapped(
    _topXrightarrowRegex,
    (m) {
      final cond = '${m.group(1) ?? ''}${m.group(2) ?? ''}'.trim();
      return cond.isNotEmpty ? ' —($cond)→ ' : ' → ';
    },
  );

  if (isInformatics) {
    return s;
  }

  // Нормализация ошибочной кириллицы в формуле углекислого газа ("СО2" -> "CO₂")
  s = s.replaceAll('СО2', 'CO₂');

  // Химические газы (^) и осадки (v) — только непосредственно после формулы элемента/скобки,
  // чтобы не затронуть алгебраические выражения вроде 16v - 4
  s = s.replaceAllMapped(
    _chemGasRegex,
    (m) => '${m.group(1)}↑',
  );
  s = s.replaceAllMapped(
    _chemPrecipRegex,
    (m) => '${m.group(1)}↓',
  );

  // Ионные заряды и числовые показатели степени в скобках: ^(2+), ^(2-), ^(3+), ^(-2), ^(+), ^(-), ^(0)
  s = s.replaceAllMapped(
    _chemChargeParenRegex,
    (m) => _toSuperscript(m.group(1)!),
  );

  // Заряды ионов без скобок: H^+, Cl^-, Zn^2+, Fe^3+ (не трогаем алгебраическое x^2+1 и 10^-10)
  s = s.replaceAllMapped(
    _chemChargeBareRegex,
    (m) => _toSuperscript(m.group(1)!),
  );

  // Числовые степени без скобок: 10^-10 -> 10⁻¹⁰, моль^-1 -> моль⁻¹, x^2 -> x²
  s = s.replaceAllMapped(
    _chemSuperscriptRegex,
    (m) => _toSuperscript(m.group(1)!),
  );

  // Подстрочные индексы после латинской буквы элемента или закрывающей скобки ')',
  // с защитой от технических и табличных обозначений (.mp3, $C1, A1:A10, doc1.pdf, param1, IPv4)
  s = s.replaceAllMapped(_chemSubscriptDigitsRegex, (match) {
    final lettersOrParen = match.group(1)!;
    final digits = match.group(2)!;
    final token = '$lettersOrParen$digits';

    final prevChar = match.start > 0 ? s[match.start - 1] : '';
    final nextChar = match.end < s.length ? s[match.end] : '';

    if (prevChar == '.' || prevChar == r'$' || prevChar == '^' || prevChar == '_') {
      return token;
    }
    if (nextChar == ':' || prevChar == ':') {
      return token;
    }
    if (_protectedTechTokenRegex.hasMatch(token)) {
      return token;
    }

    return '$lettersOrParen${_toSubscriptDigits(digits)}';
  });

  return s;
}

/// Универсальный парсер явных подстрочных (`_`) и надстрочных (`^`) индексов
List<InlineSpan> buildMathSubSupSpans(
  String text, {
  required TextStyle baseStyle,
  required Color indexColor,
  bool isInformatics = false,
}) {
  final subSupRegex = isInformatics ? _subSupRegexInformatics : _subSupRegexGeneral;

  if (!subSupRegex.hasMatch(text)) {
    return [TextSpan(text: text, style: baseStyle)];
  }

  final spans = <InlineSpan>[];
  int lastIndex = 0;
  final fontSize = baseStyle.fontSize ?? 14.0;
  final indexFontSize = (fontSize * 0.65).clamp(9.0, 14.5);

  for (final match in subSupRegex.allMatches(text)) {
    if (match.start > lastIndex) {
      spans.add(TextSpan(
        text: text.substring(lastIndex, match.start),
        style: baseStyle,
      ));
    }

    final whole = match.group(0)!;
    final isSubscript = whole.startsWith('_');
    String rawIndex = '';
    for (int g = 2; g <= match.groupCount; g++) {
      final v = match.group(g);
      if (v != null && v.isNotEmpty) {
        rawIndex = v;
        break;
      }
    }

    final cleanIdx = rawIndex
        .replaceAll(r'\text{', '')
        .replaceAll('}', '')
        .replaceAll(r'\Delta', 'Δ')
        .trim();

    spans.add(WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Transform.translate(
        offset: Offset(0, isSubscript ? fontSize * 0.28 : -fontSize * 0.32),
        child: Text(
          cleanIdx,
          style: baseStyle.copyWith(
            fontSize: indexFontSize,
            fontWeight: FontWeight.w800,
            color: indexColor,
            letterSpacing: -0.2,
          ),
        ),
      ),
    ));

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
