# -*- coding: utf-8 -*-
import os
import sys

# Add working directory to sys.path
sys.path.append(os.path.abspath('.'))

from scratch.builders.rus9_part1 import topics_p1
from scratch.builders.rus9_part2 import topics_p2
from scratch.builders.dart_utils import write_topics_file

topics = topics_p1 + topics_p2

print(f"Total topics loaded: {len(topics)}")

# Verification against scratch/rus_paragraphs.txt
with open('scratch/rus_paragraphs.txt', 'r', encoding='utf-8') as f:
    expected_paragraphs = [line.strip() for line in f if line.strip()]

assert len(expected_paragraphs) == 28, f"Expected 28 paragraphs in txt, got {len(expected_paragraphs)}"
assert len(topics) == 28, f"Expected 28 topics, got {len(topics)}"

for idx, (t, exp_title) in enumerate(zip(topics, expected_paragraphs)):
    expected_id = f"rus_9_p{idx+1:02d}"
    assert t['id'] == expected_id, f"Topic {idx+1} id mismatch: expected {expected_id}, got {t['id']}"
    assert t['title'] == exp_title, f"Topic {idx+1} title mismatch:\nExpected: {exp_title}\nGot:      {t['title']}"
    assert t['subjectId'] == 'russian', f"Topic {idx+1} invalid subjectId"
    assert t['grade'] == 9, f"Topic {idx+1} invalid grade"
    assert len(t['shortSummary']) > 20, f"Topic {idx+1} summary too short"
    assert len(t['definitions']) >= 1, f"Topic {idx+1} definitions empty"
    assert len(t['rules']) >= 2, f"Topic {idx+1} rules too few"
    assert len(t['lifehacks']) >= 1, f"Topic {idx+1} lifehacks empty"
    assert len(t['examples']) >= 1, f"Topic {idx+1} examples empty"
    assert len(t['tags']) >= 3, f"Topic {idx+1} tags too few"

print("All 28 topics verified against requirements!")

comment = (
    "Полный курс русского языка 9 класса по официальному школьному учебнику\n"
    "С. Г. Бархударова, С. Е. Крючкова, Л. Ю. Максимова, Л. А. Чешко (Просвещение).\n"
    "Все 28 параграфов программы 9 класса (§ 1 – § 28): синтаксис и пунктуация сложного предложения\n"
    "(ССП, СПП, БСП, сложные конструкции с разными видами связи), прямая и косвенная речь, цитирование\n"
    "и функциональные стили речи. Включает синтаксические схемы, правила, ловушки ОГЭ и практические примеры."
)

output_path = os.path.join('lib', 'data', 'russian_topics_9.dart')
write_topics_file(output_path, 'russianTopics9', comment, topics)
print(f"Successfully generated {output_path}")
