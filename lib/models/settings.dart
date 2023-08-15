import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
