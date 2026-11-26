import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/topic_model.dart';

class UserPrefsService extends ChangeNotifier {
  static final UserPrefsService _instance = UserPrefsService._internal();
  factory UserPrefsService() => _instance;
  UserPrefsService._internal();

  String _userName = '';
  int _grade = 8;
  // По умолчанию ставим темную тему (Ночной космос)
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
      final localDir = Directory.current.path;
      files.add(File('$localDir/user_settings.json'));
    } catch (_) {}

    return files;
  }

  SharedPreferences? _sp;

  Future<void> init() async {
    bool loadedFromSp = false;
    try {
      try {
        _sp = await SharedPreferences.getInstance();
      } catch (_) {
        // Fallback for widget testing environment without pre-configured mock
        // ignore: invalid_use_of_visible_for_testing_member
        SharedPreferences.setMockInitialValues({});
        _sp = await SharedPreferences.getInstance();
      }

      final sp = _sp!;
      if (sp.containsKey('isOnboarded') || sp.containsKey('userName')) {
        _userName = sp.getString('userName') ?? '';
        _grade = sp.getInt('grade') ?? 8;
        final themeIdx = sp.getInt('theme') ?? AppThemeMode.midnightCyber.index;
        if (themeIdx >= 0 && themeIdx < AppThemeMode.values.length) {
          _themeMode = AppThemeMode.values[themeIdx];
        } else {
          _themeMode = AppThemeMode.midnightCyber;
        }
        final favs = sp.getStringList('favorites');
        if (favs != null) {
          _favorites.clear();
          _favorites.addAll(favs);
        }
        _isOnboarded = sp.getBool('isOnboarded') ?? false;
        loadedFromSp = true;
      }
    } catch (e) {
      debugPrint('Error loading SharedPreferences: $e');
    }

    // Резервная загрузка из локального файла (для десктопа Windows) если в SP пусто
    if (!loadedFromSp && !kIsWeb) {
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
              break;
            }
          }
        }
      } catch (e) {
        debugPrint('Error loading preferences from file fallback: $e');
      }
    }

    notifyListeners();
  }

  Future<void> saveSettings() async {
    // 1. Быстрое сохранение в кэшированный инстанс SharedPreferences
    try {
      _sp ??= await SharedPreferences.getInstance();
      await Future.wait([
        _sp!.setString('userName', _userName),
        _sp!.setInt('grade', _grade),
        _sp!.setInt('theme', _themeMode.index),
        _sp!.setStringList('favorites', _favorites.toList()),
        _sp!.setBool('isOnboarded', _isOnboarded),
      ]);
    } catch (e) {
      debugPrint('Error saving to SharedPreferences: $e');
    }

    // 2. Неблокирующая асинхронная запись в файл на ПК (без синхронного флеша)
    if (!kIsWeb) {
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
          file.writeAsString(jsonStr).catchError((_) => file);
        }
      } catch (e) {
        debugPrint('Error saving preferences to file: $e');
      }
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
