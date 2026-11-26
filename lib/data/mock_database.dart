import 'package:flutter/material.dart';
import '../models/topic_model.dart';
import 'algebra_topics.dart';
import 'geometry_topics.dart';
import 'geometry_topics_7.dart';
import 'geometry_topics_9.dart';
import 'physics_topics_7.dart';
import 'russian_topics_7.dart';
import 'physics_topics.dart';
import 'russian_topics.dart';
import 'biology_topics.dart';
import 'literature_topics.dart';
import 'history_topics.dart';
import 'geography_topics.dart';
import 'informatics_topics.dart';
import 'algebra_topics_7.dart';
import 'algebra_topics_9.dart';
import 'informatics_topics_7.dart';
import 'informatics_topics_9.dart';
import 'probability_topics_7.dart';
import 'literature_topics_7.dart';
import 'english_topics_7.dart';
import 'probability_topics_8.dart';
import 'english_topics_8.dart';
import 'biology_topics_7.dart';
import 'history_topics_7.dart';
import 'physics_topics_9.dart';
import 'chemistry_topics_9.dart';
import 'russian_topics_9.dart';
import 'literature_topics_9.dart';
import 'biology_topics_9.dart';
import 'geography_topics_7.dart';
import 'geography_topics_9.dart';
import 'history_topics_9.dart';
import 'probability_topics_9.dart';
import 'chemistry_topics_8.dart';
import 'history_world_topics_9.dart';
import 'english_topics_9.dart';

class MockDatabase {
  static const List<Subject> subjects = [
    Subject(
      id: 'algebra',
      name: 'Алгебра',
      icon: Icons.functions_rounded,
      primaryColor: Color(0xFF3B82F6),
      secondaryColor: Color(0xFF60A5FA),
      description: 'Уравнения, корни, степени, формулы и графики',
      grades: [7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'geometry',
      name: 'Геометрия',
      icon: Icons.category_rounded,
      primaryColor: Color(0xFF8B5CF6),
      secondaryColor: Color(0xFFA78BFA),
      description: 'Фигуры, площади, теоремы, подобие и окружность',
      grades: [7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'physics',
      name: 'Физика',
      icon: Icons.bolt_rounded,
      primaryColor: Color(0xFFF59E0B),
      secondaryColor: Color(0xFFFBBF24),
      description: 'Теплота, электричество, оптика, магнетизм',
      grades: [7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'chemistry',
      name: 'Химия',
      icon: Icons.science_rounded,
      primaryColor: Color(0xFFEC4899),
      secondaryColor: Color(0xFFF472B6),
      description: 'Вещества, реакции, таблица Менделеева, моль, классы неорганики и ОВР (8–9 кл.)',
      grades: [8, 9, 10, 11],
    ),
    Subject(
      id: 'russian',
      name: 'Русский язык',
      icon: Icons.menu_book_rounded,
      primaryColor: Color(0xFF10B981),
      secondaryColor: Color(0xFF34D399),
      description: 'Синтаксис, пунктуация, обороты, правила',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'literature',
      name: 'Литература',
      icon: Icons.auto_stories_rounded,
      primaryColor: Color(0xFFE11D48),
      secondaryColor: Color(0xFFFB7185),
      description: 'Анализ произведений, сюжеты, герои, цитаты и сочинения',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'biology',
      name: 'Биология',
      icon: Icons.eco_rounded,
      primaryColor: Color(0xFF14B8A6),
      secondaryColor: Color(0xFF2DD4BF),
      description: 'Зоология: строение животных, систематика, поведение, эволюция',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'geography',
      name: 'География',
      icon: Icons.public_rounded,
      primaryColor: Color(0xFF06B6D4),
      secondaryColor: Color(0xFF67E8F9),
      description: 'Материки и океаны (7 кл.), природа России (8 кл.), хозяйство и регионы России (9 кл.)',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'history',
      name: 'История',
      icon: Icons.account_balance_rounded,
      primaryColor: Color(0xFFEA580C),
      secondaryColor: Color(0xFFFB923C),
      description: 'Всеобщая история и история России XVI — начала XX в. (7–9 кл.)',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'informatics',
      name: 'Информатика',
      icon: Icons.terminal_rounded,
      primaryColor: Color(0xFF6366F1),
      secondaryColor: Color(0xFF818CF8),
      description: 'Системы счисления, алгебра логики, алгоритмы, Паскаль, Python (§ 1–5.5)',
      grades: [7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'english',
      name: 'Английский язык',
      icon: Icons.language_rounded,
      primaryColor: Color(0xFF0284C7),
      secondaryColor: Color(0xFF38BDF8),
      description: 'Грамматика, лексика, времена, фразовые глаголы (Spotlight 7–9)',
      grades: [5, 6, 7, 8, 9, 10, 11],
    ),
    Subject(
      id: 'probability',
      name: 'Вероятность и статистика',
      icon: Icons.analytics_rounded,
      primaryColor: Color(0xFFD97706),
      secondaryColor: Color(0xFFFBBF24),
      description: 'Таблицы, диаграммы, графы, множества, комбинаторика, вероятность и случайные величины (7–9 кл.)',
      grades: [7, 8, 9, 10, 11],
    ),
  ];

  static const List<Topic> topics = [
    // =========================================================================
    // 8 КЛАСС: АЛГЕБРА (по учебнику Ю.Н. Макарычева и др.)
    // =========================================================================
    ...algebraTopics8,

    // =========================================================================
    // 8 КЛАСС: ГЕОМЕТРИЯ (по учебнику Л.С. Атанасяна и др. 2024 г.)
    // =========================================================================
    ...geometryTopics8,

    // =========================================================================
    // 8 КЛАСС: ФИЗИКА (по учебнику И.М. Пёрышкина 2026 г.)
    // =========================================================================
    ...physicsTopics8,

    // =========================================================================
    // 8 КЛАСС: ХИМИЯ (по учебнику О. С. Габриеляна и др. § 1–39)
    // =========================================================================
    ...chemistryTopics8,

    // =========================================================================
    // 8 КЛАСС: РУССКИЙ ЯЗЫК (по учебнику С.Г. Бархударова и др.)
    // =========================================================================
    ...russianTopics8,

    // =========================================================================
    // 8 КЛАСС: БИОЛОГИЯ (по учебнику В.В. Пасечника, Зоология, § 1–60)
    // =========================================================================
    ...biologyTopics8,

    // =========================================================================
    // 8 КЛАСС: ЛИТЕРАТУРА (по учебнику В.Я. Коровиной, Часть 1)
    // =========================================================================
    ...literatureTopics8,

    // =========================================================================
    // 8 КЛАСС: ГЕОГРАФИЯ (по учебнику А.И. Алексеева и др. «Полярная звезда»)
    // =========================================================================
    ...geographyTopics8,

    // =========================================================================
    // 8 КЛАСС: ВСЕОБЩАЯ ИСТОРИЯ (по учебнику В.Р. Мединского, А.О. Чубарьяна)
    // =========================================================================
    ...historyTopics8,

    // =========================================================================
    // 8 КЛАСС: ИНФОРМАТИКА (по учебнику Л.Л. Босовой, А.Ю. Босовой ФГОС)
    // =========================================================================
    ...informaticsTopics8,

    // =========================================================================
    // 7 КЛАСС: ГЕОМЕТРИЯ (по учебнику Л.С. Атанасяна и др. п. 1–45)
    // =========================================================================
    ...geometryTopics7,

    // =========================================================================
    // 9 КЛАСС: ГЕОМЕТРИЯ (по учебнику Л.С. Атанасяна и др. п. 84–137)
    // =========================================================================
    ...geometryTopics9,

    // =========================================================================
    // 7 КЛАСС: ФИЗИКА (по учебнику А.В. Пёрышкина § 1–68)
    // =========================================================================
    ...physicsTopics7,

    // =========================================================================
    // 7 КЛАСС: РУССКИЙ ЯЗЫК (по учебнику М.Т. Баранова и др. § 1–56)
    // =========================================================================
    ...russianTopics7,

    // =========================================================================
    // 7 КЛАСС: АЛГЕБРА (по учебнику Ю.Н. Макарычева и др. п. 1–46)
    // =========================================================================
    ...algebraTopics7,

    // =========================================================================
    // 9 КЛАСС: АЛГЕБРА (по учебнику Ю.Н. Макарычева и др. п. 1–31)
    // =========================================================================
    ...algebraTopics9,

    // =========================================================================
    // 7 КЛАСС: ИНФОРМАТИКА (по учебнику Л.Л. Босовой и др. § 1.1–5.2)
    // =========================================================================
    ...informaticsTopics7,

    // =========================================================================
    // 9 КЛАСС: ИНФОРМАТИКА (по учебнику Л.Л. Босовой и др. § 1.1–4.4)
    // =========================================================================
    ...informaticsTopics9,

    // =========================================================================
    // 7 КЛАСС: ВЕРОЯТНОСТЬ И СТАТИСТИКА (по учебнику И.Р. Высоцкого и др. п. 1–31)
    // =========================================================================
    ...probabilityTopics7,

    // =========================================================================
    // 7 КЛАСС: ЛИТЕРАТУРА (по учебнику В.Я. Коровиной и др. Ч. 1 и 2)
    // =========================================================================
    ...literatureTopics7,

    // =========================================================================
    // 7 КЛАСС: АНГЛИЙСКИЙ ЯЗЫК (по учебнику Spotlight 7, Ваулина и др. Модули 1–10)
    // =========================================================================
    ...englishTopics7,

    // =========================================================================
    // 8 КЛАСС: ВЕРОЯТНОСТЬ И СТАТИСТИКА (по учебнику И.Р. Высоцкого и др. п. 32–45)
    // =========================================================================
    ...probabilityTopics8,

    // =========================================================================
    // 8 КЛАСС: АНГЛИЙСКИЙ ЯЗЫК (по учебнику Spotlight 8, Ваулина и др. Модули 1–8)
    // =========================================================================
    ...englishTopics8,

    // =========================================================================
    // 7 КЛАСС: БИОЛОГИЯ (по учебнику В.В. Пасечника «Линия жизни» § 1–26)
    // =========================================================================
    ...biologyTopics7,

    // =========================================================================
    // 7 КЛАСС: ВСЕОБЩАЯ ИСТОРИЯ (История Нового времени XV–XVII вв. § 1–23)
    // =========================================================================
    ...historyTopics7,

    // =========================================================================
    // 9 класс: Физика (Пёрышкин, § 1–67)
    // =========================================================================
    ...physicsTopics9,

    // =========================================================================
    // 9 класс: Химия (Рудзитис, Фельдман, § 1–41)
    // =========================================================================
    ...chemistryTopics9,

    // =========================================================================
    // 9 класс: Русский язык (Бархударов, § 1–28)
    // =========================================================================
    ...russianTopics9,

    // =========================================================================
    // 9 класс: Литература (Коровина, темы 1–29)
    // =========================================================================
    ...literatureTopics9,

    // =========================================================================
    // 9 класс: Биология (Пасечник, темы 1–60)
    // =========================================================================
    ...biologyTopics9,

    // =========================================================================
    // 7 класс: География (А. И. Алексеев и др., «Полярная звезда», § 1–58)
    // =========================================================================
    ...geographyTopics7,

    // =========================================================================
    // 9 класс: География (А. И. Алексеев и др., «Полярная звезда», § 1–59)
    // =========================================================================
    ...geographyTopics9,

    // =========================================================================
    // 9 класс: История России (В. Р. Мединский, А. В. Торкунов, § 1–37)
    // =========================================================================
    ...historyTopics9,

    // =========================================================================
    // 9 класс: Вероятность и статистика (И. Р. Высоцкий, И. В. Ященко, п. 46–65)
    // =========================================================================
    ...probabilityTopics9,

    // =========================================================================
    // 9 класс: Всеобщая история (В. Р. Мединский, А. О. Чубарьян, § 1–23)
    // =========================================================================
    ...historyWorldTopics9,

    // =========================================================================
    // 9 класс: Английский язык (Spotlight 9, Ю. Е. Ваулина и др., Модули 1–8)
    // =========================================================================
    ...englishTopics9,
  ];

  static Map<int, Map<String, List<Topic>>>? _cachedGradeSubjectTopics;
  static Map<int, int>? _cachedGradeTopicCounts;
  static Map<String, String>? _cachedSearchBlobs;
  static Map<int, List<Subject>>? _cachedSubjectsForGrade;

  static void _ensureInitialized() {
    if (_cachedGradeSubjectTopics != null) return;

    final map = <int, Map<String, List<Topic>>>{};
    final countMap = <int, int>{};
    final searchBlobs = <String, String>{};
    final topicMap = <String, Topic>{};

    for (int i = 0; i < topics.length; i++) {
      final t = topics[i];
      topicMap[t.id] = t;
      final gradeMap = map.putIfAbsent(t.grade, () => <String, List<Topic>>{});
      final list = gradeMap.putIfAbsent(t.subjectId, () => <Topic>[]);
      list.add(t);

      countMap[t.grade] = (countMap[t.grade] ?? 0) + 1;

      final sb = StringBuffer();
      sb.write(t.title);
      sb.write(' ');
      sb.write(t.shortSummary);
      for (final tag in t.tags) {
        sb.write(' ');
        sb.write(tag);
      }
      for (final f in t.formulas) {
        sb.write(' ');
        sb.write(f.title);
        sb.write(' ');
        sb.write(f.formula);
      }
      for (final d in t.definitions) {
        sb.write(' ');
        sb.write(d.term);
        sb.write(' ');
        sb.write(d.definition);
      }
      for (final r in t.rules) {
        sb.write(' ');
        sb.write(r);
      }
      for (final lh in t.lifehacks) {
        sb.write(' ');
        sb.write(lh);
      }
      for (final ex in t.allExamples) {
        sb.write(' ');
        sb.write(ex.task);
        sb.write(' ');
        sb.write(ex.answer);
        for (final s in ex.steps) {
          sb.write(' ');
          sb.write(s);
        }
      }
      searchBlobs[t.id] = sb.toString().toLowerCase();
    }

    _cachedGradeSubjectTopics = map;
    _cachedGradeTopicCounts = countMap;
    _cachedSearchBlobs = searchBlobs;
    _cachedTopicById = topicMap;

    final subjMap = <int, List<Subject>>{};
    for (int grade = 1; grade <= 11; grade++) {
      subjMap[grade] = subjects.where((s) => s.grades.contains(grade)).toList(growable: false);
    }
    _cachedSubjectsForGrade = subjMap;
  }

  static List<Subject> getSubjectsForGrade(int grade) {
    _ensureInitialized();
    return _cachedSubjectsForGrade![grade] ?? const [];
  }

  static int getTopicsCountForGrade(int grade) {
    _ensureInitialized();
    return _cachedGradeTopicCounts![grade] ?? 0;
  }

  static int getTopicsCountForGradeAndSubject(int grade, String subjectId) {
    _ensureInitialized();
    return _cachedGradeSubjectTopics![grade]?[subjectId]?.length ?? 0;
  }

  static List<Topic> getTopicsForGradeAndSubject(int grade, String subjectId) {
    _ensureInitialized();
    return _cachedGradeSubjectTopics![grade]?[subjectId] ?? const [];
  }

  static List<Topic> searchTopics(String query, {int? grade}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];

    _ensureInitialized();
    final blobs = _cachedSearchBlobs!;
    final results = <Topic>[];

    for (int i = 0; i < topics.length; i++) {
      final t = topics[i];
      if (grade != null && t.grade != grade) continue;
      final blob = blobs[t.id];
      if (blob != null && blob.contains(q)) {
        results.add(t);
      }
    }

    return results;
  }

  static Map<String, Topic>? _cachedTopicById;

  static Topic? getTopicById(String id) {
    _ensureInitialized();
    return _cachedTopicById?[id];
  }
}
