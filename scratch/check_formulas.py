# -*- coding: utf-8 -*-
import os, re, sys

sys.stdout.reconfigure(encoding='utf-8')

formulas = []
for root, dirs, files in os.walk('lib/data'):
    for f in files:
        if f.endswith('.dart'):
            with open(os.path.join(root, f), 'r', encoding='utf-8') as fl:
                c = fl.read()
                matches = re.findall(r'formula:\s*([\'"].*?[\'"])', c)
                for m in matches:
                    formulas.append((f, m))

print(f'Total formulas: {len(formulas)}')
latex_formulas = [item for item in formulas if '\\' in item[1] or '/' in item[1] or '^' in item[1] or '_' in item[1]]
print(f'Latex/math formulas: {len(latex_formulas)}')
for file, f in latex_formulas[:25]:
    print(f'{file:25}: {f[:75]}')
