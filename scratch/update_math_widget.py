# -*- coding: utf-8 -*-
with open('lib/widgets/math_formula_widget.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# Add import
import_stmt = "import 'package:flutter/material.dart';"
new_import = """import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';"""

text = text.replace(import_stmt, new_import, 1)

# Add _hasAdvancedLatex and _preprocessTex and _buildTexLine before _buildFormulaLine
target_build_line = """  Widget _buildFormulaLine(String line, Color textColor, Color primaryColor) {
    // 1. Поиск LaTeX дробей вида \\frac{...}{...}"""

replacement_build_line = """  static bool _hasAdvancedLatex(String line) {
    return line.contains(r'\\vec') ||
        line.contains(r'\\parallel') ||
        line.contains(r'\\iff') ||
        line.contains(r'\\upuparrows') ||
        line.contains(r'\\updownarrows') ||
        line.contains(r'\\Rightarrow') ||
        line.contains(r'\\Leftarrow') ||
        line.contains(r'\\Leftrightarrow') ||
        line.contains(r'\\implies') ||
        line.contains(r'\\begin{') ||
        line.contains(r'\\text{') ||
        line.contains(r'\\angle') ||
        line.contains(r'\\triangle') ||
        line.contains(r'\\subset') ||
        line.contains(r'\\subseteq') ||
        line.contains(r'\\notin') ||
        line.contains(r'\\varnothing') ||
        line.contains(r'\\emptyset') ||
        line.contains(r'\\quad') ||
        line.contains(r'\\&');
  }

  String _preprocessTex(String line) {
    var s = line;
    s = s.replaceAll(r'\\updownarrows', r'\\uparrow\\downarrow');
    s = s.replaceAll(r'\\&', r'\\text{\\&}');
    s = s.replaceAll(r'\\degree', r'^\\circ');
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

  Widget _buildFormulaLine(String line, Color textColor, Color primaryColor) {
    // 0. Если в строке присутствуют продвинутые математические/геометрические LaTeX конструкции
    // (векторы, стрелки эквивалентности, параллельность, текстовые блоки и т.д.),
    // отображаем через полноценный типографский движок flutter_math_fork.
    if (_hasAdvancedLatex(line)) {
      return _buildTexLine(line, textColor, primaryColor);
    }

    // 1. Поиск LaTeX дробей вида \\frac{...}{...}"""

assert target_build_line in text, 'target_build_line not found'
text = text.replace(target_build_line, replacement_build_line, 1)

# Upgrade _cleanLatex to handle text and vectors as fallback
clean_target = """  String _cleanLatex(String text) {
    return text
        .replaceAll(r'\\cdot', '·')"""

clean_replacement = """  String _cleanLatex(String text) {
    var s = text;
    s = s.replaceAllMapped(RegExp(r'\\\\text\\{([^\\}]+)\\}'), (m) => m.group(1) ?? '');
    s = s.replaceAllMapped(RegExp(r'\\\\vec\\{([^\\}]+)\\}'), (m) => '${m.group(1)}\\u20D7');
    return s
        .replaceAll(r'\\iff', ' ⇔ ')
        .replaceAll(r'\\upuparrows', ' ↑↑ ')
        .replaceAll(r'\\updownarrows', ' ↑↓ ')
        .replaceAll(r'\\parallel', ' ∥ ')
        .replaceAll(r'\\Rightarrow', ' ⇒ ')
        .replaceAll(r'\\Leftarrow', ' ⇐ ')
        .replaceAll(r'\\Leftrightarrow', ' ⇔ ')
        .replaceAll(r'\\implies', ' ⇒ ')
        .replaceAll(r'\\to', ' → ')
        .replaceAll(r'\\angle', '∠')
        .replaceAll(r'\\triangle', '△')
        .replaceAll(r'\\quad', '   ')
        .replaceAll(r'\\qquad', '      ')
        .replaceAll(r'\\;', ' ')
        .replaceAll(r'\\,', ' ')
        .replaceAll(r'\\&', '&')
        .replaceAll(r'\\subset', '⊂')
        .replaceAll(r'\\subseteq', '⊆')
        .replaceAll(r'\\notin', '∉')
        .replaceAll(r'\\varnothing', '∅')
        .replaceAll(r'\\emptyset', '∅')
        .replaceAll(r'\\cdot', '·')"""

assert clean_target in text, 'clean_target not found'
text = text.replace(clean_target, clean_replacement, 1)

with open('lib/widgets/math_formula_widget.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print('Updated lib/widgets/math_formula_widget.dart successfully!')
