# -*- coding: utf-8 -*-
with open('test/topic_detail_screen_test.dart', 'r', encoding='utf-8') as f:
    text = f.read()

new_test = """  testWidgets('MathFormulaWidget renders authentic LaTeX vector and geometry formulas',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              MathFormulaWidget(formula: r'\\vec{a} = \\vec{b} \\iff \\vec{a} \\upuparrows \\vec{b} \\quad \\& \\quad |\\vec{a}| = |\\vec{b}|'),
              MathFormulaWidget(formula: r'\\vec{a} = \\vec{AB}, \\quad |\\vec{a}| = |\\vec{AB}| = AB'),
              MathFormulaWidget(formula: r'\\vec{0} = \\vec{AA}, \\quad |\\vec{0}| = 0'),
              MathFormulaWidget(formula: r'AB = CD \\text{ и } AB \\parallel CD \\Rightarrow ABCD — \\text{параллелограмм}'),
            ],
          ),
        ),
      ),
    );

    // Verify that raw unparsed LaTeX tokens are NOT shown as plain text
    expect(find.textContaining(r'\\vec{a}'), findsNothing);
    expect(find.textContaining(r'\\iff'), findsNothing);
    expect(find.textContaining(r'\\parallel'), findsNothing);
    expect(find.textContaining(r'\\text{'), findsNothing);
  });
}"""

if '\r\n' in text:
    new_test = new_test.replace('\n', '\r\n')

text = text[:-2] + '\n' + new_test

with open('test/topic_detail_screen_test.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print('Added vector formula test!')
