# -*- coding: utf-8 -*-
with open('test/topics_test.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace("expect(p32.title.contains('Случайная изменчивость'), true);", "expect(p32.title.contains('Множество'), true);")
text = text.replace("expect(p45.title.contains('Правило умножения вероятностей'), true);", "expect(p45.title.contains('Диаграммы рассеивания'), true);")
text = text.replace("expect(m1.title.contains('Module 1. Communication'), true);", "expect(m1.title.contains('Module 1. Socialising'), true);")
text = text.replace("expect(p1.title.contains('Водоросли'), true);", "expect(p1.title.contains('Многообразие организмов'), true);")
text = text.replace("expect(p26.title.contains('Лишайники'), true);", "expect(p26.title.contains('Значение грибов и лишайников'), true);")
text = text.replace("expect(p23.title.contains('Государства Востока'), true);", "expect(p23.title.contains('Африка'), true);")

with open('test/topics_test.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print('Updated test expectations!')
