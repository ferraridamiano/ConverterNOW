import 'package:collection/collection.dart';
import 'package:converterpro/data/default_order.dart';
import 'package:converterpro/models/settings.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HiddenUnitsNotifier extends AsyncNotifier<Map<PROPERTYX, List>> {
  static final provider =
      AsyncNotifierProvider<HiddenUnitsNotifier, Map<PROPERTYX, List>>(
          HiddenUnitsNotifier.new);

  @override
  Future<Map<PROPERTYX, List>> build() async {
    final prefs = await ref.read(sharedPref.future);

    final Map<PROPERTYX, List> newState = {};

    for (final property in defaultPropertiesOrder) {
      final storedList = prefs.getStringList(_storeKey(property));
      final allUnits = defaultUnitsOrder[property]!;
      if (storedList == null) {
        newState[property] = []; // Default to no hidden units
      } else {
        final storedOrder = storedList
            .map(
              (storedString) => allUnits.firstWhereOrNull(
                (unit) => storedString == unit.toString(),
              ),
            )
            .nonNulls
            .cast()
            .toList();
        newState[property] = storedOrder;
      }
    }
    return newState;
  }

  bool set(List hiddenUnits, PROPERTYX property) {
    final allUnits = defaultUnitsOrder[property];
    if (allUnits == null) return false;

    // Check if hiddenUnits are valid for this property
    final allUnitsStrings = allUnits.map((e) => e.toString()).toSet();
    final hiddenUnitsStrings = hiddenUnits.map((e) => e.toString()).toSet();
    if (!allUnitsStrings.containsAll(hiddenUnitsStrings)) {
      return false;
    }

    // Update the state
    final newState = {...state.value!};
    newState[property] = hiddenUnits;
    state = AsyncData(newState);
    // Store the new values
    ref.read(sharedPref.future).then((prefs) {
      if (hiddenUnits.isEmpty) {
        // if there aren't hidden units (all visible), just delete the
        // corresponding value from storage
        prefs.remove(_storeKey(property));
      } else {
        prefs.setStringList(
            _storeKey(property), hiddenUnits.map((e) => e.toString()).toList());
      }
    });
    return true;
  }

  String _storeKey(PROPERTYX property) =>
      'hiddenUnits_${property.toString().substring('PROPERTYX.'.length)}';
}
