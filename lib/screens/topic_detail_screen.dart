import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock_database.dart';
import '../models/topic_model.dart';
import '../services/user_prefs_service.dart';
import '../widgets/page_transitions.dart';
import '../widgets/math_formula_widget.dart';
import '../widgets/geometry_diagram_widget.dart';

class TopicDetailScreen extends StatefulWidget {
  final Topic topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  // Выбранная вкладка: 'all', 'summary', 'formulas', 'rules', 'definitions', 'lifehacks', 'examples'
  String _selectedSection = 'all';
  bool _cheatSheetOnlyMode = false;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('$label скопировано!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  bool _matchesSearch(String text) {
    if (_searchQuery.trim().isEmpty) return true;
    return text.toLowerCase().contains(_searchQuery.trim().toLowerCase());
  }

  String? _resolveFigureType(Topic topic) {
    if (topic.figureType != null) return topic.figureType;
    if (topic.subjectId != 'geometry') return null;

    final text = '${topic.title} ${topic.tags.join(' ')}'.toLowerCase();
    if (text.contains('параллелограмм')) return 'parallelogram';
    if (text.contains('трапеци')) return 'trapezoid';
    if (text.contains('прямоугольник')) return 'rectangle';
    if (text.contains('ромб')) return 'rhombus';
    if (text.contains('квадрат')) return 'square';
    if (text.contains('пифагор') || text.contains('прямоугольн')) return 'right_triangle';
    if (text.contains('средняя линия')) return 'triangle_midline';
    if (text.contains('подобн') || text.contains('подоби')) return 'similar_triangles';
    if (text.contains('синус') || text.contains('косинус') || text.contains('тангенс')) return 'trig_triangle';
    if (text.contains('касательн')) return 'circle_tangent';
    if (text.contains('вписанн') && text.contains('угол')) return 'circle_angles';
    if (text.contains('вписанн') || text.contains('описанн')) return 'inscribed_quad';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = UserPrefsService();
    final topic = widget.topic;
    final subject = MockDatabase.subjects.firstWhere(
      (s) => s.id == topic.subjectId,
      orElse: () => MockDatabase.subjects.first,
    );
    final isFav = prefs.isFavorite(topic.id);
    final isRussian = topic.subjectId == 'russian';
    final isLiterature = topic.subjectId == 'literature';
    final figureType = _resolveFigureType(topic);

    final hasFormulas = topic.formulas.isNotEmpty;
    final hasRules = topic.rules.isNotEmpty;
    final hasDefs = topic.definitions.isNotEmpty;
    final hasLifehacks = topic.lifehacks.isNotEmpty;
    final hasExamples = topic.allExamples.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        actions: [
          // Поиск внутри темы
          IconButton(
            tooltip: _isSearchVisible ? 'Закрыть поиск' : 'Искать в теме',
            icon: Icon(
              _isSearchVisible ? Icons.search_off_rounded : Icons.search_rounded,
              color: _isSearchVisible ? theme.colorScheme.primary : null,
            ),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
          // Кнопка режима быстрой шпоры
          IconButton(
            tooltip: _cheatSheetOnlyMode ? 'Полный конспект' : 'Режим шпаргалки',
            icon: Icon(
              _cheatSheetOnlyMode ? Icons.view_headline_rounded : Icons.flash_on_rounded,
              color: _cheatSheetOnlyMode ? Colors.amber : null,
            ),
            onPressed: () {
              setState(() {
                _cheatSheetOnlyMode = !_cheatSheetOnlyMode;
                if (_cheatSheetOnlyMode) {
                  _selectedSection = 'all';
                }
              });
            },
          ),
          // Кнопка избранного
          IconButton(
            tooltip: isFav ? 'Убрать из избранного' : 'Добавить в избранное',
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
      body: SwipeBackWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Шапка темы
                  _buildHeader(theme, subject),
                  const SizedBox(height: 14),

                  // 2. Строка поиска внутри темы (если открыта)
                  if (_isSearchVisible) ...[
                    _buildInlineSearchBar(theme),
                    const SizedBox(height: 12),
                  ],

                  // 3. Баннер режима шпоры (если включен)
                  if (_cheatSheetOnlyMode) ...[
                    _buildCheatSheetBanner(),
                    const SizedBox(height: 12),
                  ],

                  // 4. Интерактивная панель разделов (Табы/Фильтры)
                  _buildSectionTabs(
                    theme: theme,
                    subject: subject,
                    isRussian: isRussian,
                    isLiterature: isLiterature,
                    hasFormulas: hasFormulas,
                    hasRules: hasRules,
                    hasDefs: hasDefs,
                    hasLifehacks: hasLifehacks,
                    hasExamples: hasExamples,
                  ),
                  const SizedBox(height: 16),

                  // 5. РАЗДЕЛ: КРАТКАЯ СУТЬ
                  if ((_selectedSection == 'all' || _selectedSection == 'summary') &&
                      !_cheatSheetOnlyMode &&
                      _matchesSearch(topic.shortSummary)) ...[
                    _buildSectionDivider(
                      theme: theme,
                      title: isLiterature ? 'О произведении' : 'Краткая суть темы',
                      icon: isLiterature ? Icons.menu_book_rounded : Icons.lightbulb_outline_rounded,
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(height: 10),
                    _buildSummaryCard(theme, topic.shortSummary, subject),
                    const SizedBox(height: 20),
                  ],

                  // 5.5. ВЕКТОРНЫЙ ГЕОМЕТРИЧЕСКИЙ ЧЕРТЕЖ
                  if (figureType != null &&
                      (_selectedSection == 'all' || _selectedSection == 'formulas' || _selectedSection == 'rules')) ...[
                    GeometryDiagramWidget(figureType: figureType),
                    const SizedBox(height: 14),
                  ],

                  // 6. РАЗДЕЛ: СХЕМЫ / ФОРМУЛЫ
                  if (hasFormulas &&
                      (_selectedSection == 'all' || _selectedSection == 'formulas')) ...[
                    _buildSectionDivider(
                      theme: theme,
                      title: isRussian ? 'Синтаксические схемы и модели' : 'Формулы и законы',
                      icon: isRussian ? Icons.account_tree_rounded : Icons.functions_rounded,
                      color: const Color(0xFF0D9488),
                      count: topic.formulas.length,
                    ),
                    const SizedBox(height: 10),
                    ...topic.formulas.where((f) {
                      if (_searchQuery.isEmpty) return true;
                      return _matchesSearch(f.title) ||
                          _matchesSearch(f.formula) ||
                          (f.description != null && _matchesSearch(f.description!));
                    }).map((f) => _buildFormulaCard(theme, f, subject, isRussian)),
                    const SizedBox(height: 20),
                  ],

                  // 7. РАЗДЕЛ: ПРАВИЛА И НОРМЫ
                  if (hasRules &&
                      (_selectedSection == 'all' || _selectedSection == 'rules')) ...[
                    _buildSectionDivider(
                      theme: theme,
                      title: isLiterature
                          ? 'Краткое содержание и сюжет по главам'
                          : (isRussian ? 'Правила и нормы пунктуации' : 'Главные правила и свойства'),
                      icon: isLiterature ? Icons.history_edu_rounded : Icons.check_circle_outline_rounded,
                      color: const Color(0xFF8B5CF6),
                      count: topic.rules.length,
                    ),
                    const SizedBox(height: 10),
                    ...topic.rules.where((r) => _matchesSearch(r)).map((r) =>
                        _buildRuleCard(theme, r, subject)),
                    const SizedBox(height: 20),
                  ],

                  // 8. РАЗДЕЛ: ТЕРМИНЫ И ОПРЕДЕЛЕНИЯ (скрыты в режиме шпоры)
                  if (hasDefs &&
                      !_cheatSheetOnlyMode &&
                      (_selectedSection == 'all' || _selectedSection == 'definitions')) ...[
                    _buildSectionDivider(
                      theme: theme,
                      title: isLiterature ? 'Герои и действующие лица' : 'Определения и ключевые понятия',
                      icon: isLiterature ? Icons.people_alt_rounded : Icons.menu_book_rounded,
                      color: const Color(0xFF10B981),
                      count: topic.definitions.length,
                    ),
                    const SizedBox(height: 10),
                    ...topic.definitions.where((d) {
                      if (_searchQuery.isEmpty) return true;
                      return _matchesSearch(d.term) ||
                          _matchesSearch(d.definition) ||
                          (d.note != null && _matchesSearch(d.note!));
                    }).map((d) => _buildDefinitionCard(theme, d, subject)),
                    const SizedBox(height: 20),
                  ],

                  // 9. РАЗДЕЛ: ЛАЙФХАКИ И ЛОВУШКИ (скрыты в режиме шпоры)
                  if (hasLifehacks &&
                      !_cheatSheetOnlyMode &&
                      (_selectedSection == 'all' || _selectedSection == 'lifehacks')) ...[
                    _buildSectionDivider(
                      theme: theme,
                      title: isLiterature ? 'Тема, главная мысль и анализ' : 'Ловушки ОГЭ и лайфхаки',
                      icon: isLiterature ? Icons.psychology_rounded : Icons.warning_amber_rounded,
                      color: const Color(0xFFF59E0B),
                      count: topic.lifehacks.length,
                    ),
                    const SizedBox(height: 10),
                    ...topic.lifehacks
                        .where((lh) => _matchesSearch(lh))
                        .map((lh) => _buildLifehackCard(theme, lh)),
                    const SizedBox(height: 20),
                  ],

                  // 10. РАЗДЕЛ: ПРАКТИЧЕСКИЕ ПРИМЕРЫ И РАЗБОРЫ (скрыты в режиме шпоры)
                  if (hasExamples &&
                      !_cheatSheetOnlyMode &&
                      (_selectedSection == 'all' || _selectedSection == 'examples')) ...[
                    _buildSectionDivider(
                      theme: theme,
                      title: isLiterature
                          ? 'Возможные вопросы с ответами'
                          : (isRussian
                              ? 'Практические разборы предложений'
                              : 'Примеры задач с пошаговым решением'),
                      icon: isLiterature ? Icons.quiz_rounded : Icons.assignment_turned_in_rounded,
                      color: const Color(0xFF059669),
                      count: topic.allExamples.length,
                    ),
                    const SizedBox(height: 10),
                    ...topic.allExamples.asMap().entries.where((e) {
                      if (_searchQuery.isEmpty) return true;
                      final ex = e.value;
                      return _matchesSearch(ex.task) ||
                          _matchesSearch(ex.answer) ||
                          ex.steps.any((s) => _matchesSearch(s));
                    }).map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildExampleCard(
                          theme,
                          entry.value,
                          index: topic.allExamples.length > 1 ? entry.key + 1 : null,
                          isRussian: isRussian,
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],

                  // 11. Теги внизу
                  if (topic.tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: topic.tags.map((tag) {
                          return Chip(
                            label: Text('#$tag', style: const TextStyle(fontSize: 12)),
                            backgroundColor:
                                theme.colorScheme.onSurface.withValues(alpha: 0.05),
                            side: BorderSide(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // ШАПКА ТЕМЫ
  // =========================================================================

  Widget _buildHeader(ThemeData theme, Subject subject) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            subject.primaryColor.withValues(alpha: 0.2),
            subject.secondaryColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: subject.primaryColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: subject.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.topic.grade} класс',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subject.name,
                  style: TextStyle(
                    color: subject.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.topic.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.25,
              letterSpacing: -0.4,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ПОИСКОВАЯ СТРОКА ВНУТРИ ТЕМЫ
  // =========================================================================

  Widget _buildInlineSearchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Искать в конспекте (правило, термин, пример)...',
                border: InputBorder.none,
                isDense: true,
                hintStyle: TextStyle(fontSize: 13.5),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
        ],
      ),
    );
  }

  // =========================================================================
  // БАННЕР ШПОРЫ
  // =========================================================================

  Widget _buildCheatSheetBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.bolt_rounded, color: Colors.amber, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Экспресс-режим: показаны только главные схемы, формулы и правила!',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // НАВИГАЦИОННЫЕ ТАБЫ (РАЗДЕЛИТЕЛИ РАЗДЕЛОВ)
  // =========================================================================

  Widget _buildSectionTabs({
    required ThemeData theme,
    required Subject subject,
    required bool isRussian,
    bool isLiterature = false,
    required bool hasFormulas,
    required bool hasRules,
    required bool hasDefs,
    required bool hasLifehacks,
    required bool hasExamples,
  }) {
    final tabs = <Map<String, dynamic>>[
      {'id': 'all', 'label': 'Все разделы', 'icon': Icons.apps_rounded, 'count': null},
      if (!_cheatSheetOnlyMode)
        {
          'id': 'summary',
          'label': isLiterature ? 'О книге' : 'Суть',
          'icon': isLiterature ? Icons.menu_book_rounded : Icons.lightbulb_outline_rounded,
          'count': null,
        },
      if (hasFormulas)
        {
          'id': 'formulas',
          'label': isRussian ? 'Схемы' : 'Формулы',
          'icon': isRussian ? Icons.account_tree_rounded : Icons.functions_rounded,
          'count': widget.topic.formulas.length,
        },
      if (hasRules)
        {
          'id': 'rules',
          'label': isLiterature ? 'Сюжет' : 'Правила',
          'icon': isLiterature ? Icons.history_edu_rounded : Icons.check_circle_outline_rounded,
          'count': widget.topic.rules.length,
        },
      if (hasDefs && !_cheatSheetOnlyMode)
        {
          'id': 'definitions',
          'label': isLiterature ? 'Герои' : 'Термины',
          'icon': isLiterature ? Icons.people_alt_rounded : Icons.menu_book_rounded,
          'count': widget.topic.definitions.length,
        },
      if (hasLifehacks && !_cheatSheetOnlyMode)
        {
          'id': 'lifehacks',
          'label': isLiterature ? 'Анализ' : 'Ловушки',
          'icon': isLiterature ? Icons.psychology_rounded : Icons.warning_amber_rounded,
          'count': widget.topic.lifehacks.length,
        },
      if (hasExamples && !_cheatSheetOnlyMode)
        {
          'id': 'examples',
          'label': isLiterature
              ? 'Вопросы'
              : (isRussian ? 'Разборы' : 'Практика'),
          'icon': isLiterature ? Icons.quiz_rounded : Icons.assignment_turned_in_rounded,
          'count': widget.topic.allExamples.length,
        },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _selectedSection == tab['id'];
          final color = isSelected ? subject.primaryColor : theme.colorScheme.onSurface;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: Icon(
                tab['icon'] as IconData,
                size: 16,
                color: isSelected ? Colors.white : color.withValues(alpha: 0.7),
              ),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tab['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : color,
                    ),
                  ),
                  if (tab['count'] != null) ...[
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.25)
                            : theme.colorScheme.onSurface.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${tab['count']}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : color,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              selected: isSelected,
              selectedColor: subject.primaryColor,
              backgroundColor: theme.colorScheme.surface,
              side: BorderSide(
                color: isSelected
                    ? subject.primaryColor
                    : theme.colorScheme.onSurface.withValues(alpha: 0.12),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (_) {
                setState(() => _selectedSection = tab['id'] as String);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // =========================================================================
  // РАЗДЕЛИТЕЛЬ СЕКЦИЙ СО СТИЛЕМ
  // =========================================================================

  Widget _buildSectionDivider({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Color color,
    int? count,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (count != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // КРАТКАЯ СУТЬ (С ВЫДЕЛЕНИЕМ ПРИМЕРОВ)
  // =========================================================================

  Widget _buildSummaryCard(ThemeData theme, String summary, Subject subject) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _buildParsedRichText(
              summary,
              baseStyle: TextStyle(
                fontSize: 15.5,
                height: 1.55,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
              theme: theme,
              accentColor: subject.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ПРАВИЛО: РАЗДЕЛЕНИЕ НА БЛОКИ, ПОДПУНКТЫ И ЛОВУШКИ
  // =========================================================================

  Widget _buildRuleCard(ThemeData theme, String ruleText, Subject subject) {
    // Проверяем, есть ли заголовок у правила (например, "ЧТО НЕ ЯВЛЯЕТСЯ...:" или "ТИРЕ СТАВИТСЯ:")
    String? headerTitle;
    List<String> items = [];

    final lines = ruleText.split('\n');
    if (lines.length > 1 && (lines[0].contains(':') || lines[0].toUpperCase() == lines[0])) {
      headerTitle = lines[0].trim();
      items = lines.sublist(1).where((l) => l.trim().isNotEmpty).toList();
    } else {
      items = [ruleText];
    }

    // Определяем статус заголовка для цветового акцента
    Color badgeColor = const Color(0xFF8B5CF6);
    IconData badgeIcon = Icons.rule_rounded;

    if (headerTitle != null) {
      final upper = headerTitle.toUpperCase();
      if (upper.contains('НЕ СТАВИТСЯ') ||
          upper.contains('НЕ ЯВЛЯЕТСЯ') ||
          upper.contains('НЕ ОБОСОБЛЯЮТСЯ') ||
          upper.contains('НИКОГДА')) {
        badgeColor = const Color(0xFFEF4444); // Красный для запретов
        badgeIcon = Icons.cancel_outlined;
      } else if (upper.contains('СТАВИТСЯ') ||
          upper.contains('ОБОСОБЛЯЮТСЯ') ||
          upper.contains('ОБЯЗАТЕЛЬНО')) {
        badgeColor = const Color(0xFF10B981); // Зеленый для обязательных правил
        badgeIcon = Icons.check_circle_outline_rounded;
      } else if (upper.contains('НОРМЫ') ||
          upper.contains('ЗАПОМНИ') ||
          upper.contains('ЛОВУШК')) {
        badgeColor = const Color(0xFFF59E0B); // Оранжевый для норм и ловушек
        badgeIcon = Icons.warning_amber_rounded;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: headerTitle != null
              ? badgeColor.withValues(alpha: 0.25)
              : theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Шапка правила, если есть заголовок
          if (headerTitle != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: badgeColor.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Icon(badgeIcon, color: badgeColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      headerTitle,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                        color: badgeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Список подпунктов с красивым визуальным разделением
          ...items.asMap().entries.map((entry) {
            final idx = entry.key;
            final line = entry.value.trim();

            // Проверяем, начинается ли строка с цифры "1. " или "1) "
            final numberMatch = RegExp(r'^(\d+)[\.\)]\s*(.*)$').firstMatch(line);
            // Проверяем, начинается ли строка с дефиса "- "
            final bulletMatch = RegExp(r'^[\-\•]\s*(.*)$').firstMatch(line);

            if (numberMatch != null) {
              final numStr = numberMatch.group(1)!;
              final content = numberMatch.group(2)!;

              return Padding(
                padding: EdgeInsets.only(bottom: idx == items.length - 1 ? 0 : 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2, right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        numStr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: badgeColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildSubItemWithExceptions(
                        content,
                        theme: theme,
                        accentColor: subject.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            } else if (bulletMatch != null) {
              final content = bulletMatch.group(1)!;

              return Padding(
                padding: EdgeInsets.only(bottom: idx == items.length - 1 ? 0 : 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 10),
                      child: Icon(Icons.circle, size: 7, color: badgeColor),
                    ),
                    Expanded(
                      child: _buildSubItemWithExceptions(
                        content,
                        theme: theme,
                        accentColor: subject.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Обычный абзац правила
              return Padding(
                padding: EdgeInsets.only(bottom: idx == items.length - 1 ? 0 : 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (headerTitle == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6, right: 10),
                        child: Icon(Icons.circle, size: 7, color: badgeColor),
                      ),
                    Expanded(
                      child: _buildSubItemWithExceptions(
                        line,
                        theme: theme,
                        accentColor: subject.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  /// Обрабатывает подпункт правила: если внутри есть "НО:", выделяет его в отдельный предупреждающий блок
  Widget _buildSubItemWithExceptions(
    String text, {
    required ThemeData theme,
    required Color accentColor,
  }) {
    if (text.contains('НО:')) {
      final parts = text.split('НО:');
      final before = parts[0].trim();
      final after = parts.sublist(1).join('НО:').trim();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParsedRichText(
            before,
            baseStyle: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
            theme: theme,
            accentColor: accentColor,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  margin: const EdgeInsets.only(right: 8, top: 1),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'НО',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: _buildParsedRichText(
                    after,
                    baseStyle: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: theme.brightness == Brightness.dark
                          ? Colors.amber.shade200
                          : const Color(0xFFB45309),
                    ),
                    theme: theme,
                    accentColor: theme.brightness == Brightness.dark
                        ? Colors.amber.shade300
                        : const Color(0xFFD97706),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return _buildParsedRichText(
      text,
      baseStyle: TextStyle(
        fontSize: 14,
        height: 1.45,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
      ),
      theme: theme,
      accentColor: accentColor,
    );
  }

  // =========================================================================
  // ТЕРМИНЫ: СТРУКТУРИРОВАННАЯ КАРТОЧКА
  // =========================================================================

  Widget _buildDefinitionCard(ThemeData theme, DefinitionItem def, Subject subject) {
    // Проверяем, содержит ли определение списки с нумерацией
    final hasNumbering = def.definition.contains(RegExp(r'\n\d+[\.\)]'));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 20,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  def.term,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ТЕРМИН',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (hasNumbering) ...[
            ...def.definition.split('\n').map((line) {
              final trimmed = line.trim();
              if (trimmed.isEmpty) return const SizedBox.shrink();

              final match = RegExp(r'^(\d+)[\.\)]\s*(.*)$').firstMatch(trimmed);
              if (match != null) {
                final numVal = match.group(1)!;
                final txt = match.group(2)!;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2, right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          numVal,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildParsedRichText(
                          txt,
                          baseStyle: TextStyle(
                            fontSize: 13.8,
                            height: 1.45,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
                          ),
                          theme: theme,
                          accentColor: subject.primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _buildParsedRichText(
                  trimmed,
                  baseStyle: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                  ),
                  theme: theme,
                  accentColor: subject.primaryColor,
                ),
              );
            }),
          ] else ...[
            _buildParsedRichText(
              def.definition,
              baseStyle: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
              ),
              theme: theme,
              accentColor: subject.primaryColor,
            ),
          ],

          if (def.note != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      def.note!,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // ФОРМУЛЫ И СИНТАКСИЧЕСКИЕ СХЕМЫ
  // =========================================================================

  Widget _buildFormulaCard(
    ThemeData theme,
    FormulaItem formula,
    Subject subject,
    bool isRussian,
  ) {
    // В русском языке схема часто многострочная (Согласование: ... \n Управление: ...)
    final isMultiScheme = isRussian && formula.formula.contains('\n');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  formula.title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18),
                tooltip: 'Скопировать формулу/схему',
                visualDensity: VisualDensity.compact,
                onPressed: () => _copyToClipboard(formula.formula, 'Формула'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Если это многострочная схема по русскому языку — делим на отдельные блоки!
          if (isMultiScheme) ...[
            ...formula.formula.split('\n').map((schemeLine) {
              final line = schemeLine.trim();
              if (line.isEmpty) return const SizedBox.shrink();

              // Ищем название схемы до двоеточия или знака равно
              String badgeName = '';
              String content = line;

              if (line.contains(':')) {
                final idx = line.indexOf(':');
                badgeName = line.substring(0, idx).trim();
                content = line.substring(idx + 1).trim();
              } else if (line.contains('=')) {
                final idx = line.indexOf('=');
                badgeName = line.substring(0, idx).trim();
                content = line.substring(idx + 1).trim();
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (badgeName.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeName,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    _buildParsedRichText(
                      content,
                      baseStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: theme.colorScheme.onSurface,
                      ),
                      theme: theme,
                      accentColor: const Color(0xFF0D9488),
                    ),
                  ],
                ),
              );
            }),
          ] else ...[
            // Стандартный блок формулы для математики/физики
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: MathFormulaWidget(
                formula: formula.formula,
                accentColor: theme.colorScheme.primary,
                fontSize: 16.5,
                baseStyle: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontFamily: 'monospace',
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],

          if (formula.description != null) ...[
            const SizedBox(height: 8),
            Text(
              formula.description!,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ],

          if (formula.variables != null && formula.variables!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: formula.variables!.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.5),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.5,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                        ),
                        children: [
                          TextSpan(
                            text: '${e.key} — ',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: e.value),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // ЛАЙФХАКИ И ЛОВУШКИ
  // =========================================================================

  Widget _buildLifehackCard(ThemeData theme, String hack) {
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark ? Colors.amber.shade300 : Colors.orange.shade800;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.orange.withValues(alpha: 0.16)
            : Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.orange.withValues(alpha: 0.45)
              : Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.orange.withValues(alpha: 0.3)
                  : Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.bolt_rounded, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildParsedRichText(
              hack,
              baseStyle: TextStyle(
                fontSize: 13.8,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              theme: theme,
              accentColor: isDark ? Colors.amber.shade300 : Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ПРИМЕРЫ И РАЗБОРЫ С ПОШАГОВЫМ РЕШЕНИЕМ
  // =========================================================================

  Widget _buildExampleCard(
    ThemeData theme,
    ExampleItem ex, {
    int? index,
    required bool isRussian,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_rounded,
                  color: Color(0xFF10B981),
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  index != null
                      ? (isRussian ? 'Разбор предложения #$index' : 'Задание с решением #$index')
                      : (isRussian ? 'Разбор примера' : 'Пример задачи'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildParsedRichText(
            ex.task,
            baseStyle: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              height: 1.35,
              color: theme.colorScheme.onSurface,
            ),
            theme: theme,
            accentColor: const Color(0xFF047857),
          ),
          const Divider(height: 24),
          Text(
            isRussian ? 'Пошаговый синтаксический анализ:' : 'Пошаговое решение:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          ...ex.steps.asMap().entries.map((entry) {
            final stepIdx = entry.key + 1;
            final step = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2, right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$stepIdx',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    child: _buildParsedRichText(
                      step,
                      baseStyle: TextStyle(
                        fontSize: 13.8,
                        height: 1.45,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.88),
                      ),
                      theme: theme,
                      accentColor: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF047857), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ex.answer,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF047857),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // ПАРСЕР ТЕКСТА: ВЫДЕЛЕНИЕ ПРИМЕРОВ В КАВЫЧКАХ И СТРЕЛОК СХЕМ
  // =========================================================================

  List<InlineSpan> _parseSubAndSuperSpans(
    String text, {
    required TextStyle baseStyle,
    required Color color,
  }) {
    final subSupRegex = RegExp(
      r'(_\{([^\}]+)\}|_([a-zA-Zа-яА-Я0-9]+)|\^\{([^\}]+)\}|\^([a-zA-Zа-яА-Я0-9]+))',
    );

    if (!subSupRegex.hasMatch(text)) {
      return [TextSpan(text: text, style: baseStyle)];
    }

    final spans = <InlineSpan>[];
    int lastIndex = 0;
    final fontSize = baseStyle.fontSize ?? 14.0;

    for (final match in subSupRegex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }

      final isSubscript = match.group(0)!.startsWith('_');
      final rawIndex = match.group(2) ?? match.group(3) ?? match.group(4) ?? match.group(5) ?? '';
      final cleanIdx = rawIndex
          .replaceAll(r'\text{', '')
          .replaceAll('}', '')
          .replaceAll(r'\Delta', 'Δ')
          .trim();

      final indexFontSize = (fontSize * 0.65).clamp(9.0, 15.0);

      if (isSubscript) {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Transform.translate(
            offset: Offset(0, fontSize * 0.28),
            child: Text(
              cleanIdx,
              style: baseStyle.copyWith(
                fontSize: indexFontSize,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ));
      } else {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Transform.translate(
            offset: Offset(0, -fontSize * 0.32),
            child: Text(
              cleanIdx,
              style: baseStyle.copyWith(
                fontSize: indexFontSize,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ));
      }

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: baseStyle,
      ));
    }

    return spans;
  }

  /// Разбивает текст на фрагменты и подсвечивает примеры в кавычках «...» мягкими бейджами, а также парсит индексы
  Widget _buildParsedRichText(
    String text, {
    required TextStyle baseStyle,
    required ThemeData theme,
    Color? accentColor,
  }) {
    final effectiveStyle = baseStyle.color != null
        ? baseStyle
        : baseStyle.copyWith(color: theme.colorScheme.onSurface);

    final spans = <InlineSpan>[];
    final regex = RegExp(r'«([^»]+)»');
    int lastMatchEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.addAll(_parseSubAndSuperSpans(
          text.substring(lastMatchEnd, match.start),
          baseStyle: effectiveStyle,
          color: effectiveStyle.color ?? theme.colorScheme.onSurface,
        ));
      }

      final quotedContent = match.group(0)!;
      final pillColor = accentColor ?? theme.colorScheme.primary;

      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: pillColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: pillColor.withValues(alpha: 0.2)),
          ),
          child: Text(
            quotedContent,
            style: effectiveStyle.copyWith(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              fontSize: (effectiveStyle.fontSize ?? 14) * 0.95,
              color: pillColor,
            ),
          ),
        ),
      ));

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.addAll(_parseSubAndSuperSpans(
        text.substring(lastMatchEnd),
        baseStyle: effectiveStyle,
        color: effectiveStyle.color ?? theme.colorScheme.onSurface,
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
