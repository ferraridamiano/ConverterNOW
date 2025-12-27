import 'dart:ui';
import 'package:converterpro/styles/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<Locale, String> mapLocale = {
  const Locale('en'): 'English',
  const Locale('bn'): 'বাংলা',
  const Locale('ca'): 'Català',
  const Locale('de'): 'Deutsch',
  const Locale('es'): 'Español',
  const Locale('fr'): 'Français',
  const Locale('el'): 'Ελληνικά',
  const Locale('hr'): 'Hrvatski',
  const Locale('id'): 'Bahasa Indonesia',
  const Locale('it'): 'Italiano',
  const Locale('ja'): '日本語',
  const Locale('nb'): 'Norsk',
  const Locale('nl'): 'Nederlands',
  const Locale('pl'): 'Polski',
  const Locale('pt'): 'Português',
  const Locale('ru'): 'Pусский',
  const Locale('tr'): 'Türkçe',
  const Locale('ar'): 'العربية',
  const Locale('zh'): '中文',
  const Locale('zh', 'TW'): '中文 (台灣)',
};

final sharedPref = FutureProvider<SharedPreferencesWithCache>((_) async =>
    await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions()));

class SettingsNotifier<T> extends AsyncNotifier<T?> {
  late final String prefKey;
  late final T? defaultValue;
  late final bool Function(T?) validate;

  // Returns true if the validation succeded, false otherwise
  bool set(T? value) {
    if (!validate(value)) {
      return false;
    }
    state = AsyncData(value);
    if (value == null || value == defaultValue) {
      ref.read(sharedPref.future).then((pref) => pref.remove(prefKey));
    } else {
      ref.read(sharedPref.future).then((pref) {
        if (value is int) {
          pref.setInt(prefKey, value);
        } else if (value is bool) {
          pref.setBool(prefKey, value);
        } else if (value is String) {
          pref.setString(prefKey, value);
        } else if (value is double) {
          pref.setDouble(prefKey, value);
        } else {
          throw UnimplementedError('Type ${T.toString()} not supported');
        }
      });
    }
    return true;
  }

  @override
  Future<T?> build() async {
    var pref = await ref.watch(sharedPref.future);
    return pref.get(prefKey) as T? ?? defaultValue;
  }
}

final significantFiguresProvider =
    AsyncNotifierProvider<SettingsNotifier<int?>, int?>(() {
  return SettingsNotifier<int?>()
    ..prefKey = 'significant_figures'
    ..defaultValue = 10
    ..validate = (val) => val != null && val > 0 && val <= 16;
});

final removeTrailingZerosProvider =
    AsyncNotifierProvider<SettingsNotifier<bool?>, bool?>(() {
  return SettingsNotifier<bool>()
    ..prefKey = 'remove_trailing_zeros'
    ..defaultValue = true
    ..validate = (val) => val != null;
});

final isPureDarkProvider =
    AsyncNotifierProvider<SettingsNotifier<bool?>, bool?>(() {
  return SettingsNotifier<bool>()
    ..prefKey = 'isDarkAmoled'
    ..defaultValue = false
    ..validate = (val) => val != null;
});

final propertySelectionOnStartupProvider =
    AsyncNotifierProvider<SettingsNotifier<bool?>, bool?>(() {
  return SettingsNotifier<bool>()
    ..prefKey = 'propertySelectionOnStartup'
    ..defaultValue = true
    ..validate = (val) => val != null;
});

final revokeInternetProvider =
    AsyncNotifierProvider<SettingsNotifier<bool?>, bool?>(() {
  return SettingsNotifier<bool>()
    ..prefKey = 'revokeInternet'
    ..defaultValue = false
    ..validate = (val) => val != null;
});

final useDeviceColorProvider =
    AsyncNotifierProvider<SettingsNotifier<bool?>, bool?>(() {
  return SettingsNotifier<bool>()
    ..prefKey = 'useDeviceColor'
    // Here we set default theme to fallbackColorTheme (it is easier to support
    // device that does not have a color accent)
    ..defaultValue = false
    ..validate = (val) => val != null;
});

final colorThemeProvider =
    AsyncNotifierProvider<SettingsNotifier<int?>, int?>(() {
  return SettingsNotifier<int>()
    ..prefKey = 'colorTheme'
    ..defaultValue = fallbackColorTheme.toARGB32()
    ..validate = (val) => val != null && val > 0 && val <= 0xFFFFFFFF;
});

/// `null` means no accent color
final deviceAccentColorProvider = StateProvider<Color?>((ref) => null);

final actualColorThemeProvider = Provider<Color>((ref) {
  final useDeviceColor = ref.watch(useDeviceColorProvider).value ?? false;
  final colorTheme = ref.watch(colorThemeProvider).value;
  final deviceAccentColor = ref.watch(deviceAccentColorProvider);

  return useDeviceColor
      ? deviceAccentColor ?? fallbackColorTheme
      : colorTheme != null
          ? Color(colorTheme)
          : fallbackColorTheme;
});

final themeModeProvider =
    AsyncNotifierProvider<SettingsNotifier<int?>, int?>(() {
  return SettingsNotifier<int>()
    ..prefKey = 'currentThemeMode'
    ..defaultValue = ThemeMode.system.index
    ..validate =
        (val) => val != null && val >= 0 && val < ThemeMode.values.length;
});

final languageTagProvider =
    AsyncNotifierProvider<SettingsNotifier<String?>, String?>(() {
  return SettingsNotifier<String>()
    ..prefKey = 'locale'
    ..defaultValue = null
    ..validate = (val) =>
        val == null || mapLocale.keys.any((e) => e.toLanguageTag() == val);
});

final actualLocaleProvider = Provider<Locale?>((ref) {
  final languageTag = ref.watch(languageTagProvider).value;

  if (languageTag == null) {
    final deviceLocaleTag = PlatformDispatcher.instance.locale.toLanguageTag();
    final isSupported =
        mapLocale.keys.any((l) => l.toLanguageTag() == deviceLocaleTag);
    return isSupported ? Locale(deviceLocaleTag) : fallbackLocale;
  }
  return languageTagToLocale(languageTag);
});

Locale languageTagToLocale(String languageTag) {
  return mapLocale.keys.firstWhere(
    (e) => e.toLanguageTag() == languageTag,
    orElse: () => fallbackLocale,
  );
}
