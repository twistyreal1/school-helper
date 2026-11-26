# -*- coding: utf-8 -*-
with open('test/topics_test.dart', 'r', encoding='utf-8') as f:
    text = f.read()

target = """    test('Subjects english and probability are properly registered in MockDatabase.subjects', () {"""

new_tests = """    test('Probability 8 topics are loaded (14 individual paragraphs p. 32–45, Vysotsky)', () {
      final prob8 = MockDatabase.getTopicsForGradeAndSubject(8, 'probability');
      expect(prob8.length, 14);

      final p32 = prob8.firstWhere((t) => t.id == 'prob_8_p32');
      expect(p32.title.contains('Случайная изменчивость'), true);

      final p45 = prob8.firstWhere((t) => t.id == 'prob_8_p45');
      expect(p45.title.contains('Правило умножения вероятностей'), true);

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
      expect(m1.title.contains('Module 1. Communication'), true);

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
      expect(p1.title.contains('Водоросли'), true);

      final p26 = bio7.firstWhere((t) => t.id == 'bio_7_p26');
      expect(p26.title.contains('Лишайники'), true);

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
      expect(p23.title.contains('Государства Востока'), true);

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

    test('Subjects english and probability are properly registered in MockDatabase.subjects', () {"""

if '\r\n' in text:
    new_tests = new_tests.replace('\n', '\r\n')

assert target in text, 'target not found'
text = text.replace(target, new_tests, 1)

with open('test/topics_test.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print('Updated test/topics_test.dart successfully!')
