# -*- coding: utf-8 -*-
with open('lib/screens/topic_detail_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

target = """            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: MathFormulaWidget("""

replacement = """            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.22),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: MathFormulaWidget("""

if '\r\n' in text:
    target = target.replace('\n', '\r\n')
    replacement = replacement.replace('\n', '\r\n')

assert target in text, 'target not found'
text = text.replace(target, replacement, 1)

with open('lib/screens/topic_detail_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print('Updated lib/screens/topic_detail_screen.dart successfully!')
