import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'install_checker_stub.dart'
    if (dart.library.js_interop) 'install_checker_web.dart' as pwa_check;
import '../widgets/liquid_glass.dart';

/// Проверяет, запущено ли приложение уже как установленное (Standalone PWA или нативная сборка).
/// Возвращает true, если приложение уже установлено / запущено в автономном режиме.
bool isAppAlreadyInstalled() {
  if (kIsWeb) {
    return pwa_check.isWebPwaInstalled();
  }
  // На мобильных (Android, iOS) или десктопных нативных платформах приложение уже установлено
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;
}

/// Определяем платформу — Android или iOS.
/// На iOS (мобильный) предлагаем добавить в «Домой», на Android — Telegram-канал.
enum _DevicePlatform { android, ios, other }

_DevicePlatform _detectPlatform(BuildContext context) {
  final data = Theme.of(context).platform;
  if (data == TargetPlatform.android) return _DevicePlatform.android;
  if (data == TargetPlatform.iOS) return _DevicePlatform.ios;
  return _DevicePlatform.other;
}

/// Показывает диалог «Установите приложение на устройство».
/// Используется как после онбординга, так и в настройках.
Future<void> showInstallAppDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => _InstallAppDialog(platform: _detectPlatform(context)),
  );
}

class _InstallAppDialog extends StatefulWidget {
  final _DevicePlatform platform;
  const _InstallAppDialog({required this.platform});

  @override
  State<_InstallAppDialog> createState() => _InstallAppDialogState();
}

class _InstallAppDialogState extends State<_InstallAppDialog> {
  bool _showIOSInstructions = false;

  Future<void> _openTelegram() async {
    final uri = Uri.parse('https://t.me/classmatte_app');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: LiquidGlassContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: 28,
          opacity: isDark ? 0.88 : 0.94,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Иконка и заголовок
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.phone_android_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Установить приложение',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Хочешь всегда иметь «Классмейт» под рукой?',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),

              // ─── Контент по платформе ─────────────────────────
              if (widget.platform == _DevicePlatform.android) ...[
                _AndroidContent(onOpenTelegram: _openTelegram, theme: theme, isDark: isDark),
              ] else if (widget.platform == _DevicePlatform.ios) ...[
                _IosContent(
                  showInstructions: _showIOSInstructions,
                  onToggleInstructions: () =>
                      setState(() => _showIOSInstructions = !_showIOSInstructions),
                  theme: theme,
                  isDark: isDark,
                ),
              ] else ...[
                _OtherContent(onOpenTelegram: _openTelegram, theme: theme, isDark: isDark),
              ],

              const SizedBox(height: 20),

              // ─── Кнопка «Не сейчас» ────────────────────────────
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                  child: const Text(
                    'Не сейчас',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Android: Telegram-канал ─────────────────────────────────────────────────

class _AndroidContent extends StatelessWidget {
  final VoidCallback onOpenTelegram;
  final ThemeData theme;
  final bool isDark;

  const _AndroidContent({
    required this.onOpenTelegram,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LiquidGlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 18,
          opacity: isDark ? 0.45 : 0.6,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2AABEE).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Color(0xFF2AABEE),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Скачать APK через Telegram',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Перейди в канал @classmatte_app и скачай последнюю версию',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: LiquidGlassButton(
            onPressed: onOpenTelegram,
            backgroundColor: const Color(0xFF2AABEE),
            borderRadius: 14,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, size: 18),
                SizedBox(width: 8),
                Text(
                  'Открыть @classmatte_app',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── iOS: инструкция «Добавить на экран Домой» ───────────────────────────────

class _IosContent extends StatelessWidget {
  final bool showInstructions;
  final VoidCallback onToggleInstructions;
  final ThemeData theme;
  final bool isDark;

  const _IosContent({
    required this.showInstructions,
    required this.onToggleInstructions,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LiquidGlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 18,
          opacity: isDark ? 0.45 : 0.6,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add_box_rounded,
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
                      'Добавить иконку на рабочий стол',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Открой приложение в Safari и добавь его как веб-ярлык',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
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
        SizedBox(
          width: double.infinity,
          child: LiquidGlassButton(
            onPressed: onToggleInstructions,
            backgroundColor: theme.colorScheme.primary,
            borderRadius: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  showInstructions
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.help_outline_rounded,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  showInstructions ? 'Скрыть инструкцию' : 'Как добавить?',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showInstructions) ...[
          const SizedBox(height: 14),
          _IosInstructionSteps(theme: theme, isDark: isDark),
        ],
      ],
    );
  }
}

class _IosInstructionSteps extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;

  const _IosInstructionSteps({required this.theme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final steps = [
      (Icons.language_rounded, 'Открой «Классмейт» в браузере Safari'),
      (Icons.ios_share_rounded, 'Нажми иконку «Поделиться» внизу экрана'),
      (Icons.add_box_outlined, 'Выбери «На экран "Домой"»'),
      (Icons.check_circle_outline_rounded, 'Нажми «Добавить» — готово!'),
    ];

    return LiquidGlassContainer(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      opacity: isDark ? 0.40 : 0.55,
      child: Column(
        children: steps.asMap().entries.map((entry) {
          final i = entry.key;
          final (icon, label) = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: i < steps.length - 1 ? 12 : 0),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(icon, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Other (web/desktop): показываем оба варианта ───────────────────────────

class _OtherContent extends StatelessWidget {
  final VoidCallback onOpenTelegram;
  final ThemeData theme;
  final bool isDark;

  const _OtherContent({
    required this.onOpenTelegram,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LiquidGlassContainer(
          padding: const EdgeInsets.all(14),
          borderRadius: 16,
          opacity: isDark ? 0.45 : 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Row(
                icon: Icons.android_rounded,
                color: const Color(0xFF34A853),
                title: 'Android',
                subtitle: 'Скачай APK через наш Telegram-канал',
              ),
              const SizedBox(height: 12),
              _Row(
                icon: Icons.phone_iphone_rounded,
                color: const Color(0xFF6E6E73),
                title: 'iPhone / iPad',
                subtitle: 'Открой в Safari → Поделиться → На экран «Домой»',
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: LiquidGlassButton(
            onPressed: onOpenTelegram,
            backgroundColor: const Color(0xFF2AABEE),
            borderRadius: 14,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, size: 18),
                SizedBox(width: 8),
                Text(
                  'Открыть Telegram-канал',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _Row({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
