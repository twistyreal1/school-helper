# -*- coding: utf-8 -*-
import sys

with open('lib/data/mock_database.dart', 'r', encoding='utf-8') as f:
    text = f.read()

import_target = "import 'history_topics_7.dart';"
imports_to_add = """import 'history_topics_7.dart';
import 'physics_topics_9.dart';
import 'chemistry_topics_9.dart';
import 'russian_topics_9.dart';
import 'literature_topics_9.dart';
import 'biology_topics_9.dart';"""

if import_target in text:
    text = text.replace(import_target, imports_to_add, 1)
    print("Added imports to mock_database.dart")
else:
    print("import_target not found!")

spread_target = "...historyTopics7,"
spreads_to_add = """...historyTopics7,

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
    ...biologyTopics9,"""

if spread_target in text:
    text = text.replace(spread_target, spreads_to_add, 1)
    print("Added spreads to mock_database.dart")
else:
    print("spread_target not found!")

with open('lib/data/mock_database.dart', 'w', encoding='utf-8', newline='\n') as f:
    f.write(text)

print("Done updating lib/data/mock_database.dart")
