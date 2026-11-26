# -*- coding: utf-8 -*-
import sys
import os

sys.path.append(os.path.abspath('.'))

from scratch.builders.dart_utils import write_topics_file
from scratch.builders.chem9_part1 import topics_part1
from scratch.builders.chem9_part2 import topics_part2
from scratch.builders.chem9_part3 import topics_part3
from scratch.builders.chem9_part4 import topics_part4

all_topics = topics_part1 + topics_part2 + topics_part3 + topics_part4

print(f"Total topics loaded: {len(all_topics)}")
assert len(all_topics) == 41, f"Expected 41 topics, got {len(all_topics)}"

# Check titles against chem_paragraphs.txt
with open('scratch/chem_paragraphs.txt', 'r', encoding='utf-8') as f:
    expected_titles = [line.strip() for line in f if line.strip()]

assert len(expected_titles) == 41, f"Expected 41 lines in chem_paragraphs.txt, got {len(expected_titles)}"

for i, (t, exp_title) in enumerate(zip(all_topics, expected_titles), start=1):
    expected_id = f"chem_9_p{i:02d}"
    assert t['id'] == expected_id, f"Topic {i} ID mismatch: {t['id']} vs {expected_id}"
    assert t['title'] == exp_title, f"Topic {i} Title mismatch: {t['title']} vs {exp_title}"
    assert t['subjectId'] == 'chemistry', f"Topic {i} subjectId mismatch: {t['subjectId']}"
    assert t['grade'] == 9, f"Topic {i} grade mismatch: {t['grade']}"
    assert len(t['shortSummary']) > 20, f"Topic {i} shortSummary too short"
    assert len(t['formulas']) >= 1, f"Topic {i} has no formulas"
    assert len(t['definitions']) >= 1, f"Topic {i} has no definitions"
    assert len(t['rules']) >= 1, f"Topic {i} has no rules"
    assert len(t['lifehacks']) >= 1, f"Topic {i} has no lifehacks"
    assert len(t['examples']) >= 1, f"Topic {i} has no examples"
    assert len(t['tags']) >= 1, f"Topic {i} has no tags"

print("All 41 topics validated successfully against requirements and chem_paragraphs.txt!")

comment = """Полный курс химии 9 класса по официальному школьному учебнику
Г. Е. Рудзитиса и Ф. Г. Фельдмана (Просвещение).
Все 41 параграф программы 9 класса (§ 1 – § 41) вынесены в отдельные самостоятельные темы
без объединения: уравнения реакций, определения, химические закономерности,
лайфхаки, качественные реакции и расчетные примеры."""

out_path = 'lib/data/chemistry_topics_9.dart'
write_topics_file(out_path, 'chemistryTopics9', comment, all_topics)
print(f"Generated {out_path} with 41 topics!")
