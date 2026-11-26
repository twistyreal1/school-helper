# -*- coding: utf-8 -*-
import sys
sys.path.append('scratch')
from data_geom9_ch10 import geom9_ch10
from data_geom9_ch11 import geom9_ch11
from data_geom9_ch12 import geom9_ch12
from data_geom9_ch13 import geom9_ch13
from data_geom9_ch14 import geom9_ch14
from data_geom9_ch15 import geom9_ch15
from build_helpers import escape_dart

all_topics = geom9_ch10 + geom9_ch11 + geom9_ch12 + geom9_ch13 + geom9_ch14 + geom9_ch15
print(f'Total Geometry 9 topics: {len(all_topics)}')

out = '''import '../models/topic_model.dart';

/// Полный курс геометрии 9 класса по официальному учебнику
/// Л. С. Атанасяна, В. Ф. Бутузова, С. Б. Кадомцева и др. (Просвещение).
/// Все 54 пункта программы 9 класса (п. 84 – п. 137) вынесены в отдельные самостоятельные темы
/// без объединения, с формулами, теоремами, определениями и практическими примерами.
const List<Topic> geometryTopics9 = [
'''

def format_topic_grade9(t):
    lines = []
    lines.append('  Topic(')
    lines.append(f"    id: '{t['id']}',")
    lines.append(f"    title: {escape_dart(t['title'])},")
    lines.append("    subjectId: 'geometry',")
    lines.append("    grade: 9,")
    lines.append(f"    shortSummary: {escape_dart(t['shortSummary'])},")
    
    # formulas
    if t.get('formulas'):
        lines.append('    formulas: [')
        for f in t['formulas']:
            lines.append('      FormulaItem(')
            lines.append(f"        title: {escape_dart(f['title'])},")
            lines.append(f"        formula: {escape_dart(f['formula'])},")
            if f.get('desc'):
                lines.append(f"        description: {escape_dart(f['desc'])},")
            lines.append('      ),')
        lines.append('    ],')
    else:
        lines.append('    formulas: const [],')
        
    # definitions
    if t.get('definitions'):
        lines.append('    definitions: [')
        for term, d in t['definitions']:
            lines.append('      DefinitionItem(')
            lines.append(f"        term: {escape_dart(term)},")
            lines.append(f"        definition: {escape_dart(d)},")
            lines.append('      ),')
        lines.append('    ],')
    else:
        lines.append('    definitions: const [],')
        
    # rules
    if t.get('rules'):
        lines.append('    rules: [')
        for r in t['rules']:
            lines.append(f"      {escape_dart(r)},")
        lines.append('    ],')
    else:
        lines.append('    rules: const [],')
        
    # lifehacks
    if t.get('lifehacks'):
        lines.append('    lifehacks: [')
        for lh in t['lifehacks']:
            lines.append(f"      {escape_dart(lh)},")
        lines.append('    ],')
    else:
        lines.append('    lifehacks: const [],')
        
    # examples
    if t.get('examples'):
        lines.append('    examples: [')
        for ex in t['examples']:
            lines.append('      ExampleItem(')
            lines.append(f"        task: {escape_dart(ex['task'])},")
            lines.append('        steps: [')
            for step in ex['steps']:
                lines.append(f"          {escape_dart(step)},")
            lines.append('        ],')
            lines.append(f"        answer: {escape_dart(ex['answer'])},")
            lines.append('      ),')
        lines.append('    ],')
    else:
        lines.append('    examples: const [],')
        
    # tags
    if t.get('tags'):
        lines.append('    tags: [')
        for tg in t['tags']:
            lines.append(f"      {escape_dart(tg)},")
        lines.append('    ],')
    else:
        lines.append('    tags: const [],')
        
    lines.append('  ),')
    return '\n'.join(lines)

for t in all_topics:
    out += format_topic_grade9(t) + '\n\n'

out += '];\n'

with open('lib/data/geometry_topics_9.dart', 'w', encoding='utf-8') as f:
    f.write(out)

print('Successfully generated lib/data/geometry_topics_9.dart!')
