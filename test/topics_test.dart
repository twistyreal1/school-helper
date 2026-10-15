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
}
