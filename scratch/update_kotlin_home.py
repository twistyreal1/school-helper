# -*- coding: utf-8 -*-

p = r'D:\диплом\projects\Classmatte kotlin\app\src\main\java\com\school\classmate\ui\screens\home\HomeScreen.kt'
with open(p, 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Check imports
import_insert = """import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.togetherWith
"""
for i, l in enumerate(lines):
    if 'import androidx.compose.animation.AnimatedVisibility' in l:
        lines.insert(i, import_insert)
        break

start_idx = None
end_idx = None
for i, l in enumerate(lines):
    if 'else -> {' in l and 'STANDARD HOME VIEW' in lines[i+1]:
        start_idx = i
    if start_idx is not None and '// DIALOGS & SHEETS' in l:
        end_idx = i - 6
        break

print(f"start_idx: {start_idx}, end_idx: {end_idx}")

new_block = """                    else -> {
                        // STANDARD HOME VIEW: SUBJECTS GRID & QUICK TOPICS WITH SMOOTH GRADE TRANSITION
                        item {
                            AnimatedContent(
                                targetState = currentGrade,
                                transitionSpec = {
                                    (fadeIn(animationSpec = tween(320)) +
                                     slideInVertically(animationSpec = tween(320)) { height -> (height * 0.05f).toInt() })
                                    .togetherWith(fadeOut(animationSpec = tween(220)))
                                },
                                label = "grade_transition"
                            ) { activeGrade ->
                                val activeSubjects = topicRepository.getSubjectsForGrade(activeGrade)
                                val activeQuickTopics = remember(activeGrade) {
                                    topicRepository.getTopicsForGrade(activeGrade).take(6)
                                }

                                Column(
                                    modifier = Modifier.fillMaxWidth(),
                                    verticalArrangement = Arrangement.spacedBy(14.dp)
                                ) {
                                    // Subjects Section Title
                                    Row(
                                        modifier = Modifier.fillMaxWidth(),
                                        horizontalArrangement = Arrangement.SpaceBetween,
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Row(verticalAlignment = Alignment.CenterVertically) {
                                            Icon(
                                                imageVector = Icons.Rounded.School,
                                                contentDescription = null,
                                                tint = theme.primary,
                                                modifier = Modifier.size(20.dp)
                                            )
                                            Spacer(modifier = Modifier.width(8.dp))
                                            Text(
                                                text = "Предметы $activeGrade класса",
                                                style = MaterialTheme.typography.titleMedium,
                                                fontWeight = FontWeight.ExtraBold,
                                                color = theme.onBackground
                                            )
                                        }

                                        Text(
                                            text = "${activeSubjects.size} предметов",
                                            fontSize = 12.sp,
                                            fontWeight = FontWeight.Bold,
                                            color = theme.primary
                                        )
                                    }

                                    // Subjects Grid (paired in rows of 2)
                                    val subjectChunks = activeSubjects.chunked(2)
                                    for (pair in subjectChunks) {
                                        Row(
                                            modifier = Modifier.fillMaxWidth(),
                                            horizontalArrangement = Arrangement.spacedBy(12.dp)
                                        ) {
                                            for (subject in pair) {
                                                val count = topicRepository.getTopicsCountForGradeAndSubject(activeGrade, subject.id)
                                                Box(modifier = Modifier.weight(1f)) {
                                                    SubjectCard(
                                                        subject = subject,
                                                        topicCount = count,
                                                        onClick = { onSelectSubject(subject.id) }
                                                    )
                                                }
                                            }
                                            if (pair.size == 1) {
                                                Spacer(modifier = Modifier.weight(1f))
                                            }
                                        }
                                    }

                                    // Quick Topics Section
                                    if (activeQuickTopics.isNotEmpty()) {
                                        Spacer(modifier = Modifier.height(10.dp))
                                        Row(verticalAlignment = Alignment.CenterVertically) {
                                            Box(
                                                modifier = Modifier
                                                    .clip(RoundedCornerShape(8.dp))
                                                    .background(Color(0xFFF59E0B).copy(alpha = 0.15f))
                                                    .padding(6.dp)
                                            ) {
                                                Icon(
                                                    imageVector = Icons.Rounded.Bolt,
                                                    contentDescription = null,
                                                    tint = Color(0xFFF59E0B),
                                                    modifier = Modifier.size(18.dp)
                                                )
                                            }
                                            Spacer(modifier = Modifier.width(8.dp))
                                            Text(
                                                text = "Популярные шпаргалки $activeGrade класса",
                                                style = MaterialTheme.typography.titleMedium,
                                                fontWeight = FontWeight.ExtraBold,
                                                color = theme.onBackground
                                            )
                                        }

                                        for (topic in activeQuickTopics) {
                                            val topicSubject = topicRepository.getSubjectById(topic.subjectId)
                                            QuickTopicItem(
                                                topic = topic,
                                                subject = topicSubject,
                                                onClick = { onSelectTopic(topic.id) }
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
"""

lines[start_idx:end_idx] = [new_block]

with open(p, 'w', encoding='utf-8', newline='\n') as f:
    f.writelines(lines)

print("Successfully updated HomeScreen.kt with AnimatedContent!")
