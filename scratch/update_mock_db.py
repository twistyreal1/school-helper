# -*- coding: utf-8 -*-
with open('lib/data/mock_database.dart', 'r', encoding='utf-8') as f:
    text = f.read()

import_target = "import 'english_topics_7.dart';"
import_replacement = """import 'english_topics_7.dart';
import 'probability_topics_8.dart';
import 'english_topics_8.dart';
import 'biology_topics_7.dart';
import 'history_topics_7.dart';"""

if '\r\n' in text:
    import_replacement = import_replacement.replace('\n', '\r\n')

assert import_target in text, 'import_target not found'
text = text.replace(import_target, import_replacement, 1)

topic_target = "    ...englishTopics7,\n  ];"
topic_replacement = """    ...englishTopics7,

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
  ];"""

if '\r\n' in text:
    topic_target = topic_target.replace('\n', '\r\n')
    topic_replacement = topic_replacement.replace('\n', '\r\n')

assert topic_target in text, 'topic_target not found'
text = text.replace(topic_target, topic_replacement, 1)

with open('lib/data/mock_database.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print('Updated lib/data/mock_database.dart successfully!')
