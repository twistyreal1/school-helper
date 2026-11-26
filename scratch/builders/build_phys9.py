# -*- coding: utf-8 -*-
"""
Script to build lib/data/physics_topics_9.dart from 5 data parts.
"""
import sys
import os

# Add scratch/builders to sys.path
sys.path.append(os.path.abspath('scratch/builders'))

from data_phys9_part1 import part1_topics
from data_phys9_part2 import part2_topics
from data_phys9_part3 import part3_topics
from data_phys9_part4 import part4_topics
from data_phys9_part5 import part5_topics
from dart_utils import write_topics_file

all_topics = part1_topics + part2_topics + part3_topics + part4_topics + part5_topics

for t in all_topics:
    t['subjectId'] = 'physics'
    t['grade'] = 9

print(f"Loaded {len(all_topics)} topics.")

# Validation
assert len(all_topics) == 67, f"Expected 67 topics, got {len(all_topics)}"

for i, t in enumerate(all_topics, start=1):
    expected_id = f"phys_9_p{i:02d}"
    assert t['id'] == expected_id, f"Topic {i}: expected ID {expected_id}, got {t['id']}"
    assert t['title'].startswith(f"§ {i}."), f"Topic {i}: title doesn't start with '§ {i}.': {t['title']}"
    assert t.get('subjectId') == 'physics', f"Topic {i}: subjectId != 'physics'"
    assert t.get('grade') == 9, f"Topic {i}: grade != 9"
    assert t.get('shortSummary'), f"Topic {i}: shortSummary is empty"
    assert isinstance(t.get('formulas'), list), f"Topic {i}: formulas is not list"
    assert isinstance(t.get('definitions'), list), f"Topic {i}: definitions is not list"
    assert isinstance(t.get('rules'), list), f"Topic {i}: rules is not list"
    assert isinstance(t.get('lifehacks'), list), f"Topic {i}: lifehacks is not list"
    assert isinstance(t.get('examples'), list), f"Topic {i}: examples is not list"
    assert isinstance(t.get('tags'), list), f"Topic {i}: tags is not list"

print("All 67 topics validated successfully!")

# Ensure target directory exists
target_file = os.path.abspath('lib/data/physics_topics_9.dart')
var_name = 'physicsTopics9'
comment = """Полный курс физики 9 класса по официальному школьному учебнику
А. В. Пёрышкина, Е. М. Гутник (Просвещение).
Все 67 параграфов программы 9 класса (§ 1 – § 67) вынесены в отдельные самостоятельные темы
без объединения: формулы, определения, правила, лайфхаки и расчетные примеры."""

write_topics_file(target_file, var_name, comment, all_topics)
print(f"Generated {target_file} with {len(all_topics)} topics.")
