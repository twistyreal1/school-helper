# -*- coding: utf-8 -*-
import sys
import os
sys.path.append(os.path.abspath('.'))
from scratch.builders.dart_utils import write_topics_file

topics = []

def add_t(id, title, summary, formulas, defs, rules, hacks, examples, tags):
    topics.append({
        'id': id,
        'title': title,
        'subjectId': 'physics',
        'grade': 9,
        'shortSummary': summary,
        'formulas': formulas,
        'definitions': defs,
        'rules': rules,
        'lifehacks': hacks,
        'examples': examples,
        'tags': tags,
    })

print('Building phys 9 topics...')
