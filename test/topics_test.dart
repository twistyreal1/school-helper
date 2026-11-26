import 'package:flutter_test/flutter_test.dart';
import 'package:school_helper/data/mock_database.dart';

void main() {
  group('MockDatabase 8th Grade Topics Verification', () {
    test('All topics have unique IDs', () {
      final ids = MockDatabase.topics.map((t) => t.id).toList();
      final uniqueIds = ids.toSet();
      expect(uniqueIds.length, ids.length, reason: 'Duplicate topic IDs found in database');
    });

    test('Algebra 8 topics are loaded (50 individual paragraphs § 1–50)', () {
      final algebraTopics = MockDatabase.getTopicsForGradeAndSubject(8, 'algebra');
      expect(algebraTopics.length, 50);

      // Verify that paragraph 34 explicitly exists as requested by user
      final p34 = algebraTopics.firstWhere((t) => t.title.startsWith('§ 34.'));
      expect(p34.title.contains('Числовые неравенства'), true);

      for (final topic in algebraTopics) {
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        expect(topic.tags.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Geometry 8 topics are loaded (36 individual topics with figures)', () {
      final geometryTopics = MockDatabase.getTopicsForGradeAndSubject(8, 'geometry');
      expect(geometryTopics.length, 36);

      final withFigures = geometryTopics.where((t) => t.figureType != null).toList();
      expect(withFigures.length >= 20, true, reason: 'At least 20 geometry topics must have explicit figureType');

      for (final topic in geometryTopics) {
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        expect(topic.tags.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Biology 8 topics are loaded (60 individual paragraphs § 1–60)', () {
      final biologyTopics = MockDatabase.getTopicsForGradeAndSubject(8, 'biology');
      expect(biologyTopics.length, 60);

      // Verify that specific paragraphs exist and can be found
      final p01 = biologyTopics.firstWhere((t) => t.title.startsWith('§ 1.'));
      expect(p01.title.contains('Зоология'), true);

      final p34 = biologyTopics.firstWhere((t) => t.title.startsWith('§ 34.'));
      expect(p34.title.isNotEmpty, true);

      final p60 = biologyTopics.firstWhere((t) => t.title.startsWith('§ 60.'));
      expect(p60.title.contains('агроэкосистемах'), true);

      for (final topic in biologyTopics) {
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        expect(topic.tags.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Literature 8 topics are loaded (12 comprehensive topics)', () {
      final literatureTopics = MockDatabase.getTopicsForGradeAndSubject(8, 'literature');
      expect(literatureTopics.length, 12);

      // Check key required literary works
      expect(literatureTopics.any((t) => t.title.contains('Недоросль')), true);
      expect(literatureTopics.any((t) => t.title.contains('Капитанская дочка')), true);
      expect(literatureTopics.any((t) => t.title.contains('Мцыри')), true);
      expect(literatureTopics.any((t) => t.title.contains('Ревизор')), true);
      expect(literatureTopics.any((t) => t.title.contains('Шинель')), true);

      for (final topic in literatureTopics) {
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        expect(topic.rules.isNotEmpty, true, reason: 'Literature topic ${topic.id} must have plot summary in rules');
        expect(topic.definitions.isNotEmpty, true, reason: 'Literature topic ${topic.id} must have character definitions');
        expect(topic.lifehacks.isNotEmpty, true, reason: 'Literature topic ${topic.id} must have analysis lifehacks');
      }
    });

    test('Physics 8 topics are loaded and rich', () {
      final physicsTopics = MockDatabase.getTopicsForGradeAndSubject(8, 'physics');
      expect(physicsTopics.length, 16);
    });

    test('Russian 8 topics are loaded and rich', () {
      final russianTopics = MockDatabase.getTopicsForGradeAndSubject(8, 'russian');
      expect(russianTopics.length, 13);
    });

    test('History 8 topics are loaded (29 individual paragraphs § 1–29)', () {
      final historyTopics = MockDatabase.getTopicsForGradeAndSubject(8, 'history');
      expect(historyTopics.length, 29);

      // Verify that specific paragraphs exist
      final p01 = historyTopics.firstWhere((t) => t.title.startsWith('§ 1.'));
      expect(p01.title.contains('Преображение Европы'), true);

      final p06 = historyTopics.firstWhere((t) => t.title.startsWith('§ 6.'));
      expect(p06.title.contains('Семилетняя война'), true);

      final p21 = historyTopics.firstWhere((t) => t.title.startsWith('§ 21.'));
      expect(p21.title.contains('Империя Наполеона'), true);

      final p28 = historyTopics.firstWhere((t) => t.title.startsWith('§ 28.'));
      expect(p28.title.contains('Латинская Америка'), true);

      final p29 = historyTopics.firstWhere((t) => t.title.startsWith('§ 29.'));
      expect(p29.title.contains('Африка'), true);

      for (final topic in historyTopics) {
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        expect(topic.tags.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Geography 8 topics are loaded (56 individual paragraphs § 1–56)', () {
      final geographyTopics = MockDatabase.getTopicsForGradeAndSubject(8, 'geography');
      expect(geographyTopics.length, 56);

      // Verify paragraph 34 exists as requested
      final p34 = geographyTopics.firstWhere((t) => t.title.startsWith('§ 34.'));
      expect(p34.title.contains('Падение и уклон реки') || p34.title.contains('Полярной звездой'), true);

      final p01 = geographyTopics.firstWhere((t) => t.title.startsWith('§ 1.'));
      expect(p01.title.contains('Как мы будем изучать географию'), true);

      final p56 = geographyTopics.firstWhere((t) => t.title.startsWith('§ 56.'));
      expect(p56.title.contains('Полярной звездой'), true);

      for (final topic in geographyTopics) {
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        expect(topic.tags.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Search topics finds keywords across all subjects', () {
      final discriminantResults = MockDatabase.searchTopics('дискриминант');
      expect(discriminantResults.isNotEmpty, true);

      final pythagorasResults = MockDatabase.searchTopics('Пифагор');
      expect(pythagorasResults.isNotEmpty, true);

      final biologyResults = MockDatabase.searchTopics('простейшие');
      expect(biologyResults.isNotEmpty, true);

      final literatureResults = MockDatabase.searchTopics('Хлестаков');
      expect(literatureResults.isNotEmpty, true);

      final grinevResults = MockDatabase.searchTopics('Гринёв');
      expect(grinevResults.isNotEmpty, true);
    });

    test('Informatics 8 topics are loaded (22 comprehensive topics across 5 chapters of Bosova textbook)', () {
      final infoTopics = MockDatabase.getTopicsForGradeAndSubject(8, 'informatics');
      expect(infoTopics.length, 22);

      // Chapter 1: Number systems
      expect(infoTopics.any((t) => t.title.startsWith('§ 1.1.') && t.title.toLowerCase().contains('системах счисления')), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 1.2.') && t.title.toLowerCase().contains('двоичная система')), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 1.3.') && t.title.toLowerCase().contains('родственные двоичной')), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 1.4.') && t.title.toLowerCase().contains('компьютере')), true);

      // Chapter 2: Boolean logic
      expect(infoTopics.any((t) => t.title.startsWith('§ 2.1.') && t.title.toLowerCase().contains('высказывания')), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 2.2.') && t.title.toLowerCase().contains('логические операции')), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 2.3.') && t.title.toLowerCase().contains('таблицы истинности')), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 2.4.') && t.title.toLowerCase().contains('логические элементы')), true);

      // Chapter 3: Algorithmics
      expect(infoTopics.any((t) => t.title.startsWith('§ 3.1.') && t.title.toLowerCase().contains('алгоритм')), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 3.4.') && t.title.toLowerCase().contains('линейные')), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 3.5.') && (t.title.toLowerCase().contains('ветвлен') || t.title.toLowerCase().contains('ветвящ'))), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 3.6.') && t.title.toLowerCase().contains('цикл')), true);

      // Chapter 4: Pascal
      expect(infoTopics.any((t) => t.title.startsWith('§ 4.1.') && t.title.toLowerCase().contains('паскаль')), true);

      // Chapter 5: Python
      expect(infoTopics.any((t) => t.title.startsWith('§ 5.1.') && t.title.toLowerCase().contains('python')), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 5.2.') && t.title.toLowerCase().contains('ввода и вывода')), true);
      expect(infoTopics.any((t) => t.title.startsWith('§ 5.5.') && t.title.toLowerCase().contains('циклическ') && t.title.toLowerCase().contains('python')), true);

      for (final topic in infoTopics) {
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        expect(topic.tags.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }

      // Verify search finds informatics concepts
      final searchPascal = MockDatabase.searchTopics('Паскаль', grade: 8);
      expect(searchPascal.isNotEmpty, true);

      final searchPython = MockDatabase.searchTopics('Python', grade: 8);
      expect(searchPython.isNotEmpty, true);

      final searchLogic = MockDatabase.searchTopics('дизъюнкция', grade: 8);
      expect(searchLogic.isNotEmpty, true);
    });
  });

  group('MockDatabase 7th & 9th Grade Extended Curricula Verification', () {
    test('Geometry 7 topics are loaded (45 individual paragraphs п. 1–45, Atanasyan)', () {
      final geom7 = MockDatabase.getTopicsForGradeAndSubject(7, 'geometry');
      expect(geom7.length, 45);

      final p1 = geom7.firstWhere((t) => t.id == 'geom_7_p01');
      expect(p1.title.contains('Точки, прямые, отрезки'), true);

      final p45 = geom7.firstWhere((t) => t.id == 'geom_7_p45');
      expect(p45.title.contains('Осевая симметрия'), true);

      for (final topic in geom7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'geometry');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Geometry 9 topics are loaded (54 individual paragraphs п. 84–137, Atanasyan)', () {
      final geom9 = MockDatabase.getTopicsForGradeAndSubject(9, 'geometry');
      expect(geom9.length, 54);

      final p84 = geom9.firstWhere((t) => t.id == 'geom_9_p84');
      expect(p84.title.contains('Понятие вектора'), true);

      final p137 = geom9.firstWhere((t) => t.id == 'geom_9_p137');
      expect(p137.title.contains('Применение подобия'), true);

      for (final topic in geom9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'geometry');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Physics 7 topics are loaded (68 individual paragraphs § 1–68, Peryshkin)', () {
      final phys7 = MockDatabase.getTopicsForGradeAndSubject(7, 'physics');
      expect(phys7.length, 68);

      final p1 = phys7.firstWhere((t) => t.id == 'phys_7_p01');
      expect(p1.title.contains('Что изучает физика'), true);

      final p68 = phys7.firstWhere((t) => t.id == 'phys_7_p68');
      expect(p68.title.contains('Превращение одного вида механической энергии'), true);

      for (final topic in phys7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'physics');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Russian 7 topics are loaded (56 individual paragraphs § 1–56, Baranov/Ladyzhenskaya)', () {
      final rus7 = MockDatabase.getTopicsForGradeAndSubject(7, 'russian');
      expect(rus7.length, 56);

      final p1 = rus7.firstWhere((t) => t.id == 'rus_7_p01');
      expect(p1.title.contains('Русский язык как развивающееся явление'), true);

      final p23 = rus7.firstWhere((t) => t.id == 'rus_7_p23');
      expect(p23.title.contains('Причастие'), true);

      final p39 = rus7.firstWhere((t) => t.id == 'rus_7_p39');
      expect(p39.title.contains('Деепричастие'), true);

      final p45 = rus7.firstWhere((t) => t.id == 'rus_7_p45');
      expect(p45.title.contains('Наречие'), true);

      final p56 = rus7.firstWhere((t) => t.id == 'rus_7_p56');
      expect(p56.title.contains('Мягкий знак'), true);

      for (final topic in rus7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'russian');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Cross-grade search works across new 7th and 9th grade topics', () {
      final searchArchimedes = MockDatabase.searchTopics('Архимед', grade: 7);
      expect(searchArchimedes.isNotEmpty, true);

      final searchParticiple = MockDatabase.searchTopics('причастие', grade: 7);
      expect(searchParticiple.isNotEmpty, true);

      final searchVector = MockDatabase.searchTopics('вектор', grade: 9);
      expect(searchVector.isNotEmpty, true);
    });

    test('Algebra 7 topics are loaded (46 individual paragraphs п. 1–46, Makarychev)', () {
      final alg7 = MockDatabase.getTopicsForGradeAndSubject(7, 'algebra');
      expect(alg7.length, 46);

      final p1 = alg7.firstWhere((t) => t.id == 'alg_7_p01');
      expect(p1.title.contains('Рациональные числа'), true);

      final p46 = alg7.firstWhere((t) => t.id == 'alg_7_p46');
      expect(p46.title.contains('Линейные неравенства'), true);

      for (final topic in alg7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'algebra');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Algebra 9 topics are loaded (31 individual paragraphs п. 1–31, Makarychev)', () {
      final alg9 = MockDatabase.getTopicsForGradeAndSubject(9, 'algebra');
      expect(alg9.length, 31);

      final p1 = alg9.firstWhere((t) => t.id == 'alg_9_p01');
      expect(p1.title.contains('Действия над действительными числами'), true);

      final p27 = alg9.firstWhere((t) => t.id == 'alg_9_p27');
      expect(p27.title.contains('арифметической прогрессии'), true);

      final p31 = alg9.firstWhere((t) => t.id == 'alg_9_p31');
      expect(p31.title.contains('математической индукции'), true);

      for (final topic in alg9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'algebra');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Informatics 7 topics are loaded (22 individual paragraphs § 1.1–5.2, Bosova)', () {
      final info7 = MockDatabase.getTopicsForGradeAndSubject(7, 'informatics');
      expect(info7.length, 22);

      final p1 = info7.firstWhere((t) => t.id == 'info_7_p1_1');
      expect(p1.title.contains('Информация и данные'), true);

      final p52 = info7.firstWhere((t) => t.id == 'info_7_p5_2');
      expect(p52.title.contains('Компьютерные презентации'), true);

      for (final topic in info7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'informatics');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Informatics 9 topics are loaded (18 individual paragraphs § 1.1–4.4, Bosova)', () {
      final info9 = MockDatabase.getTopicsForGradeAndSubject(9, 'informatics');
      expect(info9.length, 18);

      final p1 = info9.firstWhere((t) => t.id == 'info_9_p1_1');
      expect(p1.title.contains('Конструирование алгоритмов'), true);

      final p32 = info9.firstWhere((t) => t.id == 'info_9_p3_2');
      expect(p32.title.contains('электронных таблицах'), true);

      final p44 = info9.firstWhere((t) => t.id == 'info_9_p4_4');
      expect(p44.title.contains('Информационное общество'), true);

      for (final topic in info9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'informatics');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Probability & Statistics 7 topics are loaded (31 individual paragraphs п. 1–31, Vysotsky/Yashchenko)', () {
      final prob7 = MockDatabase.getTopicsForGradeAndSubject(7, 'probability');
      expect(prob7.length, 31);

      final p1 = prob7.firstWhere((t) => t.id == 'prob_7_p01');
      expect(p1.title.contains('Таблицы'), true);

      final p21 = prob7.firstWhere((t) => t.id == 'prob_7_p21');
      expect(p21.title.contains('мосты Кенигсберга'), true);

      final p31 = prob7.firstWhere((t) => t.id == 'prob_7_p31');
      expect(p31.title.contains('защита от ошибок'), true);

      for (final topic in prob7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'probability');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Literature 7 topics are loaded (24 comprehensive topics, Korovina Parts 1 & 2)', () {
      final lit7 = MockDatabase.getTopicsForGradeAndSubject(7, 'literature');
      expect(lit7.length, 24);

      final p2 = lit7.firstWhere((t) => t.id == 'lit_7_p02');
      expect(p2.title.contains('былины'), true);

      final p9 = lit7.firstWhere((t) => t.id == 'lit_7_p09');
      expect(p9.title.contains('Тарас Бульба'), true);

      final p24 = lit7.firstWhere((t) => t.id == 'lit_7_p24');
      expect(p24.title.contains('Сент-Экзюпери'), true);

      for (final topic in lit7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'literature');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('English 7 topics are loaded (10 comprehensive modules, Spotlight 7, Vaulina)', () {
      final eng7 = MockDatabase.getTopicsForGradeAndSubject(7, 'english');
      expect(eng7.length, 10);

      final m1 = eng7.firstWhere((t) => t.id == 'eng_7_mod01');
      expect(m1.title.contains('Module 1. Lifestyles'), true);

      final m6 = eng7.firstWhere((t) => t.id == 'eng_7_mod06');
      expect(m6.title.contains('Module 6. Having fun'), true);

      final m10 = eng7.firstWhere((t) => t.id == 'eng_7_mod10');
      expect(m10.title.contains('Module 10. Healthy body'), true);

      for (final topic in eng7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'english');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Probability 8 topics are loaded (14 individual paragraphs p. 32–45, Vysotsky)', () {
      final prob8 = MockDatabase.getTopicsForGradeAndSubject(8, 'probability');
      expect(prob8.length, 14);

      final p32 = prob8.firstWhere((t) => t.id == 'prob_8_p32');
      expect(p32.title.contains('Множество'), true);

      final p45 = prob8.firstWhere((t) => t.id == 'prob_8_p45');
      expect(p45.title.contains('Диаграммы рассеивания'), true);

      for (final topic in prob8) {
        expect(topic.grade, 8);
        expect(topic.subjectId, 'probability');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('English 8 topics are loaded (8 modules, Spotlight 8, Vaulina)', () {
      final eng8 = MockDatabase.getTopicsForGradeAndSubject(8, 'english');
      expect(eng8.length, 8);

      final m1 = eng8.firstWhere((t) => t.id == 'eng_8_mod01');
      expect(m1.title.contains('Module 1. Socialising'), true);

      final m8 = eng8.firstWhere((t) => t.id == 'eng_8_mod08');
      expect(m8.title.contains('Module 8. Pastimes'), true);

      for (final topic in eng8) {
        expect(topic.grade, 8);
        expect(topic.subjectId, 'english');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Biology 7 topics are loaded (26 individual paragraphs § 1–26, Pasechnik)', () {
      final bio7 = MockDatabase.getTopicsForGradeAndSubject(7, 'biology');
      expect(bio7.length, 26);

      final p1 = bio7.firstWhere((t) => t.id == 'bio_7_p01');
      expect(p1.title.contains('Многообразие организмов'), true);

      final p26 = bio7.firstWhere((t) => t.id == 'bio_7_p26');
      expect(p26.title.contains('Значение грибов и лишайников'), true);

      for (final topic in bio7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'biology');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('History 7 topics are loaded (21 topics covering § 1–23, Modern History XV–XVII c.)', () {
      final hist7 = MockDatabase.getTopicsForGradeAndSubject(7, 'history');
      expect(hist7.length, 21);

      final p1 = hist7.firstWhere((t) => t.id == 'hist_7_p01');
      expect(p1.title.contains('Мир на заре Нового времени'), true);

      final p23 = hist7.firstWhere((t) => t.id == 'hist_7_p23');
      expect(p23.title.contains('Африка'), true);

      for (final topic in hist7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'history');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Grade 9 physics topics are loaded (67 individual paragraphs § 1–67, Peryshkin)', () {
      final phys9 = MockDatabase.getTopicsForGradeAndSubject(9, 'physics');
      expect(phys9.length, 67);

      final p1 = phys9.firstWhere((t) => t.id == 'phys_9_p01');
      expect(p1.title.contains('Материальная точка'), true);

      final p67 = phys9.firstWhere((t) => t.id == 'phys_9_p67');
      expect(p67.title.contains('Термоядерная реакция'), true);

      for (final topic in phys9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'physics');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Grade 9 chemistry topics are loaded (41 individual paragraphs § 1–41, Rudzitis)', () {
      final chem9 = MockDatabase.getTopicsForGradeAndSubject(9, 'chemistry');
      expect(chem9.length, 41);

      final p1 = chem9.firstWhere((t) => t.id == 'chem_9_p01');
      expect(p1.title.contains('Классификация неорганических соединений'), true);

      final p41 = chem9.firstWhere((t) => t.id == 'chem_9_p41');
      expect(p41.title.contains('Качественные реакции на ионы'), true);

      for (final topic in chem9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'chemistry');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Grade 9 Russian topics are loaded (28 individual paragraphs § 1–28, Barkhudarov)', () {
      final rus9 = MockDatabase.getTopicsForGradeAndSubject(9, 'russian');
      expect(rus9.length, 28);

      final p1 = rus9.firstWhere((t) => t.id == 'rus_9_p01');
      expect(p1.title.contains('Понятие о сложном предложении'), true);

      final p28 = rus9.firstWhere((t) => t.id == 'rus_9_p28');
      expect(p28.title.contains('Русский литературный язык'), true);

      for (final topic in rus9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'russian');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.formulas.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.allExamples.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Grade 9 literature topics are loaded (29 individual topics, Korovina)', () {
      final lit9 = MockDatabase.getTopicsForGradeAndSubject(9, 'literature');
      expect(lit9.length, 29);

      final t1 = lit9.firstWhere((t) => t.id == 'lit_9_top01');
      expect(t1.title.contains('Древнерусская литература'), true);

      final t29 = lit9.firstWhere((t) => t.id == 'lit_9_top29');
      expect(t29.title.contains('Поэты пушкинской поры'), true);

      for (final topic in lit9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'literature');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Grade 9 biology topics are loaded (60 individual topics, Pasechnik)', () {
      final bio9 = MockDatabase.getTopicsForGradeAndSubject(9, 'biology');
      expect(bio9.length, 60);

      final t1 = bio9.firstWhere((t) => t.id == 'bio_9_top01');
      expect(t1.title.contains('Науки о человеке'), true);

      final t60 = bio9.firstWhere((t) => t.id == 'bio_9_top60');
      expect(t60.title.contains('Здоровье человека'), true);

      for (final topic in bio9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'biology');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Subjects english and probability are properly registered in MockDatabase.subjects', () {
      final subjects7 = MockDatabase.getSubjectsForGrade(7);
      expect(subjects7.any((s) => s.id == 'english'), true);
      expect(subjects7.any((s) => s.id == 'probability'), true);
      expect(subjects7.any((s) => s.id == 'algebra'), true);
      expect(subjects7.any((s) => s.id == 'geometry'), true);
      expect(subjects7.any((s) => s.id == 'physics'), true);
      expect(subjects7.any((s) => s.id == 'russian'), true);
      expect(subjects7.any((s) => s.id == 'literature'), true);
      expect(subjects7.any((s) => s.id == 'informatics'), true);
    });

    test('Grade 7 geography topics are loaded (58 topics, Alekseev)', () {
      final geo7 = MockDatabase.getTopicsForGradeAndSubject(7, 'geography');
      expect(geo7.length, 58);

      final t1 = geo7.firstWhere((t) => t.id == 'geo_7_p01');
      expect(t1.title.contains('Как вы будете изучать географию'), true);

      final t58 = geo7.firstWhere((t) => t.id == 'geo_7_p58');
      expect(t58.title.contains('Глобальные проблемы человечества'), true);

      for (final topic in geo7) {
        expect(topic.grade, 7);
        expect(topic.subjectId, 'geography');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Grade 9 geography topics are loaded (59 topics, Alekseev 2024)', () {
      final geo9 = MockDatabase.getTopicsForGradeAndSubject(9, 'geography');
      expect(geo9.length, 59);

      final t1 = geo9.firstWhere((t) => t.id == 'geo_9_p01');
      expect(t1.title.contains('Развитие хозяйства'), true);

      final t59 = geo9.firstWhere((t) => t.id == 'geo_9_p59');
      expect(t59.title.contains('Россия в мире'), true);

      for (final topic in geo9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'geography');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Grade 9 history topics are loaded (58 topics: 35 Russian history + 23 World history, Medinsky 2025)', () {
      final hist9 = MockDatabase.getTopicsForGradeAndSubject(9, 'history');
      expect(hist9.length, 58);

      final hist9Ru = hist9.where((t) => t.id.startsWith('hist_9_')).toList();
      expect(hist9Ru.length, 35);

      final hist9Wh = hist9.where((t) => t.id.startsWith('hist_wh_9_')).toList();
      expect(hist9Wh.length, 23);

      final t1 = hist9.firstWhere((t) => t.id == 'hist_9_p01');
      expect(t1.title.contains('Николая I'), true);

      final t37 = hist9.firstWhere((t) => t.id == 'hist_9_p37');
      expect(t37.title.contains('Серебряный век'), true);

      final wh1 = hist9.firstWhere((t) => t.id == 'hist_wh_9_p01');
      expect(wh1.title.contains('Экономика делает решающий рывок'), true);

      final wh23 = hist9.firstWhere((t) => t.id == 'hist_wh_9_p23');
      expect(wh23.title.contains('Латинская Америка'), true);

      for (final topic in hist9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'history');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty ||
            topic.lifehacks.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Grade 8 chemistry topics are loaded (39 topics § 1–39, Gabrielyan 2025)', () {
      final chem8 = MockDatabase.getTopicsForGradeAndSubject(8, 'chemistry');
      expect(chem8.length, 39);

      final p1 = chem8.firstWhere((t) => t.id == 'chem_8_p01');
      expect(p1.title.contains('Предмет химии'), true);

      final p39 = chem8.firstWhere((t) => t.id == 'chem_8_p39');
      expect(p39.title.contains('Окислительно-восстановительные реакции'), true);

      for (final topic in chem8) {
        expect(topic.grade, 8);
        expect(topic.subjectId, 'chemistry');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.formulas.isNotEmpty ||
            topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Grade 9 english topics are loaded (8 modules, Spotlight 9, Vaulina)', () {
      final eng9 = MockDatabase.getTopicsForGradeAndSubject(9, 'english');
      expect(eng9.length, 8);

      final m1 = eng9.firstWhere((t) => t.id == 'eng_9_mod01');
      expect(m1.title.contains('Celebrations'), true);

      final m8 = eng9.firstWhere((t) => t.id == 'eng_9_mod08');
      expect(m8.title.contains('Challenges'), true);

      for (final topic in eng9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'english');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.formulas.isNotEmpty ||
            topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });

    test('Grade 9 probability topics are loaded (20 topics, Vysotsky-Yashchenko)', () {
      final prob9 = MockDatabase.getTopicsForGradeAndSubject(9, 'probability');
      expect(prob9.length, 20);

      final t46 = prob9.firstWhere((t) => t.id == 'prob_9_p46');
      expect(t46.title.contains('Графы и деревья'), true);

      final t65 = prob9.firstWhere((t) => t.id == 'prob_9_p65');
      expect(t65.title.contains('Дисперсия'), true);

      for (final topic in prob9) {
        expect(topic.grade, 9);
        expect(topic.subjectId, 'probability');
        expect(topic.title.isNotEmpty, true);
        expect(topic.shortSummary.isNotEmpty, true);
        final hasContent = topic.formulas.isNotEmpty ||
            topic.definitions.isNotEmpty ||
            topic.rules.isNotEmpty;
        expect(hasContent, true, reason: 'Topic ${topic.id} has no rich content');
      }
    });
  });
}
