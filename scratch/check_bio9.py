# -*- coding: utf-8 -*-
import sys, os
sys.path.append(os.path.abspath('.'))

with open('scratch/bio_topics.txt', 'r', encoding='utf-8') as f:
    lines = [line.strip() for line in f if line.strip()]

from scratch.builders.build_bio9 import all_topics

assert len(lines) == 60, f'Expected 60 lines in bio_topics.txt, got {len(lines)}'
assert len(all_topics) == 60, f'Expected 60 topics, got {len(all_topics)}'

for i, (line, t) in enumerate(zip(lines, all_topics), 1):
    num_str, name = line.split(':', 1)
    expected_title = f'§ {num_str.strip()}. {name.strip()}'
    assert t['id'] == f'bio_9_top{i:02d}', f'Topic {i} ID mismatch: {t["id"]}'
    assert t['title'] == expected_title, f'Topic {i} title mismatch: "{t["title"]}" vs "{expected_title}"'
    assert t['subjectId'] == 'biology'
    assert t['grade'] == 9
    assert len(t['shortSummary']) > 20
    assert len(t['definitions']) >= 2
    assert len(t['rules']) >= 2
    assert len(t['lifehacks']) >= 1
    assert len(t['examples']) >= 1
    assert len(t['tags']) >= 4
    for ex in t['examples']:
        assert len(ex['task']) > 5
        assert len(ex['steps']) >= 2
        assert len(ex['answer']) > 5

print('All 60 topics passed all consistency checks perfectly!')
