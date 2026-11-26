# -*- coding: utf-8 -*-
import re

with open('lib/data/physics_topics_9.dart', encoding='utf-8') as f:
    content = f.read()

topic_matches = re.findall(r'Topic\(', content)
id_matches = re.findall(r"id: '(phys_9_p\d{2})'", content)
title_matches = re.findall(r"title: '(§ \d+\. [^']+)'", content)

print(f'Topic count: {len(topic_matches)}')
print(f'ID count: {len(id_matches)}')
print(f'Title count: {len(title_matches)}')

assert len(topic_matches) == 67
assert len(id_matches) == 67
assert len(title_matches) == 67
assert id_matches[0] == 'phys_9_p01'
assert id_matches[-1] == 'phys_9_p67'

for i, (tid, title) in enumerate(zip(id_matches, title_matches), start=1):
    expected_id = f"phys_9_p{i:02d}"
    expected_prefix = f"§ {i}."
    assert tid == expected_id, f"Index {i}: {tid} != {expected_id}"
    assert title.startswith(expected_prefix), f"Index {i}: {title} does not start with {expected_prefix}"

print(f"Verified all 67 topics: {id_matches[0]} ({title_matches[0]}) ... {id_matches[-1]} ({title_matches[-1]})")
print("Verification SUCCESSFUL!")
