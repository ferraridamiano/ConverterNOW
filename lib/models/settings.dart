import 'package:converterpro/styles/consts.dart';
import 'package:converterpro/utils/utils.dart';
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

class SettingsNotifier<T> extends AsyncNotifier<T> {
  late final String prefKey;
  late final T defaultValue;

  void set(T value) {
    state = AsyncData(value);
    ref.read(sharedPref.future).then((pref) {
      switch (T) {
        case const (int):
          pref.setInt(prefKey, value as int);
          break;
        case const (bool):
          pref.setBool(prefKey, value as bool);
          break;
        case const (String):
          pref.setString(prefKey, value as String);
          break;
        case const (double):
          pref.setDouble(prefKey, value as double);
          break;
        default:
          throw UnimplementedError('Type not supported');
      }
    });
  }

  @override
  Future<T> build() async {
    var pref = await ref.watch(sharedPref.future);
    return pref.get(prefKey) as T? ?? defaultValue;
  }
}

final significantFiguresProvider =
    AsyncNotifierProvider<SettingsNotifier<int>, int>(() {
  return SettingsNotifier<int>()
    ..prefKey = 'significant_figures'
    ..defaultValue = 10;
});

final removeTrailingZerosProvider =
    AsyncNotifierProvider<SettingsNotifier<bool>, bool>(() {
  return SettingsNotifier<bool>()
    ..prefKey = 'remove_trailing_zeros'
    ..defaultValue = true;
});

final isPureDarkProvider =
    AsyncNotifierProvider<SettingsNotifier<bool>, bool>(() {
  return SettingsNotifier<bool>()
    ..prefKey = 'isDarkAmoled'
    ..defaultValue = false;
});

final propertySelectionOnStartupProvider =
    AsyncNotifierProvider<SettingsNotifier<bool>, bool>(() {
  return SettingsNotifier<bool>()
    ..prefKey = 'propertySelectionOnStartup'
    ..defaultValue = true;
});

final revokeInternetProvider =
    AsyncNotifierProvider<SettingsNotifier<bool>, bool>(() {
  return SettingsNotifier<bool>()
    ..prefKey = 'revokeInternet'
    ..defaultValue = false;
});

/// `null` means no accent color
final deviceAccentColorProvider = StateProvider<Color?>((ref) => null);

class ThemeColorNotifier
    extends AsyncNotifier<({bool useDeviceColor, Color colorTheme})> {
  static const _prefKeyDefault = 'useDeviceColor';
  static const _prefKeyColor = 'colorTheme';
  // Here we set default theme to fallbackColorTheme (it is easier to support
  // device that does not have a color accent)
  static const deafultUseDeviceColor = false;

  static final provider = AsyncNotifierProvider<ThemeColorNotifier,
      ({bool useDeviceColor, Color colorTheme})>(ThemeColorNotifier.new);

  @override
  Future<({bool useDeviceColor, Color colorTheme})> build() async {
    var pref = await ref.watch(sharedPref.future);
    final prefColor = pref.getInt(_prefKeyColor);
    return (
      useDeviceColor: pref.getBool(_prefKeyDefault) ?? deafultUseDeviceColor,
      colorTheme: prefColor != null ? Color(prefColor) : fallbackColorTheme,
    );
  }

  void setDefaultTheme(bool value) {
    state = AsyncData((
      useDeviceColor: value,
      colorTheme: state.value?.colorTheme ?? fallbackColorTheme
    ));
    ref
        .read(sharedPref.future)
        .then((pref) => pref.setBool(_prefKeyDefault, value));
  }

  void setColorTheme(Color color) {
    state = AsyncData((
      useDeviceColor: state.value?.useDeviceColor ?? deafultUseDeviceColor,
      colorTheme: color
    ));
    ref
        .read(sharedPref.future)
        .then((pref) => pref.setInt(_prefKeyColor, color2Int(color)));
  }
}

class CurrentThemeMode extends AsyncNotifier<ThemeMode> {
  static const _prefKey = 'currentThemeMode';
  static final provider =
      AsyncNotifierProvider<CurrentThemeMode, ThemeMode>(CurrentThemeMode.new);

  @override
  Future<ThemeMode> build() async {
    var pref = await ref.watch(sharedPref.future);
    return ThemeMode.values[pref.getInt(_prefKey) ?? 0];
  }

  void set(ThemeMode value) {
    state = AsyncData(value);
    ref
        .read(sharedPref.future)
        .then((pref) => pref.setInt(_prefKey, ThemeMode.values.indexOf(value)));
  }
}

class CurrentLocale extends AsyncNotifier<Locale?> {
  static const _prefKey = 'locale';
  static final provider =
      AsyncNotifierProvider<CurrentLocale, Locale?>(CurrentLocale.new);

  @override
  Future<Locale?> build() async {
    var pref = await ref.watch(sharedPref.future);

    var savedLanguageCode = pref.getString(_prefKey);
    if (savedLanguageCode == null) {
      return null;
    }
    return mapLocale.keys.firstWhere(
      (element) => element.toLanguageTag() == savedLanguageCode,
      orElse: () => const Locale('en'),
    );
  }

  void set(Locale? value) {
    state = AsyncData(value);
    ref.read(sharedPref.future).then((pref) => value == null
        ? pref.remove(_prefKey)
        : pref.setString(_prefKey, value.toLanguageTag()));
  }
}
