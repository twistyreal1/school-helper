# -*- coding: utf-8 -*-

with open('test/topics_test.dart', 'r', encoding='utf-8') as f:
    text = f.read()

target = """    test('Subjects english and probability are properly registered in MockDatabase.subjects', () {"""

tests_to_insert = """    test('Grade 9 physics topics are loaded (67 individual paragraphs § 1–67, Peryshkin)', () {
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

    test('Subjects english and probability are properly registered in MockDatabase.subjects', () {"""

assert target in text, 'target test not found'
text = text.replace(target, tests_to_insert, 1)

with open('test/topics_test.dart', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print('Updated test/topics_test.dart successfully')
