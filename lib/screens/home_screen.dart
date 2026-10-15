import 'dart:ui';
import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/topic_model.dart';
import '../services/user_prefs_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/page_transitions.dart';
import 'loading_screen.dart';
import 'onboarding_screen.dart';
import 'subject_screen.dart';
import 'topic_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  bool _showFavoritesOnly = false;

  late AnimationController _headerAnimController;
  late Animation<double> _headerFadeAnimation;

  @override
  void initState() {
    super.initState();
    UserPrefsService().addListener(_onPrefsChanged);

    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerFadeAnimation = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );
    _headerAnimController.forward();
  }

  void _onPrefsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    UserPrefsService().removeListener(_onPrefsChanged);
    _headerAnimController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showThemePicker(BuildContext context) {
    final prefs = UserPrefsService();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return LiquidGlassContainer(
          borderRadius: 28,
          opacity: isDark ? 0.85 : 0.92,
          padding: const EdgeInsets.all(24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.palette_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Тема оформления',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...AppThemeMode.values.map((mode) {
                  final isSelected = mode == prefs.themeMode;
                  final themeColor = _getThemeColor(mode);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        prefs.updateTheme(mode);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? themeColor.withValues(alpha: 0.14)
                              : theme.colorScheme.surface.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? themeColor
                                : theme.colorScheme.onSurface.withValues(alpha: 0.08),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: themeColor.withValues(alpha: 0.2),
                              child: Icon(mode.icon, color: themeColor),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mode.displayName,
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    mode.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle_rounded, color: themeColor, size: 22),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getThemeColor(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.modernBlue:
        return const Color(0xFF2563EB);
      case AppThemeMode.midnightCyber:
        return const Color(0xFF8B5CF6);
      case AppThemeMode.emeraldMatcha:
        return const Color(0xFF059669);
      case AppThemeMode.warmNotebook:
        return const Color(0xFFD97706);
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    final prefs = UserPrefsService();
    final nameCtrl = TextEditingController(text: prefs.userName);
    int selectedGrade = prefs.grade;

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: LiquidGlassContainer(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 24,
                  opacity: isDark ? 0.85 : 0.92,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.tune_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Настройки профиля',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text('Твое имя:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            hintText: 'Введи свое имя',
                            prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                            filled: true,
                            fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Выбери класс:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$selectedGrade класс',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [5, 6, 7, 8, 9, 10, 11].map((g) {
                            final isChosen = g == selectedGrade;
                            return ChoiceChip(
                              label: Text('$g класс'),
                              selected: isChosen,
                              onSelected: (val) {
                                if (val) {
                                  setDialogState(() => selectedGrade = g);
                                }
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Демонстрация и предпросмотр:',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const OnboardingScreen(isEditing: true),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                                label: const Text(
                                  'Онбординг',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const LoadingScreen(isPreview: true),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.play_circle_outline_rounded, size: 16),
                                label: const Text(
                                  'Экран загрузки',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: const Text('Отмена'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  prefs.updateName(nameCtrl.text.trim());
                                  prefs.updateGrade(selectedGrade);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: const Text(
                                  'Сохранить',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getCurriculumLabel(Subject subject, int grade) {
    if (grade == 8) {
      switch (subject.id) {
        case 'informatics':
          return 'Л. Л. Босова • ФГОС (§ 1–5.5)';
        case 'algebra':
          return 'Ю. Н. Макарычев • ФГОС (§ 1–50)';
        case 'geometry':
          return 'Л. С. Атанасян • ФГОС (§ 1–36)';
        case 'physics':
          return 'И. М. Пёрышкин • ФГОС (§ 1–25)';
        case 'biology':
          return 'В. В. Пасечник • Линейный (§ 1–60)';
        case 'geography':
          return 'А. И. Алексеев • «Полярная звезда» (§ 1–56)';
        case 'history':
          return 'В. Р. Мединский • Новое время (§ 1–29)';
        case 'russian':
          return 'Т. А. Ладыженская • Синтаксис';
        case 'literature':
          return 'В. Я. Коровина • Анализ произведений';
        case 'chemistry':
          return 'О. С. Габриелян • Основы химии';
      }
    }
    return '${subject.grades.length} классов программы';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final prefs = UserPrefsService();
    final currentGrade = prefs.grade;

    final subjectsForGrade = MockDatabase.subjects
        .where((s) => s.grades.contains(currentGrade))
        .toList();

    final favoriteTopics = MockDatabase.topics
        .where((t) => prefs.isFavorite(t.id))
        .toList();

    final totalGradeTopics = MockDatabase.topics
        .where((t) => t.grade == currentGrade)
        .length;

    final isSearching = _searchQuery.isNotEmpty;
    final searchResults = isSearching
        ? MockDatabase.searchTopics(_searchQuery, grade: null)
        : <Topic>[];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: isDark ? 0.70 : 0.85),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.white.withValues(alpha: 0.60),
                    width: 1.0,
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const AppLogo(size: 34, hasShadow: false),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Классмейт',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: -0.4,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$currentGrade класс • ФГОС',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Кнопка избранного со счётчиком
                      IconButton(
                        tooltip: _showFavoritesOnly ? 'Показать все' : 'Мои закладки',
                        icon: Badge(
                          isLabelVisible: favoriteTopics.isNotEmpty,
                          label: Text('${favoriteTopics.length}'),
                          child: Icon(
                            _showFavoritesOnly ? Icons.star_rounded : Icons.star_border_rounded,
                            color: _showFavoritesOnly ? Colors.amber : null,
                          ),
                        ),
                        onPressed: () {
                          setState(() => _showFavoritesOnly = !_showFavoritesOnly);
                        },
                      ),
                      // Выбор темы
                      IconButton(
                        tooltip: 'Выбрать тему оформления',
                        icon: const Icon(Icons.palette_outlined),
                        onPressed: () => _showThemePicker(context),
                      ),
                      // Настройки профиля
                      IconButton(
                        tooltip: 'Настройки профиля',
                        icon: const Icon(Icons.tune_rounded),
                        onPressed: () => _showEditProfileDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: LiquidGlassBackground(
        animate: true,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Приветствие, поиск и фильтр классов
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Приветствие с показателями
                        FadeTransition(
                          opacity: _headerFadeAnimation,
                          child: _buildGreetingBanner(
                            theme,
                            prefs,
                            subjectsForGrade.length,
                            totalGradeTopics,
                            favoriteTopics.length,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Поисковая строка капсула Liquid Glass
                        _buildSearchBar(theme),
                        const SizedBox(height: 18),

                        // Селектор классов
                        if (!isSearching && !_showFavoritesOnly) ...[
                          _buildGradeSelector(theme, prefs),
                          const SizedBox(height: 18),
                        ],
                      ],
                    ),
                  ),
                ),

                // Основной список предметов / результатов
                if (isSearching)
                  _buildSearchResultsSliver(theme, searchResults)
                else if (_showFavoritesOnly)
                  _buildFavoritesSliver(theme, favoriteTopics)
                else ...[
                  // Сетка школьных предметов
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: _buildSubjectsGrid(theme, subjectsForGrade, currentGrade),
                  ),

                  // Быстрые популярные формулы
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: _buildQuickTopicsSection(theme, currentGrade),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 36)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Приветственный баннер с эффектом жидкого стекла и быстрой статистикой
  Widget _buildGreetingBanner(
    ThemeData theme,
    UserPrefsService prefs,
    int subjectCount,
    int topicCount,
    int favCount,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final name = prefs.userName.trim();
    final greetingText = name.isNotEmpty ? 'Здравствуй, $name!' : 'Здравствуй, ученик!';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  theme.colorScheme.primary.withValues(alpha: 0.38),
                  theme.colorScheme.secondary.withValues(alpha: 0.22),
                ]
              : [
                  theme.colorScheme.primary.withValues(alpha: 0.92),
                  theme.colorScheme.secondary.withValues(alpha: 0.85),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.50),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.25 : 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Верхний глянцевый блик Liquid Glass
            Positioned(
              top: 0,
              left: 20,
              right: 20,
              height: 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: isDark ? 0.50 : 0.85),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Аватарка ученика с инициалом
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.45),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '🎓',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greetingText,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${prefs.grade} класс • Школьный помощник ФГОС',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Кнопка редактирования профиля
                      InkWell(
                        onTap: () => _showEditProfileDialog(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.40),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.tune_rounded, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                '${prefs.grade} кл',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Разделитель
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 14),
                  // Строка быстрых показателей (Статистика)
                  Row(
                    children: [
                      _buildStatItem(
                        icon: Icons.menu_book_rounded,
                        count: '$subjectCount',
                        label: 'предметов',
                      ),
                      _buildStatDivider(),
                      _buildStatItem(
                        icon: Icons.layers_rounded,
                        count: '$topicCount',
                        label: 'тем курса',
                      ),
                      _buildStatDivider(),
                      _buildStatItem(
                        icon: Icons.star_rounded,
                        count: '$favCount',
                        label: 'в закладках',
                        color: Colors.amberAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String count,
    required String label,
    Color color = Colors.white,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.white.withValues(alpha: 0.20),
    );
  }

  // Поисковая строка капсула Liquid Glass
  Widget _buildSearchBar(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: isDark ? 0.70 : 0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.65),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // Верхний блик
            Positioned(
              top: 0,
              left: 16,
              right: 16,
              height: 1.5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: isDark ? 0.35 : 0.75),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: const TextStyle(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Поиск формул, тем (например: "дискриминант", "Python", "Пифагор")...',
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: false,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Горизонтальный селектор классов в стиле Frosted Glass
  Widget _buildGradeSelector(ThemeData theme, UserPrefsService prefs) {
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.school_rounded, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Text(
                  'Выбор класса:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Text(
                '${prefs.grade} класс активен',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [5, 6, 7, 8, 9, 10, 11].map((grade) {
              final isCurrent = grade == prefs.grade;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () {
                    prefs.updateGrade(grade);
                    setState(() {});
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: isCurrent
                          ? LinearGradient(
                              colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                            )
                          : null,
                      color: isCurrent
                          ? null
                          : theme.colorScheme.surface.withValues(alpha: isDark ? 0.65 : 0.80),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isCurrent
                            ? Colors.white.withValues(alpha: 0.50)
                            : isDark
                                ? Colors.white.withValues(alpha: 0.10)
                                : Colors.white.withValues(alpha: 0.60),
                        width: 1.2,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isCurrent) ...[
                          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          '$grade класс',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                            color: isCurrent ? Colors.white : theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Высокопроизводительная сетка карточек предметов Liquid Glass
  Widget _buildSubjectsGrid(ThemeData theme, List<Subject> subjects, int currentGrade) {
    final isDark = theme.brightness == Brightness.dark;

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.10,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final subject = subjects[index];
          final topicCount = MockDatabase.getTopicsForGradeAndSubject(
            currentGrade,
            subject.id,
          ).length;
          final curriculumNote = _getCurriculumLabel(subject, currentGrade);

          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                SmoothSlidePageRoute(
                  page: SubjectScreen(
                    subject: subject,
                    grade: currentGrade,
                  ),
                ),
              ).then((_) => setState(() {}));
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: isDark ? 0.68 : 0.82),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.65),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Верхний глянцевый блик Liquid Glass
                    Positioned(
                      top: 0,
                      left: 14,
                      right: 14,
                      height: 1.5,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.0),
                              Colors.white.withValues(alpha: isDark ? 0.40 : 0.80),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 3D-styled Glowing Subject Icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [subject.primaryColor, subject.secondaryColor],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: subject.primaryColor.withValues(alpha: 0.35),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(subject.icon, color: Colors.white, size: 22),
                              ),
                              // Topic Count Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                                decoration: BoxDecoration(
                                  color: subject.primaryColor.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: subject.primaryColor.withValues(alpha: 0.25),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  topicCount > 0 ? '$topicCount тем' : 'Скоро темы',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: subject.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                curriculumNote,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: subject.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subject.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  height: 1.25,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: subjects.length,
      ),
    );
  }

  // Быстрые темы в стиле Liquid Glass
  Widget _buildQuickTopicsSection(ThemeData theme, int currentGrade) {
    final isDark = theme.brightness == Brightness.dark;
    final gradeTopics = MockDatabase.topics.where((t) => t.grade == currentGrade).toList();
    if (gradeTopics.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bolt_rounded, color: Colors.amber, size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              'Популярные шпаргалки $currentGrade класса',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...gradeTopics.take(4).map((topic) {
          final subject = MockDatabase.subjects.firstWhere(
            (s) => s.id == topic.subjectId,
            orElse: () => MockDatabase.subjects.first,
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  SmoothSlidePageRoute(
                    page: TopicDetailScreen(topic: topic),
                  ),
                ).then((_) => setState(() {}));
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: isDark ? 0.68 : 0.82),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.10)
                        : Colors.white.withValues(alpha: 0.60),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Верхний глянцевый блик
                      Positioned(
                        top: 0,
                        left: 12,
                        right: 12,
                        height: 1.5,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: isDark ? 0.35 : 0.75),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [subject.primaryColor, subject.secondaryColor],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: subject.primaryColor.withValues(alpha: 0.30),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(subject.icon, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic.title,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${subject.name} • ${topic.formulas.isNotEmpty ? '${topic.formulas.length} формул' : 'Теория и конспект'}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.60),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // Результаты поиска Liquid Glass
  Widget _buildSearchResultsSliver(ThemeData theme, List<Topic> results) {
    final isDark = theme.brightness == Brightness.dark;

    if (results.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              Icon(Icons.search_off_rounded, size: 56, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
              const SizedBox(height: 12),
              Text(
                'Ничего не найдено по запросу "$_searchQuery"',
                style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final topic = results[index];
            final subject = MockDatabase.subjects.firstWhere(
              (s) => s.id == topic.subjectId,
              orElse: () => MockDatabase.subjects.first,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    SmoothSlidePageRoute(
                      page: TopicDetailScreen(topic: topic),
                    ),
                  ).then((_) => setState(() {}));
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: isDark ? 0.70 : 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : Colors.white.withValues(alpha: 0.65),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [subject.primaryColor, subject.secondaryColor],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${topic.grade} кл',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              subject.name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: subject.primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        topic.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        topic.shortSummary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: results.length,
        ),
      ),
    );
  }

  // Избранное Liquid Glass
  Widget _buildFavoritesSliver(ThemeData theme, List<Topic> favs) {
    final isDark = theme.brightness == Brightness.dark;

    if (favs.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              const Icon(Icons.star_outline_rounded, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              const Text(
                'В закладках пока пусто',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Нажми на звездочку ⭐ в любой теме или формуле,\nчтобы сохранить шпаргалку для быстрого доступа перед уроком!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final topic = favs[index];
            final subject = MockDatabase.subjects.firstWhere(
              (s) => s.id == topic.subjectId,
              orElse: () => MockDatabase.subjects.first,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    SmoothSlidePageRoute(
                      page: TopicDetailScreen(topic: topic),
                    ),
                  ).then((_) => setState(() {}));
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: isDark ? 0.70 : 0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.45),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.10),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [subject.primaryColor, subject.secondaryColor],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(subject.icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topic.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '${topic.grade} класс • ${subject.name}',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.star_rounded, color: Colors.amber, size: 26),
                        onPressed: () {
                          setState(() {
                            UserPrefsService().toggleFavorite(topic.id);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: favs.length,
        ),
      ),
    );
  }
}
