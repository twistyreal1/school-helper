# -*- coding: utf-8 -*-

def dart_escape(s):
    if s is None:
        return ''
    return s.replace('\\', '\\\\').replace("'", "\\'").replace('\n', '\\n').replace('\r', '')

def format_topic(t):
    lines = ['  Topic(']
    lines.append("    id: '" + dart_escape(t['id']) + "',")
    lines.append("    title: '" + dart_escape(t['title']) + "',")
    lines.append("    subjectId: '" + dart_escape(t['subjectId']) + "',")
    lines.append("    grade: " + str(t['grade']) + ",")
    lines.append("    shortSummary: '" + dart_escape(t['shortSummary']) + "',")
    
    # figureType
    if t.get('figureType'):
        lines.append("    figureType: '" + dart_escape(t['figureType']) + "',")
    
    # formulas
    formulas = t.get('formulas', [])
    if not formulas:
        lines.append('    formulas: [],')
    else:
        lines.append('    formulas: [')
        for f in formulas:
            lines.append('      FormulaItem(')
            lines.append("        title: '" + dart_escape(f['title']) + "',")
            lines.append("        formula: '" + dart_escape(f['formula']) + "',")
            lines.append("        description: '" + dart_escape(f['description']) + "',")
            variables = f.get('variables', {})
            if variables:
                lines.append('        variables: {')
                for k, v in variables.items():
                    lines.append("          '" + dart_escape(k) + "': '" + dart_escape(v) + "',")
                lines.append('        },')
            lines.append('      ),')
        lines.append('    ],')
        
    # definitions
    defs = t.get('definitions', [])
    if not defs:
        lines.append('    definitions: [],')
    else:
        lines.append('    definitions: [')
        for d in defs:
            lines.append('      DefinitionItem(')
            lines.append("        term: '" + dart_escape(d['term']) + "',")
            lines.append("        definition: '" + dart_escape(d['definition']) + "',")
            lines.append('      ),')
        lines.append('    ],')
        
    # rules
    rules = t.get('rules', [])
    lines.append('    rules: [')
    for r in rules:
        lines.append("      '" + dart_escape(r) + "',")
    lines.append('    ],')
    
    # lifehacks
    hacks = t.get('lifehacks', [])
    lines.append('    lifehacks: [')
    for h in hacks:
        lines.append("      '" + dart_escape(h) + "',")
    lines.append('    ],')
    
    # examples
    examples = t.get('examples', [])
    if not examples:
        lines.append('    examples: [],')
    else:
        lines.append('    examples: [')
        for ex in examples:
            lines.append('      ExampleItem(')
            lines.append("        task: '" + dart_escape(ex['task']) + "',")
            steps = ex.get('steps', [])
            lines.append('        steps: [')
            for st in steps:
                lines.append("          '" + dart_escape(st) + "',")
            lines.append('        ],')
            lines.append("        answer: '" + dart_escape(ex['answer']) + "',")
            lines.append('      ),')
        lines.append('    ],')
        
    # tags
    tags = t.get('tags', [])
    lines.append('    tags: [')
    for tag in tags:
        lines.append("      '" + dart_escape(tag) + "',")
    lines.append('    ],')
    
    lines.append('  ),')
    return '\n'.join(lines)

def write_topics_file(path, var_name, comment, topics):
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write("import '../models/topic_model.dart';\n\n")
        f.write("/// " + comment.replace('\n', '\n/// ') + "\n")
        f.write("const List<Topic> " + var_name + " = [\n")
        for i, t in enumerate(topics):
            f.write(format_topic(t))
            f.write("\n\n")
        f.write("];\n")
    print(f"Written {len(topics)} topics to {path}")
