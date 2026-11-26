import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../data/mock_database.dart';
import '../models/topic_model.dart';
import '../services/user_prefs_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/install_app_dialog.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/page_transitions.dart';
import 'subject_screen.dart';
import 'topic_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  Timer? _searchDebounceTimer;
  bool _showFavoritesOnly = false;

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

  late AnimationController _headerAnimController;
  late Animation<double> _headerFadeAnimation;

  // Анимация плавного переключения между классами
  late AnimationController _gradeTransitionController;
  late Animation<double> _gradeFadeAnimation;
  late Animation<Offset> _gradeSlideAnimation;
  int? _displayedGrade;

  @override
  void initState() {
    super.initState();
    _displayedGrade = UserPrefsService().grade;
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

    _gradeTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _gradeFadeAnimation = CurvedAnimation(
      parent: _gradeTransitionController,
      curve: Curves.easeOutCubic,
    );
    _gradeSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _gradeTransitionController,
      curve: Curves.easeOutCubic,
    ));
    _gradeTransitionController.value = 1.0;
  }

  void _onPrefsChanged() {
    if (mounted) {
      final newGrade = UserPrefsService().grade;
      if (_displayedGrade != newGrade) {
        _displayedGrade = newGrade;
        _gradeTransitionController.forward(from: 0.0);
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    UserPrefsService().removeListener(_onPrefsChanged);
    _headerAnimController.dispose();
    _gradeTransitionController.dispose();
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
        return const Color(0xFF6366F1);
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
                        const SizedBox(height: 24),
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


    Widget _buildHeaderActionButton({
    required BuildContext context,
    required Widget icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isActive = false,
    Color? activeColor,
    Widget? badge,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isActive
        ? (activeColor ?? theme.colorScheme.primary).withValues(alpha: isDark ? 0.22 : 0.16)
        : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05));

    final borderColor = isActive
        ? (activeColor ?? theme.colorScheme.primary).withValues(alpha: isDark ? 0.50 : 0.40)
        : (isDark ? Colors.white.withValues(alpha: 0.14) : Colors.black.withValues(alpha: 0.08));

    Widget buttonContent = Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: (activeColor ?? theme.colorScheme.primary).withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(child: icon),
    );

    if (badge != null) {
      buttonContent = Stack(
        clipBehavior: Clip.none,
        children: [
          buttonContent,
          Positioned(
            top: -4,
            right: -4,
            child: badge,
          ),
        ],
      );
    }

    return Tooltip(
      message: tooltip,
      child: PressableBounce(
        scaleFactor: 0.90,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: buttonContent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final prefs = UserPrefsService();
    final currentGrade = prefs.grade;

    final subjectsForGrade = MockDatabase.getSubjectsForGrade(currentGrade);
    final totalGradeTopics = MockDatabase.getTopicsCountForGrade(currentGrade);

    final favoriteTopics = _showFavoritesOnly
        ? MockDatabase.topics.where((t) => prefs.isFavorite(t.id)).toList()
        : const <Topic>[];

    final isSearching = _searchQuery.isNotEmpty;
    final searchResults = isSearching
        ? MockDatabase.searchTopics(_searchQuery, grade: null)
        : const <Topic>[];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: RepaintBoundary(
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xF2111420) : const Color(0xF6FFFFFF)),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.06),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
              child: Stack(
                children: [
                  // Верхний глянцевый блик Liquid Glass
                  Positioned(
                    top: 0,
                    left: 20,
                    right: 20,
                    height: 1.2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white.withValues(alpha: isDark ? 0.28 : 0.75),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Нижняя сияющая линия-акцент темы
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 1.5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            theme.colorScheme.primary.withValues(alpha: 0.6),
                            theme.colorScheme.secondary.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      child: Row(
                        children: [
                          // Логотип с мягким градиентным ореолом
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withValues(alpha: 0.40),
                                  theme.colorScheme.secondary.withValues(alpha: 0.15),
                                ],
                              ),
                            ),
                            child: const AppLogo(size: 36, hasShadow: false),
                          ),
                          const SizedBox(width: 10),
                          // Название и интерактивный бейдж класса
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
                              const SizedBox(height: 1),
                              Row(
                                children: [
                                  PressableBounce(
                                    scaleFactor: 0.94,
                                    onTap: () => _showEditProfileDialog(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.20 : 0.10),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.35 : 0.22),
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 5.5,
                                            height: 5.5,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: theme.colorScheme.primary,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: theme.colorScheme.primary.withValues(alpha: 0.6),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 4.5),
                                          Text(
                                            '$currentGrade класс',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Icon(
                                            Icons.unfold_more_rounded,
                                            size: 11,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.08),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Text(
                                      'ФГОС',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.4,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          // 1. Кнопка Избранного
                          _buildHeaderActionButton(
                            context: context,
                            tooltip: _showFavoritesOnly ? 'Показать все' : 'Мои закладки',
                            isActive: _showFavoritesOnly,
                            activeColor: Colors.amber,
                            badge: prefs.favorites.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(3.5),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.amber,
                                    ),
                                    child: Text(
                                      '${prefs.favorites.length}',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black87,
                                        height: 1,
                                      ),
                                    ),
                                  )
                                : null,
                            icon: Icon(
                              _showFavoritesOnly ? Icons.star_rounded : Icons.star_border_rounded,
                              size: 20,
                              color: _showFavoritesOnly ? Colors.amber : (isDark ? Colors.white70 : Colors.black87),
                            ),
                            onTap: () => setState(() => _showFavoritesOnly = !_showFavoritesOnly),
                          ),
                          // 2. Установить приложение
                          if (!isAppAlreadyInstalled())
                            _buildHeaderActionButton(
                              context: context,
                              tooltip: 'Установить приложение',
                              icon: Icon(
                                Icons.phone_android_rounded,
                                size: 19,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                              onTap: () => showInstallAppDialog(context),
                            ),
                          // 3. Выбор темы
                          _buildHeaderActionButton(
                            context: context,
                            tooltip: 'Выбрать тему оформления',
                            icon: Icon(
                              Icons.palette_rounded,
                              size: 19,
                              color: theme.colorScheme.primary,
                            ),
                            onTap: () => _showThemePicker(context),
                          ),
                          // 4. Настройки профиля
                          _buildHeaderActionButton(
                            context: context,
                            tooltip: 'Настройки профиля',
                            icon: Icon(
                              Icons.tune_rounded,
                              size: 19,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                            onTap: () => _showEditProfileDialog(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: LiquidGlassBackground(
        animate: false,
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
                            prefs.favorites.length,
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
                  // Сетка школьных предметов с плавной анимацией при смене класса
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: _buildAnimatedGradeSliver(
                      theme: theme,
                      subjects: subjectsForGrade,
                      currentGrade: currentGrade,
                    ),
                  ),

                  // Быстрые популярные формулы с плавной анимацией
                  _buildAnimatedQuickTopicsSliver(theme, currentGrade),

                  SliverToBoxAdapter(
                    child: SizedBox(height: 36 + MediaQuery.paddingOf(context).bottom),
                  ),
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
                  theme.colorScheme.secondary.withValues(alpha: 0.42),
                  theme.colorScheme.primary.withValues(alpha: 0.30),
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
              onChanged: _onSearchChanged,
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
                suffixIcon: _searchController.text.isNotEmpty || _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20),
                        onPressed: () {
                          _searchDebounceTimer?.cancel();
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
                Text(
                  'Выбор класса:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
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

  // Анимированная обертка сетки предметов для плавного перехода между классами
  Widget _buildAnimatedGradeSliver({
    required ThemeData theme,
    required List<Subject> subjects,
    required int currentGrade,
  }) {
    return SliverFadeTransition(
      opacity: _gradeFadeAnimation,
      sliver: _buildSubjectsGrid(theme, subjects, currentGrade),
    );
  }

  // Анимированная секция быстрых тем при переключении класса
  Widget _buildAnimatedQuickTopicsSliver(ThemeData theme, int currentGrade) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _gradeFadeAnimation,
        child: SlideTransition(
          position: _gradeSlideAnimation,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: _buildQuickTopicsSection(theme, currentGrade),
          ),
        ),
      ),
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
        childAspectRatio: 0.98,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final subject = subjects[index];
          final topicCount = MockDatabase.getTopicsCountForGradeAndSubject(
            currentGrade,
            subject.id,
          );

          return PressableBounce(
            scaleFactor: 0.96,
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
                              const SizedBox(height: 4),
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
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Популярные шпаргалки $currentGrade класса',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  maxLines: 1,
                ),
              ),
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

