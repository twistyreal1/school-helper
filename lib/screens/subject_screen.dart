import 'dart:async';
import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/topic_model.dart';
import '../services/user_prefs_service.dart';
import '../widgets/page_transitions.dart';
import 'topic_detail_screen.dart';

class SubjectScreen extends StatefulWidget {
  final Subject subject;
  final int grade;

  const SubjectScreen({
    super.key,
    required this.subject,
    required this.grade,
  });

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final TextEditingController _searchController = TextEditingController();
  late int _currentGrade;
  String _searchQuery = '';
  Timer? _searchDebounceTimer;

  void _onSearchChanged(String val) {
    final trimmed = val.trim();
    if (trimmed.isEmpty) {
      _searchDebounceTimer?.cancel();
      setState(() => _searchQuery = '');
      return;
    }
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 220), () {
      if (mounted) {
        setState(() => _searchQuery = trimmed);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _currentGrade = widget.grade;
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = UserPrefsService();

    final allTopics = MockDatabase.getTopicsForGradeAndSubject(
      _currentGrade,
      widget.subject.id,
    );

    final filteredTopics = _searchQuery.isEmpty
        ? allTopics
        : allTopics.where((t) {
            final q = _searchQuery.toLowerCase();
            return t.title.toLowerCase().contains(q) ||
                t.shortSummary.toLowerCase().contains(q) ||
                t.tags.any((tag) => tag.toLowerCase().contains(q));
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
        actions: [
          // Быстрый переключатель классов в шапке
          PopupMenuButton<int>(
            initialValue: _currentGrade,
            tooltip: 'Выбрать класс',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.subject.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_currentGrade класс',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: widget.subject.primaryColor,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 18,
                      color: widget.subject.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            onSelected: (grade) {
              setState(() => _currentGrade = grade);
              prefs.updateGrade(grade);
            },
            itemBuilder: (context) {
              return widget.subject.grades.map((grade) {
                return PopupMenuItem<int>(
                  value: grade,
                  child: Text('$grade класс'),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SwipeBackWrapper(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                // Поиск по темам предмета
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Поиск темы по ${widget.subject.name.toLowerCase()}...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isNotEmpty || _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchDebounceTimer?.cancel();
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                      ),
                    ),
                  ),
                ),

                // Список тем
                Expanded(
                  child: filteredTopics.isEmpty
                      ? _buildEmptyPlaceholder(theme)
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + MediaQuery.paddingOf(context).bottom),
                          itemCount: filteredTopics.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final topic = filteredTopics[index];
                            final isFav = prefs.isFavorite(topic.id);

                            return PressableBounce(
                              scaleFactor: 0.97,
                              onTap: () {
                                Navigator.of(context).push(
                                  SmoothSlidePageRoute(
                                    page: TopicDetailScreen(topic: topic),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                              child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          topic.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isFav ? Icons.star_rounded : Icons.star_border_rounded,
                                          color: isFav ? Colors.amber : null,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            prefs.toggleFavorite(topic.id);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    topic.shortSummary,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.35,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      if (topic.formulas.isNotEmpty) ...[
                                        _buildChip(
                                          icon: Icons.functions_rounded,
                                          label: '${topic.formulas.length} формул',
                                          color: widget.subject.primaryColor,
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      if (topic.definitions.isNotEmpty) ...[
                                        _buildChip(
                                          icon: Icons.menu_book_rounded,
                                          label: '${topic.definitions.length} понятий',
                                          color: const Color(0xFF10B981),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlaceholder(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'По запросу "$_searchQuery" ничего не найдено'
                  : 'Для $_currentGrade класса темы пока наполняются',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            if (_searchQuery.isEmpty && _currentGrade != 8) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() => _currentGrade = 8);
                  UserPrefsService().updateGrade(8);
                },
                child: const Text('Перейти к 8 классу (там есть темы)'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
