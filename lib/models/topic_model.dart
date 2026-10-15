import 'package:flutter/material.dart';

enum AppThemeMode {
  modernBlue,   // Лазурный день (светлая современная)
  midnightCyber,// Ночной космос (темная неоновая)
  emeraldMatcha,// Мятный чай (пастельная мягкая)
  warmNotebook, // Школьная тетрадь (теплая крафтовая)
}

extension AppThemeModeExtension on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.modernBlue:
        return 'Лазурный день';
      case AppThemeMode.midnightCyber:
        return 'Ночной космос';
      case AppThemeMode.emeraldMatcha:
        return 'Мятный чай';
      case AppThemeMode.warmNotebook:
        return 'Школьная тетрадь';
    }
  }

  String get description {
    switch (this) {
      case AppThemeMode.modernBlue:
        return 'Свежая светлая тема с яркими синими акцентами';
      case AppThemeMode.midnightCyber:
        return 'Глубокая темная тема, приятная для вечерней учебы';
      case AppThemeMode.emeraldMatcha:
        return 'Успокаивающая пастельная тема цвета зеленого чая';
      case AppThemeMode.warmNotebook:
        return 'Теплая бумага и чернила, уютный конспект';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemeMode.modernBlue:
        return Icons.wb_sunny_rounded;
      case AppThemeMode.midnightCyber:
        return Icons.nightlight_round;
      case AppThemeMode.emeraldMatcha:
        return Icons.eco_rounded;
      case AppThemeMode.warmNotebook:
        return Icons.menu_book_rounded;
    }
  }
}

class Subject {
  final String id;
  final String name;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final String description;
  final List<int> grades;

  const Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.description,
    required this.grades,
  });
}

class DefinitionItem {
  final String term;
  final String definition;
  final String? note;

  const DefinitionItem({
    required this.term,
    required this.definition,
    this.note,
  });
}

class FormulaItem {
  final String title;
  final String formula;
  final String? description;
  final Map<String, String>? variables;

  const FormulaItem({
    required this.title,
    required this.formula,
    this.description,
    this.variables,
  });
}

class ExampleItem {
  final String task;
  final List<String> steps;
  final String answer;

  const ExampleItem({
    required this.task,
    required this.steps,
    required this.answer,
  });
}

class Topic {
  final String id;
  final String title;
  final String subjectId;
  final int grade;
  final String shortSummary;
  final List<FormulaItem> formulas;
  final List<DefinitionItem> definitions;
  final List<String> rules;
  final List<String> lifehacks;
  final ExampleItem? example;
  final List<ExampleItem> examples;
  final List<String> tags;
  final String? figureType;

  const Topic({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.grade,
    required this.shortSummary,
    this.formulas = const [],
    this.definitions = const [],
    this.rules = const [],
    this.lifehacks = const [],
    this.example,
    this.examples = const [],
    this.tags = const [],
    this.figureType,
  });

  /// Возвращает все примеры: из `examples` или одиночный `example`
  List<ExampleItem> get allExamples {
    if (examples.isNotEmpty) return examples;
    if (example != null) return [example!];
    return const [];
  }
}
