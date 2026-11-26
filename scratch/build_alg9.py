# -*- coding: utf-8 -*-
import sys
sys.path.append('scratch')
from data_alg9_ch1_3 import alg9_ch1_3
from data_alg9_ch4_5 import alg9_ch4_5
from build_helpers import escape_dart

all_topics = alg9_ch1_3 + alg9_ch4_5
print(f'Total Algebra 9 topics: {len(all_topics)}')

out = '''import '../models/topic_model.dart';

/// Полный курс алгебры 9 класса по официальному школьному учебнику
/// Ю. Н. Макарычева, Н. Г. Миндюк, К. И. Нешкова, С. Б. Суворовой
/// под редакцией С. А. Теляковского (Просвещение, 2023 г.).
/// Все 31 пункт программы 9 класса (п. 1 – п. 31) вынесены в отдельные самостоятельные темы
/// без объединения: формулы, определения, правила, лайфхаки и расчетные примеры.
const List<Topic> algebraTopics9 = [
'''

def format_topic_alg9(t):
    lines = []
    lines.append('  Topic(')
    lines.append(f"    id: '{t['id']}',")
    lines.append(f"    title: {escape_dart(t['title'])},")
    lines.append("    subjectId: 'algebra',")
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
        lines.append('    formulas: [],')
        
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
        lines.append('    definitions: [],')
        
    # rules
    if t.get('rules'):
        lines.append('    rules: [')
        for r in t['rules']:
            lines.append(f"      {escape_dart(r)},")
        lines.append('    ],')
    else:
        lines.append('    rules: [],')
        
    # lifehacks
    if t.get('lifehacks'):
        lines.append('    lifehacks: [')
        for lh in t['lifehacks']:
            lines.append(f"      {escape_dart(lh)},")
        lines.append('    ],')
    else:
        lines.append('    lifehacks: [],')
        
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
        lines.append('    examples: [],')
        
    # tags
    if t.get('tags'):
        lines.append('    tags: [')
        for tg in t['tags']:
            lines.append(f"      {escape_dart(tg)},")
        lines.append('    ],')
    else:
        lines.append('    tags: [],')
        
    lines.append('  ),')
    return '\n'.join(lines)

for t in all_topics:
    out += format_topic_alg9(t) + '\n\n'

out += '];\n'

with open('lib/data/algebra_topics_9.dart', 'w', encoding='utf-8') as f:
    f.write(out)

print('Successfully generated lib/data/algebra_topics_9.dart!')
