# -*- coding: utf-8 -*-
with open('lib/screens/home_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Add dart:ui import if not present
if "import 'dart:ui';" not in text:
    text = text.replace("import 'package:flutter/material.dart';", "import 'dart:ui';\nimport 'package:flutter/material.dart';", 1)

# 2. Add _buildHeaderActionButton method before build
helper_method = """  Widget _buildHeaderActionButton({
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
  Widget build(BuildContext context) {"""

assert "@override\n  Widget build(BuildContext context) {" in text or "@override\r\n  Widget build(BuildContext context) {" in text
if "@override\r\n  Widget build(BuildContext context) {" in text:
    text = text.replace("@override\r\n  Widget build(BuildContext context) {", helper_method.replace('\n', '\r\n'), 1)
else:
    text = text.replace("@override\n  Widget build(BuildContext context) {", helper_method, 1)

# 3. Replace the AppBar in HomeScreen
old_appbar = """      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: isDark ? 0.90 : 0.94),
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
                          isLabelVisible: prefs.favorites.isNotEmpty,
                          label: Text('${prefs.favorites.length}'),
                          child: Icon(
                            _showFavoritesOnly ? Icons.star_rounded : Icons.star_border_rounded,
                            color: _showFavoritesOnly ? Colors.amber : null,
                          ),
                        ),
                        onPressed: () {
                          setState(() => _showFavoritesOnly = !_showFavoritesOnly);
                        },
                      ),
                      // Установить приложение
                      IconButton(
                        tooltip: 'Установить приложение',
                        icon: const Icon(Icons.install_mobile_rounded),
                        onPressed: () => showInstallAppDialog(context),
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
          ),"""

new_appbar = """      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Container(
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xCC0D1527) : const Color(0xE8FFFFFF)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.10 : 0.04),
                blurRadius: 22,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
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
                          _buildHeaderActionButton(
                            context: context,
                            tooltip: 'Установить приложение',
                            icon: Icon(
                              Icons.install_mobile_rounded,
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
      )"""

if '\r\n' in text:
    old_appbar = old_appbar.replace('\n', '\r\n')
    new_appbar = new_appbar.replace('\n', '\r\n')

assert old_appbar in text, 'old_appbar not found'
text = text.replace(old_appbar, new_appbar, 1)

# 4. Wrap subject card with PressableBounce
old_subject_card = """          return InkWell(
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
            child: Container("""

new_subject_card = """          return PressableBounce(
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
            child: Container("""

if '\r\n' in text:
    old_subject_card = old_subject_card.replace('\n', '\r\n')
    new_subject_card = new_subject_card.replace('\n', '\r\n')

assert old_subject_card in text, 'old_subject_card not found'
text = text.replace(old_subject_card, new_subject_card, 1)

with open('lib/screens/home_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print('Updated lib/screens/home_screen.dart successfully!')
