import 'dart:js_interop';

@JS('window')
external WindowExtension get _window;

extension type WindowExtension(JSObject _) implements JSObject {
  external MatchMediaExtension? matchMedia(String query);
  external NavigatorExtension? get navigator;
}

extension type MatchMediaExtension(JSObject _) implements JSObject {
  external bool get matches;
}

extension type NavigatorExtension(JSObject _) implements JSObject {
  external bool? get standalone;
}

/// Проверяет, запущено ли веб-приложение в автономном режиме PWA (display-mode: standalone / fullscreen)
/// или на iOS Safari с флагом navigator.standalone.
bool isWebPwaInstalled() {
  try {
    final win = _window;
    // 1. Проверяем iOS Safari navigator.standalone
    final nav = win.navigator;
    if (nav?.standalone == true) {
      return true;
    }

    // 2. Проверяем CSS media query (display-mode: standalone)
    final mStandalone = win.matchMedia('(display-mode: standalone)');
    if (mStandalone?.matches == true) {
      return true;
    }

    // 3. Проверяем CSS media query (display-mode: fullscreen)
    final mFullscreen = win.matchMedia('(display-mode: fullscreen)');
    if (mFullscreen?.matches == true) {
      return true;
    }

    // 4. Проверяем CSS media query (display-mode: minimal-ui)
    final mMinimal = win.matchMedia('(display-mode: minimal-ui)');
    if (mMinimal?.matches == true) {
      return true;
    }
  } catch (_) {
    // В случае ошибок межъязыкового вызова считаем приложение незапущенным в PWA
  }
  return false;
}
