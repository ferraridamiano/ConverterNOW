import 'dart:ui' show Offset, Size;

import 'package:converterpro/styles/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class AppWindowManager {
  static Future<void> setupWindowPersistence() async {
    windowManager.setPreventClose(true);
    windowManager.addListener(_WindowEventHandler());
    await _restoreWindowPosition();
  }

  static Future<void> _saveWindowSizeAndPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final position = await windowManager.getPosition();
    final size = await windowManager.getSize();

    await prefs.setDouble('window_x', position.dx);
    await prefs.setDouble('window_y', position.dy);
    await prefs.setDouble('window_width', size.width);
    await prefs.setDouble('window_height', size.height);
    windowManager.destroy();
  }

  static Future<void> _restoreWindowPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getDouble('window_x');
    final y = prefs.getDouble('window_y');
    final width = prefs.getDouble('window_width');
    final height = prefs.getDouble('window_height');
    if (x != null && y != null && width != null && height != null) {
      await windowManager.setPosition(Offset(x, y));
      await windowManager.setSize(Size(width, height));
    } else {
      WindowOptions windowOptions = WindowOptions(size: defaultWindowSize, center: true);
      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }
}

class _WindowEventHandler extends WindowListener {
  @override
  void onWindowClose() async {
    await AppWindowManager._saveWindowSizeAndPosition();
  }

  @override
  void onWindowMinimize() {}

  @override
  void onWindowMaximize() {}

  @override
  void onWindowRestore() {}

  @override
  void onWindowMove() {}

  @override
  void onWindowResize() {}
}
