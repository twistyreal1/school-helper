# -*- coding: utf-8 -*-
with open('lib/screens/subject_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# Replace InkWell with PressableBounce
old_inkwell = """                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  SmoothSlidePageRoute(
                                    page: TopicDetailScreen(topic: topic),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                              borderRadius: BorderRadius.circular(20),
                            child: Container("""

new_pressable = """                            return PressableBounce(
                              scaleFactor: 0.97,
                              onTap: () {
                                Navigator.of(context).push(
                                  SmoothSlidePageRoute(
                                    page: TopicDetailScreen(topic: topic),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                              child: Container("""

if '\r\n' in text:
    old_inkwell = old_inkwell.replace('\n', '\r\n')
    new_pressable = new_pressable.replace('\n', '\r\n')

assert old_inkwell in text, 'old_inkwell not found'
text = text.replace(old_inkwell, new_pressable, 1)

with open('lib/screens/subject_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print('Updated lib/screens/subject_screen.dart successfully!')
