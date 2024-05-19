import 'package:converterpro/styles/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<Locale, String> mapLocale = {
  const Locale('en'): 'English',
  const Locale('ca'): 'Català',
  const Locale('de'): 'Deutsch',
  const Locale('es'): 'Español',
  const Locale('fr'): 'Français',
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

final sharedPref = FutureProvider<SharedPreferences>(
    (_) async => await SharedPreferences.getInstance());

class SignificantFigures extends AsyncNotifier<int> {
  static const _prefKey = 'significant_figures';
  static final provider =
      AsyncNotifierProvider<SignificantFigures, int>(SignificantFigures.new);

  @override
  Future<int> build() async {
    var pref = await ref.watch(sharedPref.future);
    return pref.getInt(_prefKey) ?? 10;
  }

  void set(int value) {
    state = AsyncData(value);
    ref.read(sharedPref.future).then((pref) => pref.setInt(_prefKey, value));
  }
}

class RemoveTrailingZeros extends AsyncNotifier<bool> {
  static const _prefKey = 'remove_trailing_zeros';
  static final provider =
      AsyncNotifierProvider<RemoveTrailingZeros, bool>(RemoveTrailingZeros.new);

  @override
  Future<bool> build() async {
    var pref = await ref.watch(sharedPref.future);
    return pref.getBool(_prefKey) ?? true;
  }

  void set(bool value) {
    state = AsyncData(value);
    ref.read(sharedPref.future).then((pref) => pref.setBool(_prefKey, value));
  }
}

class IsDarkAmoled extends AsyncNotifier<bool> {
  static const _prefKey = 'isDarkAmoled';
  static final provider =
      AsyncNotifierProvider<IsDarkAmoled, bool>(IsDarkAmoled.new);

  @override
  Future<bool> build() async {
    var pref = await ref.watch(sharedPref.future);
    return pref.getBool(_prefKey) ?? true;
  }

  void set(bool value) {
    state = AsyncData(value);
    ref.read(sharedPref.future).then((pref) => pref.setBool(_prefKey, value));
  }
}

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
    return (
      useDeviceColor: pref.getBool(_prefKeyDefault) ?? deafultUseDeviceColor,
      colorTheme: Color(pref.getInt(_prefKeyColor) ?? fallbackColorTheme.value)
    );
  }

  void setDefaultTheme(bool value) {
    state = AsyncData((
      useDeviceColor: value,
      colorTheme: state.valueOrNull?.colorTheme ?? fallbackColorTheme
    ));
    ref
        .read(sharedPref.future)
        .then((pref) => pref.setBool(_prefKeyDefault, value));
  }

  void setColorTheme(Color color) {
    state = AsyncData((
      useDeviceColor:
          state.valueOrNull?.useDeviceColor ?? deafultUseDeviceColor,
      colorTheme: color
    ));
    ref
        .read(sharedPref.future)
        .then((pref) => pref.setInt(_prefKeyColor, color.value));
  }
}

class RevokeInternetNotifier extends AsyncNotifier<bool> {
  static const _prefKey = 'revokeInternet';
  static final provider = AsyncNotifierProvider<RevokeInternetNotifier, bool>(
      RevokeInternetNotifier.new);

  @override
  Future<bool> build() async {
    var pref = await ref.watch(sharedPref.future);
    return pref.getBool(_prefKey) ?? false;
  }

  void set(bool value) {
    state = AsyncData(value);
    ref.read(sharedPref.future).then((pref) => pref.setBool(_prefKey, value));
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
      (element) => element.languageCode == savedLanguageCode,
      orElse: () => const Locale('en'),
    );
  }

  void set(Locale? value) {
    state = AsyncData(value);
    ref.read(sharedPref.future).then((pref) => value == null
        ? pref.remove(_prefKey)
        : pref.setString(_prefKey, value.languageCode));
  }
}
