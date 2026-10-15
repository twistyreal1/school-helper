import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_helper/main.dart';
import 'package:school_helper/screens/loading_screen.dart';
import 'package:school_helper/screens/onboarding_screen.dart';
import 'package:school_helper/screens/home_screen.dart';
import 'package:school_helper/widgets/liquid_glass.dart';

void main() {
  testWidgets('App smoke test - verifies launch with LoadingScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const SchoolHelperApp());
    expect(find.text('Классмейт'), findsWidgets);
    expect(find.byType(LoadingScreen), findsOneWidget);
    expect(find.byType(LiquidLoadingIndicator), findsOneWidget);
  });

  testWidgets('LoadingScreen preview renders correctly with tips and progress', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoadingScreen(isPreview: true),
      ),
    );

    expect(find.text('Классмейт'), findsOneWidget);
    expect(find.text('Умный помощник по учебе 5–11 классов'), findsOneWidget);
    expect(find.byType(LiquidLoadingIndicator), findsOneWidget);
    expect(find.byType(LiquidGlassContainer), findsWidgets);
    expect(find.text('Закрыть предпросмотр'), findsOneWidget);
  });

  testWidgets('OnboardingScreen renders step 1 with liquid glass feature items', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    expect(find.text('Классмейт'), findsOneWidget);
    expect(find.text('Алгебра и Геометрия'), findsOneWidget);
    expect(find.text('Физика и Естественные науки'), findsOneWidget);
    expect(find.text('Гуманитарный блок'), findsOneWidget);
    expect(find.text('Настроить под себя'), findsOneWidget);
    expect(find.text('Пропустить'), findsOneWidget);
  });

  testWidgets('OnboardingScreen navigates between steps and allows grade/theme selection',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    try {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      // Tap "Настроить под себя" to go to Step 2 (Profile)
      await tester.tap(find.text('Настроить под себя'));
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('Давай настроим твой профиль'), findsOneWidget);
      expect(find.text('Как тебя зовут?'), findsOneWidget);
      expect(find.text('Твой класс:'), findsOneWidget);

      // Verify 8th grade is selected by default and other grade cards exist
      expect(find.text('8'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);

      // Tap on grade 9
      await tester.tap(find.text('9'));
      for (int i = 0; i < 3; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('9 класс'), findsOneWidget);

      // Tap "Выбрать тему" to go to Step 3 (Themes)
      await tester.tap(find.text('Выбрать тему'));
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.text('Выбери свой стиль'), findsOneWidget);
      expect(find.text('Ночной космос'), findsOneWidget);
      expect(find.text('Лазурный день'), findsOneWidget);
      expect(find.text('Мятный чай'), findsOneWidget);
      expect(find.text('Школьная тетрадь'), findsOneWidget);
      expect(find.text('Начать учиться'), findsOneWidget);
    } finally {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    }
  });

  testWidgets('LiquidGlassContainer renders child with backdrop blur and specular highlights',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LiquidGlassBackground(
            child: Center(
              child: LiquidGlassContainer(
                child: Text('Liquid Glass Content'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Liquid Glass Content'), findsOneWidget);
    expect(find.byType(BackdropFilter), findsWidgets);
  });

  testWidgets('HomeScreen renders liquid glass header, stats banner, search bar and subjects',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    try {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Классмейт'), findsOneWidget);
      expect(find.byType(LiquidGlassBackground), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Выбор класса:'), findsOneWidget);
      expect(find.text('Информатика'), findsOneWidget);
      expect(find.text('Алгебра'), findsOneWidget);
      expect(find.text('Геометрия'), findsOneWidget);
      expect(find.text('Физика'), findsOneWidget);
    } finally {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    }
  });
}
