import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/topic_model.dart';

class UserPrefsService extends ChangeNotifier {
  static final UserPrefsService _instance = UserPrefsService._internal();
  factory UserPrefsService() => _instance;
  UserPrefsService._internal();

  String _userName = '';
  int _grade = 8;
  // По умолчанию ставим темную тему (Ночной космос), как просил пользователь
  AppThemeMode _themeMode = AppThemeMode.midnightCyber;
  final Set<String> _favorites = {};
  bool _isOnboarded = false;

  String get userName => _userName;
  int get grade => _grade;
  AppThemeMode get themeMode => _themeMode;
  Set<String> get favorites => Set.unmodifiable(_favorites);
  bool get isOnboarded => _isOnboarded;

  List<File> _getTargetFiles() {
    if (kIsWeb) return [];
    final files = <File>[];
    try {
      // 1. Папка APPDATA в Windows (наиболее надежное сохранение между перезапусками)
      final appData = Platform.environment['APPDATA'];
      if (appData != null && appData.isNotEmpty) {
        final dir = Directory('$appData/ClassMateApp');
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
        files.add(File('${dir.path}/user_settings.json'));
      }
    } catch (_) {}

    try {
      // 2. Локальная папка проекта / рабочей директории
      final localDir = Directory.current.path;
      files.add(File('$localDir/user_settings.json'));
    } catch (_) {}

    return files;
  }

  Future<void> init() async {
    if (kIsWeb) {
      _themeMode = AppThemeMode.midnightCyber;
      return;
    }

    try {
      final targets = _getTargetFiles();
      for (final file in targets) {
        if (await file.exists()) {
          final content = await file.readAsString();
          if (content.trim().isNotEmpty) {
            final map = jsonDecode(content) as Map<String, dynamic>;
            _userName = map['userName']?.toString() ?? '';
            _grade = (map['grade'] as num?)?.toInt() ?? 8;
            final themeIdx = (map['theme'] as num?)?.toInt() ?? AppThemeMode.midnightCyber.index;
            if (themeIdx >= 0 && themeIdx < AppThemeMode.values.length) {
              _themeMode = AppThemeMode.values[themeIdx];
            } else {
              _themeMode = AppThemeMode.midnightCyber;
            }
            if (map['favorites'] is List) {
              _favorites.clear();
              for (final f in map['favorites']) {
                _favorites.add(f.toString());
              }
            }
            _isOnboarded = map['isOnboarded'] == true;
            break; // успешно загрузили из первого найденного файла
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
    notifyListeners();
  }

  Future<void> saveSettings() async {
    if (kIsWeb) return;

    try {
      final map = {
        'userName': _userName,
        'grade': _grade,
        'theme': _themeMode.index,
        'favorites': _favorites.toList(),
        'isOnboarded': _isOnboarded,
      };
      final jsonStr = jsonEncode(map);
      final targets = _getTargetFiles();
      for (final file in targets) {
        try {
          await file.writeAsString(jsonStr, flush: true);
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('Error saving preferences: $e');
    }
  }

  void completeOnboarding({required String name, required int grade, required AppThemeMode theme}) {
    _userName = name.trim().isEmpty ? 'Ученик' : name.trim();
    _grade = grade;
    _themeMode = theme;
    _isOnboarded = true;
    saveSettings();
    notifyListeners();
  }

  void updateName(String newName) {
    _userName = newName.trim();
    saveSettings();
    notifyListeners();
  }

  void updateGrade(int newGrade) {
    if (newGrade >= 5 && newGrade <= 11) {
      _grade = newGrade;
      saveSettings();
      notifyListeners();
    }
  }

  void updateTheme(AppThemeMode newTheme) {
    _themeMode = newTheme;
    saveSettings();
    notifyListeners();
  }

  void toggleFavorite(String topicId) {
    if (_favorites.contains(topicId)) {
      _favorites.remove(topicId);
    } else {
      _favorites.add(topicId);
    }
    saveSettings();
    notifyListeners();
  }

  bool isFavorite(String topicId) => _favorites.contains(topicId);
}
