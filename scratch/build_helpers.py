# -*- coding: utf-8 -*-
"""
Builder for geometry_topics_7.dart with all 45 topics according to Atanasyan 7-9.
"""
import json

def escape_dart(s):
    if s is None:
        return 'null'
    # Escape backslashes, single quotes, dollar signs, and newlines for Dart string literal
    res = s.replace('\\', '\\\\').replace("'", "\\'").replace('$', '\\$').replace('\r', '').replace('\n', '\\n')
    return f"'{res}'"

def format_topic(t):
    lines = []
    lines.append("  Topic(")
    lines.append(f"    id: '{t['id']}',")
    lines.append(f"    title: {escape_dart(t['title'])},")
    lines.append(f"    subjectId: 'geometry',")
    lines.append(f"    grade: 7,")
    lines.append(f"    shortSummary: {escape_dart(t['shortSummary'])},")
    
    # formulas
    if t.get('formulas'):
        lines.append("    formulas: [")
        for f in t['formulas']:
            lines.append("      FormulaItem(")
            lines.append(f"        title: {escape_dart(f['title'])},")
            lines.append(f"        formula: {escape_dart(f['formula'])},")
            if f.get('desc'):
                lines.append(f"        description: {escape_dart(f['desc'])},")
            if f.get('vars'):
                lines.append("        variables: {")
                for k, v in f['vars'].items():
                    lines.append(f"          {escape_dart(k)}: {escape_dart(v)},")
                lines.append("        },")
            lines.append("      ),")
        lines.append("    ],")
    else:
        lines.append("    formulas: const [],")
        
    # definitions
    if t.get('definitions'):
        lines.append("    definitions: [")
        for term, d in t['definitions']:
            lines.append("      DefinitionItem(")
            lines.append(f"        term: {escape_dart(term)},")
            lines.append(f"        definition: {escape_dart(d)},")
            lines.append("      ),")
        lines.append("    ],")
    else:
        lines.append("    definitions: const [],")
        
    # rules
    if t.get('rules'):
        lines.append("    rules: [")
        for r in t['rules']:
            lines.append(f"      {escape_dart(r)},")
        lines.append("    ],")
    else:
        lines.append("    rules: const [],")
        
    # lifehacks
    if t.get('lifehacks'):
        lines.append("    lifehacks: [")
        for lh in t['lifehacks']:
            lines.append(f"      {escape_dart(lh)},")
        lines.append("    ],")
    else:
        lines.append("    lifehacks: const [],")
        
    # examples
    if t.get('examples'):
        lines.append("    examples: [")
        for ex in t['examples']:
            lines.append("      ExampleItem(")
            lines.append(f"        task: {escape_dart(ex['task'])},")
            lines.append("        steps: [")
            for step in ex['steps']:
                lines.append(f"          {escape_dart(step)},")
            lines.append("        ],")
            lines.append(f"        answer: {escape_dart(ex['answer'])},")
            lines.append("      ),")
        lines.append("    ],")
    else:
        lines.append("    examples: const [],")
        
    # tags
    if t.get('tags'):
        lines.append("    tags: [")
        for tg in t['tags']:
            lines.append(f"      {escape_dart(tg)},")
        lines.append("    ],")
    else:
        lines.append("    tags: const [],")
        
    lines.append("  ),")
    return "\n".join(lines)

print("Helper defined.")
