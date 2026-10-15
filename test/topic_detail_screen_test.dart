import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_helper/data/mock_database.dart';
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
}
