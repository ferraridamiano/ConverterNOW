import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<Locale, String> mapLocale = {
  const Locale('en'): 'English',
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

final sharedPrefs = FutureProvider<SharedPreferences>(
    (_) async => await SharedPreferences.getInstance());

class SignificantFigures extends StateNotifier<int> {
  SignificantFigures(this.pref) : super(pref?.getInt(prefKey) ?? 10);

  static const prefKey = 'significant_figures';
  final SharedPreferences? pref;
  static final provider = StateNotifierProvider<SignificantFigures, int>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return SignificantFigures(pref);
  });

  void set(int value) {
    state = value;
    pref!.setInt(prefKey, state);
  }
}

class RemoveTrailingZeros extends StateNotifier<bool> {
  RemoveTrailingZeros(this.pref) : super(pref?.getBool(prefKey) ?? true);

  final SharedPreferences? pref;
  static const prefKey = 'remove_trailing_zeros';
  static final provider =
      StateNotifierProvider<RemoveTrailingZeros, bool>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return RemoveTrailingZeros(pref);
  });

  void set(bool value) {
    state = value;
    pref!.setBool(prefKey, state);
  }
}

class IsDarkAmoled extends StateNotifier<bool> {
  IsDarkAmoled(this.pref) : super(pref?.getBool(prefKey) ?? true);

  final SharedPreferences? pref;
  static const prefKey = 'isDarkAmoled';
  static final provider = StateNotifierProvider<IsDarkAmoled, bool>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return IsDarkAmoled(pref);
  });

  void set(bool value) {
    state = value;
    pref!.setBool(prefKey, state);
  }
}

class CurrentThemeMode extends StateNotifier<ThemeMode> {
  CurrentThemeMode(this.pref)
      : super(ThemeMode.values[pref?.getInt(prefKey) ?? 0]);

  static const prefKey = 'currentThemeMode';
  final SharedPreferences? pref;
  static final provider =
      StateNotifierProvider<CurrentThemeMode, ThemeMode>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return CurrentThemeMode(pref);
  });

  void set(ThemeMode value) {
    state = value;
    pref!.setInt(prefKey, ThemeMode.values.indexOf(state));
  }
}

class CurrentLocale extends StateNotifier<Locale?> {
  CurrentLocale(this.pref)
      : super(() {
          var savedLanguageCode = pref?.getString(prefKey);
          if (savedLanguageCode == null) {
            return null;
          }
          return mapLocale.keys.firstWhere(
            (element) => element.languageCode == savedLanguageCode,
            orElse: () => const Locale('en'),
          );
        }());

  static const prefKey = 'locale';
  final SharedPreferences? pref;
  static final provider = StateNotifierProvider<CurrentLocale, Locale?>((ref) {
    final pref = ref.watch(sharedPrefs).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    return CurrentLocale(pref);
  });

  void set(Locale? value) {
    state = value;
    if (state == null) {
      pref!.remove(prefKey);
    } else {
      pref!.setString(prefKey, state!.languageCode);
    }
  }
}
