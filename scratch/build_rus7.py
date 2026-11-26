# -*- coding: utf-8 -*-
import sys
sys.path.append('scratch')
from data_rus7_intro import rus7_intro
from data_rus7_speech import rus7_speech
from data_rus7_participle import rus7_participle
from data_rus7_transgressive import rus7_transgressive
from data_rus7_adverb import rus7_adverb
from build_helpers import escape_dart

all_topics = rus7_intro + rus7_speech + rus7_participle + rus7_transgressive + rus7_adverb
print(f'Total Russian 7 topics: {len(all_topics)}')

out = '''import '../models/topic_model.dart';

/// Полный курс русского языка 7 класса по официальному школьному учебнику
/// М. Т. Баранова, Т. А. Ладыженской, Л. А. Тростенцовой и др. (Просвещение).
/// Все 56 параграфов программы 7 класса (§ 1 – § 56) представлены отдельными
/// самостоятельными темами: схемы, орфографические правила, морфологический анализ,
/// алгоритмы, мнемонические лайфхаки и примеры языкового анализа.
const List<Topic> russianTopics7 = [
'''

def format_topic_rus7(t):
    lines = []
    lines.append('  Topic(')
    lines.append(f"    id: '{t['id']}',")
    lines.append(f"    title: {escape_dart(t['title'])},")
    lines.append("    subjectId: 'russian',")
    lines.append("    grade: 7,")
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
    out += format_topic_rus7(t) + '\n'

out += '];\n'

with open('lib/data/russian_topics_7.dart', 'w', encoding='utf-8') as f:
    f.write(out)

print('Generated lib/data/russian_topics_7.dart successfully!')
