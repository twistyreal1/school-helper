import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_helper/data/mock_database.dart';
import 'package:school_helper/models/topic_model.dart';
import 'package:school_helper/screens/topic_detail_screen.dart';
import 'package:school_helper/widgets/geometry_diagram_widget.dart';
import 'package:school_helper/widgets/math_formula_widget.dart';

void main() {
  testWidgets('TopicDetailScreen renders Russian language topic with structured sections',
      (WidgetTester tester) async {
    final russianTopic =
        MockDatabase.topics.firstWhere((t) => t.subjectId == 'russian' && t.rules.isNotEmpty);

    await tester.pumpWidget(
      MaterialApp(
        home: TopicDetailScreen(topic: russianTopic),
      ),
    );

    // Verify title and header
    expect(find.text(russianTopic.title), findsOneWidget);

    // Verify section tabs exist
    expect(find.text('Все разделы'), findsOneWidget);
    expect(find.text('Правила'), findsWidgets);

    // Tap on "Правила" tab to test section filtering
    await tester.tap(find.text('Правила').first);
    await tester.pumpAndSettle();

    // Verify that the screen still renders properly
    expect(find.byType(TopicDetailScreen), findsOneWidget);
  });

  testWidgets('TopicDetailScreen renders Literature topic with literary tabs',
      (WidgetTester tester) async {
    final literatureTopic =
        MockDatabase.topics.firstWhere((t) => t.subjectId == 'literature' && t.rules.isNotEmpty);

    await tester.pumpWidget(
      MaterialApp(
        home: TopicDetailScreen(topic: literatureTopic),
      ),
    );

    expect(find.text(literatureTopic.title), findsOneWidget);
    expect(find.text('Сюжет'), findsWidgets);
    expect(find.text('Герои'), findsWidgets);
    expect(find.text('Анализ'), findsWidgets);

    await tester.tap(find.text('Сюжет').first);
    await tester.pumpAndSettle();
    expect(find.byType(TopicDetailScreen), findsOneWidget);
  });

  testWidgets('TopicDetailScreen renders Geometry topic with vector diagram',
      (WidgetTester tester) async {
    final geometryTopic =
        MockDatabase.topics.firstWhere((t) => t.subjectId == 'geometry' && t.figureType != null);

    await tester.pumpWidget(
      MaterialApp(
        home: TopicDetailScreen(topic: geometryTopic),
      ),
    );

    expect(find.byType(GeometryDiagramWidget), findsOneWidget);
  });

  testWidgets('TopicDetailScreen renders Algebra topic with MathFormulaWidget',
      (WidgetTester tester) async {
    final algebraTopic =
        MockDatabase.topics.firstWhere((t) => t.subjectId == 'algebra' && t.formulas.isNotEmpty);

    await tester.pumpWidget(
      MaterialApp(
        home: TopicDetailScreen(topic: algebraTopic),
      ),
    );

    expect(find.byType(MathFormulaWidget), findsWidgets);
  });

  testWidgets('MathFormulaWidget renders subscript indices for S_d and d_1 = d_2',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              MathFormulaWidget(formula: 'S_d = a · b'),
              MathFormulaWidget(formula: 'd_1 = d_2  (AC = BD)'),
              MathFormulaWidget(formula: 'S_{бок} = P · h'),
              MathFormulaWidget(formula: 'x_{1,2} = \\frac{-b \\pm \\sqrt{D}}{2a}'),
            ],
          ),
        ),
      ),
    );

    // Verify small subscript letters/numbers exist as text inside the widget
    expect(find.text('d'), findsWidgets);
    expect(find.text('1'), findsWidgets);
    expect(find.text('2'), findsWidgets);
    expect(find.text('бок'), findsWidgets);
    expect(find.text('1,2'), findsWidgets);
  });

  testWidgets('MathFormulaWidget renders authentic radical square roots with vinculum bar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              MathFormulaWidget(formula: r'\sqrt{a} = b <=> b^2 = a  (a ≥ 0, b ≥ 0)'),
              MathFormulaWidget(formula: r'c = \sqrt{a^2 + b^2}'),
              MathFormulaWidget(formula: r'3 · √49 - 2 · √121'),
              MathFormulaWidget(formula: r'√(a) = b'),
            ],
          ),
        ),
      ),
    );

    // Verify that RadicalWidget is rendered instead of plain "√(a)" text
    expect(find.byType(RadicalWidget), findsWidgets);
    expect(find.text('√(a)'), findsNothing);
    expect(find.text('a'), findsWidgets);
    expect(find.text('49'), findsWidgets);
    expect(find.text('121'), findsWidgets);
  });

  testWidgets('GeometryDiagramWidget renders without overflow on narrow 320px screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320 * 2.0, 640 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    try {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GeometryDiagramWidget(figureType: 'rectangle'),
          ),
        ),
      );

      expect(find.byType(GeometryDiagramWidget), findsOneWidget);
      expect(tester.takeException(), null);
    } finally {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    }
  });

  testWidgets('MathFormulaWidget renders nested LaTeX fraction with square roots in numerator',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MathFormulaWidget(
            formula: r'x_{1,2} = \frac{-b ± \sqrt{D}}{2a}',
          ),
        ),
      ),
    );

    // Verify that \frac was parsed and didn't fall back to literal text
    expect(find.textContaining(r'\frac'), findsNothing);
    expect(find.byType(RadicalWidget), findsOneWidget);
  });

  testWidgets('TopicDetailScreen renders fractions in lifehacks and examples as real stacked fractions',
      (WidgetTester tester) async {
    final mockTopic = Topic(
      id: 'test_frac_topic',
      grade: 8,
      subjectId: 'algebra',
      title: 'Дроби',
      shortSummary: 'Сокращение дробей',
      lifehacks: [
        'Ловушка ОГЭ: в выражении (x² - 9)/(x - 3) нельзя сокращать x² и x!',
        'Сначала разложите числитель: (x - 3)(x + 3)/(x - 3) = x + 3.',
      ],
      examples: [
        ExampleItem(
          task: 'Сократите дробь: (x² - 16) / (2x + 8)',
          steps: ['Разложим числитель: (x - 4)(x + 4)/(2(x + 4))'],
          answer: '(x - 4)/2',
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: TopicDetailScreen(topic: mockTopic),
      ),
    );

    await tester.pumpAndSettle();

    // Verify MathFractionWidget is found in lifehacks and examples
    expect(find.byType(MathFractionWidget), findsWidgets);
  });

  testWidgets('MathFormulaWidget renders authentic LaTeX vector and geometry formulas',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              MathFormulaWidget(formula: r'\vec{a} = \vec{b} \iff \vec{a} \upuparrows \vec{b} \quad \& \quad |\vec{a}| = |\vec{b}|'),
              MathFormulaWidget(formula: r'\vec{a} = \vec{AB}, \quad |\vec{a}| = |\vec{AB}| = AB'),
              MathFormulaWidget(formula: r'\vec{0} = \vec{AA}, \quad |\vec{0}| = 0'),
              MathFormulaWidget(formula: r'AB = CD \text{ и } AB \parallel CD \Rightarrow ABCD — \text{параллелограмм}'),
            ],
          ),
        ),
      ),
    );

    // Verify that raw unparsed LaTeX tokens are NOT shown as plain text
    expect(find.textContaining(r'\vec{a}'), findsNothing);
    expect(find.textContaining(r'\iff'), findsNothing);
    expect(find.textContaining(r'\parallel'), findsNothing);
    expect(find.textContaining(r'\text{'), findsNothing);
  });

  testWidgets('MathFormulaWidget renders compact vertical fraction for (2x - 5) / (x - 4)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MathFormulaWidget(formula: '(2x - 5) / (x - 4)'),
              ],
            ),
          ),
        ),
      ),
    );

    final fracFinder = find.byType(MathFractionWidget);
    expect(fracFinder, findsOneWidget);

    final fracSize = tester.getSize(fracFinder);
    expect(fracSize.width, lessThan(150.0));
    expect(find.textContaining('2x - 5', findRichText: true), findsOneWidget);
    expect(find.textContaining('x - 4', findRichText: true), findsOneWidget);

    // Ensure the horizontal fraction bar inside MathFractionWidget stays compact
    final barFinder = find.descendant(
      of: fracFinder,
      matching: find.byType(DecoratedBox),
    );
    expect(barFinder, findsOneWidget);
    final barSize = tester.getSize(barFinder);
    expect(barSize.width, lessThan(150.0));
    expect(barSize.height, lessThan(4.0));
  });

  test('formatChemistryAndSubscripts formats chemical reactions without corrupting algebra', () {
    expect(
      formatChemistryAndSubscripts('CaO + 2HCl -> CaCl2 + H2O', isChemistry: true),
      'CaO + 2HCl → CaCl₂ + H₂O',
    );
    expect(
      formatChemistryAndSubscripts('CO3^(2-) + H2O <=> HCO3^- + OH^-', isChemistry: true),
      'CO₃²⁻ + H₂O ⇄ HCO₃⁻ + OH⁻',
    );
    expect(
      formatChemistryAndSubscripts('CaCO3(тв) =(t)=> CaO(тв) + CO2(г)', isChemistry: true),
      'CaCO₃(тв) —(t)→ CaO(тв) + CO₂(г)',
    );
    expect(formatChemistryAndSubscripts('2Al^(3+)', isChemistry: true), '2Al³⁺');
    expect(formatChemistryAndSubscripts('Cu(OH)2v', isChemistry: true), 'Cu(OH)₂↓');
    expect(formatChemistryAndSubscripts('SO2^', isChemistry: true), 'SO₂↑');
    expect(formatChemistryAndSubscripts('10^-10', isChemistry: true), '10⁻¹⁰');
    expect(formatChemistryAndSubscripts('СО2', isChemistry: true), 'CO₂');

    // Algebraic safety checks
    expect(formatChemistryAndSubscripts('16v - 4 = 0'), '16v - 4 = 0');
    expect(formatChemistryAndSubscripts('x^2+1'), 'x²+1');

    // Tech token protection even outside informatics mode
    expect(
      formatChemistryAndSubscripts('file.mp3 doc1.pdf param1 A1:A10 F5 IPv4'),
      'file.mp3 doc1.pdf param1 A1:A10 F5 IPv4',
    );
    expect(
      formatChemistryAndSubscripts('CaO + 2HCl -> CaCl2 + H2O', isInformatics: true),
      'CaO + 2HCl → CaCl2 + H2O',
    );
  });

  test('FractionParser filters prose/informatics slashes and parses math/chem fractions', () {
    expect(
      FractionParser.findSlashFractions('do/does -ed/-ing V2 / V BIOS/UEFI Pt/Pd 103/112'),
      isEmpty,
    );

    final decFrac = FractionParser.findSlashFractions('n = 1.12 / 22.4');
    expect(decFrac, hasLength(1));
    expect(decFrac.first.numerator, '1.12');
    expect(decFrac.first.denominator, '22.4');

    final chemFrac = FractionParser.findSlashFractions('n = V / Vm');
    expect(chemFrac, hasLength(1));
    expect(chemFrac.first.numerator, 'V');
    expect(chemFrac.first.denominator, 'Vm');
  });

  testWidgets('TopicDetailScreen preserves informatics identifiers and English slash prose',
      (WidgetTester tester) async {
    const infoTopic = Topic(
      id: 'test_info',
      title: 'Python функции',
      subjectId: 'informatics',
      grade: 9,
      shortSummary: 'Форматы file.mp3, cell A1:A10, клавиша F5, протокол IPv4 и BIOS/UEFI.',
      rules: ['Используйте def function_name(param1, default_val): в скриптах.'],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: TopicDetailScreen(topic: infoTopic),
      ),
    );

    expect(find.byType(MathFractionWidget), findsNothing);
    expect(find.textContaining('file.mp3', findRichText: true), findsWidgets);
    expect(find.textContaining('A1:A10', findRichText: true), findsWidgets);
    expect(find.textContaining('IPv4', findRichText: true), findsWidgets);
    expect(find.textContaining('function_name(param1, default_val)', findRichText: true), findsOneWidget);

    const engTopic = Topic(
      id: 'test_eng',
      title: 'Present Simple & Past',
      subjectId: 'english',
      grade: 7,
      shortSummary: 'Глаголы do/does, окончания -ed/-ing и таблица V2 / V.',
      rules: ['Regular/habitual действия используют do/does.'],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: TopicDetailScreen(topic: engTopic),
      ),
    );

    expect(find.byType(MathFractionWidget), findsNothing);
    expect(find.textContaining('do/does', findRichText: true), findsWidgets);
    expect(find.textContaining('-ed/-ing', findRichText: true), findsWidgets);
    expect(find.textContaining('V2 / V', findRichText: true), findsWidgets);
  });

  testWidgets('TopicDetailScreen renders compact fractions in algebraic topics and chemistry reactions',
      (WidgetTester tester) async {
    const mathChemTopic = Topic(
      id: 'test_alg_frac',
      title: 'Рациональные выражения',
      subjectId: 'algebra',
      grade: 8,
      shortSummary: 'Значение (2x - 5) / (x - 4) определено при x != 4.',
      formulas: [
        FormulaItem(
          title: 'Рациональная дробь',
          formula: 'y = (2x - 5) / (x - 4)',
        ),
      ],
      rules: ['Для n = 1.12 / 22.4 и V / Vm используйте компактные вертикальные дроби.'],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: TopicDetailScreen(topic: mathChemTopic),
      ),
    );

    final fracWidgets = find.byType(MathFractionWidget);
    expect(fracWidgets, findsWidgets);
    for (final elem in fracWidgets.evaluate()) {
      expect(elem.size?.width ?? 999, lessThan(150.0));
    }
  });

  testWidgets('MathFormulaWidget renders multi-storey fractions, trigonometric functions and chemistry arrows cleanly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                MathFormulaWidget(formula: r'\frac{\frac{A}{B}}{\frac{C}{D}} = \frac{A}{B} : \frac{C}{D} = \frac{A · D}{B · C}'),
                MathFormulaWidget(formula: r'S = \frac{1}{2} a · b · \sin C'),
                MathFormulaWidget(formula: r'\text{Соединение: } A + B \rightarrow AB \qquad \text{Разложение: } AB \rightarrow A + B'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify nested fractions: should find multiple MathFractionWidgets (outer + inner numerators/denominators)
    expect(find.byType(MathFractionWidget), findsWidgets);
    // Raw LaTeX tokens must never leak into rendered UI
    expect(find.textContaining(r'\frac'), findsNothing);
    expect(find.textContaining(r'\sin'), findsNothing);
    expect(find.textContaining(r'\rightarrow'), findsNothing);
    expect(find.textContaining(r'\text{'), findsNothing);
    expect(find.textContaining('sin C', findRichText: true), findsWidgets);
    expect(find.textContaining('→', findRichText: true), findsWidgets);
  });

  testWidgets('MathFormulaWidget strips aligned environment and renders infinity correctly without infty corruption',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                MathFormulaWidget(
                  formula: r'\begin{aligned} &y = \sqrt{x}: \quad D(y) = [0; +\infty), \quad E(y) = [0; +\infty) \\ &y = \frac{k}{x}: \quad D(y) = (-\infty; 0) \cup (0; +\infty) \end{aligned}',
                ),
                MathFormulaWidget(
                  formula: r'\begin{aligned} &f(-x) = f(x) \implies \text{чётная} \\ &f(-x) = -f(x) \implies \text{нечётная} \end{aligned}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining(r'\begin{aligned}'), findsNothing);
    expect(find.textContaining(r'\end{aligned}'), findsNothing);
    expect(find.textContaining('∈fty', findRichText: true), findsNothing);
    expect(find.textContaining('∞', findRichText: true), findsWidgets);
  });

  testWidgets('GeometryDiagramWidget renders right triangle, square, and circle angles diagrams with pills',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                GeometryDiagramWidget(figureType: 'right_triangle'),
                GeometryDiagramWidget(figureType: 'square'),
                GeometryDiagramWidget(figureType: 'circle_angles'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GeometryDiagramWidget), findsNWidgets(3));
    expect(find.text('Прямоугольный треугольник и теорема Пифагора'), findsOneWidget);
    expect(find.text('Квадрат: все стороны равны, углы 90°'), findsOneWidget);
    expect(find.text('Вписанный и центральный углы окружности'), findsOneWidget);
  });
}