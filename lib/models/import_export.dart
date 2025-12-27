import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:converterpro/data/default_order.dart';
import 'package:converterpro/models/currencies.dart';
import 'package:converterpro/models/hide_units.dart';
import 'package:converterpro/models/order.dart';
import 'package:converterpro/models/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImportExportNotifier extends Notifier<void> {
  static final provider =
      NotifierProvider<ImportExportNotifier, void>(ImportExportNotifier.new);

  // List of simple settings providers to iterate over.
  // Using dynamic to allow mixed generic types.
  static final List<dynamic> _simpleSettingsProviders = [
    significantFiguresProvider,
    removeTrailingZerosProvider,
    isPureDarkProvider,
    propertySelectionOnStartupProvider,
    revokeInternetProvider,
    useDeviceColorProvider,
    colorThemeProvider,
    themeModeProvider,
    languageTagProvider,
  ];

  @override
  void build() {}

  /// Exports all settings to a JSON string
  Future<String> exportSettings() async {
    final Map<String, dynamic> exportData = {};

    // 1. Simple settings
    for (final provider in _simpleSettingsProviders) {
      final notifier = ref.read(provider.notifier);
      final key = notifier.prefKey as String;
      final value = await ref.read(provider.future);
      if (value != notifier.defaultValue) {
        exportData[key] = value;
      }
    }

    // 2. Properties Order
    final propertiesOrder =
        await ref.read(PropertiesOrderNotifier.provider.future);
    if (!listEquals(propertiesOrder, defaultPropertiesOrder)) {
      exportData[PropertiesOrderNotifier.storeKey] = propertiesOrder
          .map((e) => e.toString().substring('PROPERTYX.'.length))
          .toList();
    }

    // 3. Units Order & Hidden Units
    final unitsOrderMap = await ref.read(UnitsOrderNotifier.provider.future);
    final hiddenUnitsMap = await ref.read(HiddenUnitsNotifier.provider.future);

    for (final property in defaultPropertiesOrder) {
      // Units Order
      if (!listEquals(unitsOrderMap[property], defaultUnitsOrder[property])) {
        final key =
            ref.read(UnitsOrderNotifier.provider.notifier).storeKey(property);
        exportData[key] =
            unitsOrderMap[property]!.map((e) => e.toString()).toList();
      }

      // Hidden Units
      if (hiddenUnitsMap[property]!.isNotEmpty) {
        final key =
            ref.read(HiddenUnitsNotifier.provider.notifier).storeKey(property);
        exportData[key] =
            hiddenUnitsMap[property]!.map((e) => e.toString()).toList();
      }
    }

    return jsonEncode(exportData);
  }

  /// Imports settings from a JSON string
  /// Returns true if successful, false otherwise
  Future<(String?, List<String>)> importSettings(String jsonString) async {
    String? importError;
    List<String> keysError = [];
    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);

      // 1. Simple settings
      for (final provider in _simpleSettingsProviders) {
        final notifier = ref.read(provider.notifier);
        final key = notifier.prefKey as String;

        if (importData.containsKey(key)) {
          final value = importData[key];
          // Determine the expected type from the notifier's T
          // Since we are using dynamic, we rely on the runtime check of set(T? value)
          // and proper JSON types.
          if (!notifier.set(value)) {
            keysError.add(key);
          }
        }
      }

      // 2. Properties Order
      if (importData.containsKey(PropertiesOrderNotifier.storeKey)) {
        final List<String> loadedList =
            List<String>.from(importData[PropertiesOrderNotifier.storeKey]);
        final currentOrder =
            await ref.read(PropertiesOrderNotifier.provider.future);

        if (currentOrder.length == loadedList.length) {
          final List<int> newIndices = [];
          bool possible = true;
          for (var s in loadedList) {
            final index = currentOrder.indexWhere(
                (p) => p.toString().substring('PROPERTYX.'.length) == s);
            if (index == -1) {
              possible = false;
              break;
            }
            newIndices.add(index);
          }
          if (possible &&
              !ref
                  .read(PropertiesOrderNotifier.provider.notifier)
                  .set(newIndices)) {
            keysError.add(PropertiesOrderNotifier.storeKey);
          }
        }
      }

      // 3. Units Order & Hidden Units
      final unitsOrderMap = await ref.read(UnitsOrderNotifier.provider.future);

      for (final property in defaultPropertiesOrder) {
        // Hidden Units
        final hiddenUnitsKey =
            ref.read(HiddenUnitsNotifier.provider.notifier).storeKey(property);
        if (importData.containsKey(hiddenUnitsKey)) {
          final List<String> loadedList =
              List<String>.from(importData[hiddenUnitsKey]);

          final allUnits = defaultUnitsOrder[property]!;
          final List<dynamic> newHiddenList = loadedList
              .map((s) {
                return allUnits.firstWhereOrNull((u) => u.toString() == s);
              })
              .nonNulls
              .toList();
          if (!ref
              .read(HiddenUnitsNotifier.provider.notifier)
              .set(newHiddenList, property)) {
            keysError.add(hiddenUnitsKey);
          }
        }

        // Units Order
        final unitsOrderKey =
            ref.read(UnitsOrderNotifier.provider.notifier).storeKey(property);
        if (importData.containsKey(unitsOrderKey)) {
          final List<String> loadedList =
              List<String>.from(importData[unitsOrderKey]);
          final currentUnits = unitsOrderMap[property];

          if (currentUnits != null &&
              currentUnits.length == loadedList.length) {
            final List<int> newIndices = [];
            bool possible = true;
            for (var s in loadedList) {
              final index = currentUnits.indexWhere((u) => u.toString() == s);
              if (index == -1) {
                possible = false;
                break;
              }
              newIndices.add(index);
            }
            if (possible &&
                !ref
                    .read(UnitsOrderNotifier.provider.notifier)
                    .set(newIndices, property)) {
              keysError.add(unitsOrderKey);
            }
          }
        }
      }
    } catch (e) {
      importError = e.toString();
    }
    return (importError, keysError);
  }

  void deleteSettings() {
    ref.read(sharedPref.future).then((pref) async {
      await pref.clear();
      for (final provider in _simpleSettingsProviders) {
        ref.invalidate(provider);
      }
      ref.invalidate(PropertiesOrderNotifier.provider);
      ref.invalidate(UnitsOrderNotifier.provider);
      ref.invalidate(HiddenUnitsNotifier.provider);
      ref.invalidate(CurrenciesNotifier.provider);
    });
  }
}
