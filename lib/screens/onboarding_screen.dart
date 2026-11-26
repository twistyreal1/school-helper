import 'package:flutter/material.dart';
import '../models/topic_model.dart';
import '../widgets/install_app_dialog.dart';
import '../services/user_prefs_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/page_transitions.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isEditing;

  const OnboardingScreen({
    super.key,
    this.isEditing = false,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late TextEditingController _nameController;
  late int _selectedGrade;
  late AppThemeMode _selectedTheme;

  @override
  void initState() {
    super.initState();
    final prefs = UserPrefsService();
    _nameController = TextEditingController(
      text: widget.isEditing ? prefs.userName : '',
    );
    _selectedGrade = widget.isEditing ? prefs.grade : 8;
    _selectedTheme = widget.isEditing ? prefs.themeMode : AppThemeMode.midnightCyber;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _finishSetup() {
    final prefs = UserPrefsService();
    final name = _nameController.text.trim().isEmpty ? 'Друг' : _nameController.text.trim();
    prefs.completeOnboarding(
      name: name,
      grade: _selectedGrade,
      theme: _selectedTheme,
    );

    if (widget.isEditing) {
      Navigator.of(context).maybePop();
    } else {
      if (isAppAlreadyInstalled()) {
        Navigator.of(context).pushReplacement(
          createOnboardingToHomeRoute(const HomeScreen()),
        );
      } else {
        _showInstallPromptOrProceed();
      }
    }
  }

  void _showInstallPromptOrProceed() {
    showInstallAppDialog(context).then((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        createOnboardingToHomeRoute(const HomeScreen()),
      );
    });
  }

  void _goToNextPage() {
    if (_currentPage < 2) {
      final next = _currentPage + 1;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _currentPage = next);
    } else {
      _finishSetup();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      final prev = _currentPage - 1;
      _pageController.animateToPage(
        prev,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
      setState(() => _currentPage = prev);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: LiquidGlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Верхняя навигационная панель с жидким индикатором
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Кнопка назад / закрыть
                    if (_currentPage > 0 || widget.isEditing)
                      IconButton(
                        onPressed: _currentPage > 0
                            ? _goToPreviousPage
                            : () => Navigator.of(context).maybePop(),
                        icon: Icon(
                          widget.isEditing && _currentPage == 0
                              ? Icons.close_rounded
                              : Icons.arrow_back_ios_new_rounded,
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                        ),
                      )
                    else
                      const SizedBox(width: 44),

                    // Индикатор шагов (Liquid Step Dots)
                    Row(
                      children: List.generate(3, (index) {
                        final isActive = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                        );
                      }),
                    ),

                    // Кнопка "Пропустить" для быстрого старта
                    if (!widget.isEditing && _currentPage < 2)
                      TextButton(
                        onPressed: _finishSetup,
                        child: Text(
                          'Пропустить',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 60),
                  ],
                ),
              ),

              // Основное содержимое экранов онбординга
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    _buildWelcomeStep(theme, isDark),
                    _buildProfileStep(theme, isDark),
                    _buildThemeStep(theme, isDark),
                  ],
                ),
              ),

              // Нижняя панель с кнопкой действия
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: LiquidGlassButton(
                    onPressed: _goToNextPage,
                    backgroundColor: theme.colorScheme.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == 2
                              ? (widget.isEditing ? 'Сохранить настройки' : 'Начать учиться')
                              : (_currentPage == 0 ? 'Настроить под себя' : 'Выбрать тему'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentPage == 2
                              ? Icons.rocket_launch_rounded
                              : Icons.arrow_forward_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ШАГ 1: Приветствие и знакомство с возможностями ---
  Widget _buildWelcomeStep(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Логотип с сиянием
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: isDark ? 0.35 : 0.2),
                          theme.colorScheme.primary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  const AppLogo(size: 84, hasShadow: true),
                ],
              ),
              const SizedBox(height: 20),

              // Бейдж Liquid Glass
              LiquidGlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                borderRadius: 20,
                opacity: isDark ? 0.5 : 0.7,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 15,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Твой умный карманный помощник',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Text(
                'Классмейт',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Все формулы, понятия и чертежи школьной программы 5–11 классов в одном удобном приложении.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 24),

              // Карточки ключевых преимуществ в стиле Liquid Glass
              _buildFeatureItem(
                theme: theme,
                isDark: isDark,
                icon: Icons.square_foot_rounded,
                iconColor: const Color(0xFF3B82F6),
                title: 'Алгебра и Геометрия',
                subtitle: 'Все теоремы, свойства и интерактивные векторные 2D чертежи',
              ),
              const SizedBox(height: 10),
              _buildFeatureItem(
                theme: theme,
                isDark: isDark,
                icon: Icons.science_rounded,
                iconColor: const Color(0xFF10B981),
                title: 'Физика и Естественные науки',
                subtitle: 'Законы, единицы измерения, биологические системы и строение клетки',
              ),
              const SizedBox(height: 10),
              _buildFeatureItem(
                theme: theme,
                isDark: isDark,
                icon: Icons.menu_book_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: 'Гуманитарный блок',
                subtitle: 'История по векам, география России и мира, разборы произведений',
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required ThemeData theme,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return LiquidGlassContainer(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      opacity: isDark ? 0.55 : 0.70,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.3,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- ШАГ 2: Персонализация (Имя и Класс) ---
  Widget _buildProfileStep(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Шаг 1 из 2',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Давай настроим твой профиль',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Материалы автоматически подстроятся под твой текущий класс.',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 20),

              // Поле ввода имени в Liquid Glass
              LiquidGlassCard(
                borderRadius: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Как тебя зовут?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'Введи свое имя или никнейм',
                        filled: true,
                        fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Быстрые подсказки имён
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: ['Друг', 'Отличник', 'Студент', 'Мастер формул'].map((suggest) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _nameController.text = suggest;
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Text(
                              suggest,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Выбор класса
              LiquidGlassCard(
                borderRadius: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.school_rounded,
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Твой класс:',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '$_selectedGrade класс',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Сетка выбора классов 5–11 с описанием ступеней
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.35,
                      ),
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final grade = index + 5;
                        final isSelected = grade == _selectedGrade;
                        return InkWell(
                          onTap: () => setState(() => _selectedGrade = grade),
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.05),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.4)
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: theme.colorScheme.primary.withValues(alpha: 0.45),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$grade',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'класс',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.85)
                                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // Пояснение для выбранной ступени
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getGradeDescription(_selectedGrade),
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGradeDescription(int grade) {
    if (grade <= 6) {
      return '$grade класс: фундамент школьной программы, базовые правила и формулы.';
    } else if (grade <= 9) {
      return '$grade класс: углубленная программа и подготовка к ОГЭ.';
    } else {
      return '$grade класс: старшая школа, профильные темы и подготовка к ЕГЭ.';
    }
  }

  // --- ШАГ 3: Выбор темы оформления (Liquid Glass Themes) ---
  Widget _buildThemeStep(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Шаг 2 из 2',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Выбери свой стиль',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Тема оформления подстраивается под твой выбор:',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 20),

              // Список тем оформления
              Column(
                children: AppThemeMode.values.map((themeMode) {
                  final isChosen = themeMode == _selectedTheme;
                  final themeColor = _getThemeColor(themeMode);
                  final accentColor = _getThemeAccentColor(themeMode);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: LiquidGlassContainer(
                      borderRadius: 20,
                      onTap: () {
                        setState(() => _selectedTheme = themeMode);
                        UserPrefsService().updateTheme(themeMode);
                      },
                      border: Border.all(
                        color: isChosen
                            ? themeColor
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.white.withValues(alpha: 0.6)),
                        width: isChosen ? 2.2 : 1.2,
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                        if (isChosen)
                          BoxShadow(
                            color: themeColor.withValues(alpha: 0.35),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                      ],
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          // Иконка темы
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  themeColor,
                                  accentColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: themeColor.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              themeMode.icon,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Название и описание
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  themeMode.displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  themeMode.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Кружки цветов темы
                          Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: themeColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),

                          // Индикатор выбора
                          Icon(
                            isChosen
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isChosen
                                ? themeColor
                                : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 8),

              // Итоговая карточка готовности
              LiquidGlassCard(
                borderRadius: 18,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameController.text.trim().isEmpty
                                ? 'Всё готово для учебы!'
                                : 'Привет, ${_nameController.text.trim()}!',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Твой профиль: $_selectedGrade класс. Настройки можно изменить в любой момент.',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
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

  Color _getThemeAccentColor(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.modernBlue:
        return const Color(0xFF0284C7);
      case AppThemeMode.midnightCyber:
        return const Color(0xFF38BDF8);
      case AppThemeMode.emeraldMatcha:
        return const Color(0xFF10B981);
      case AppThemeMode.warmNotebook:
        return const Color(0xFFEA580C);
    }
  }
}
