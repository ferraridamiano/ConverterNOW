import 'package:collection/collection.dart';
import 'package:converterpro/data/default_order.dart';
import 'package:converterpro/models/settings.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertiesOrderNotifier extends AsyncNotifier<List<PROPERTYX>> {
  static final provider =
      AsyncNotifierProvider<PropertiesOrderNotifier, List<PROPERTYX>>(
          PropertiesOrderNotifier.new);

  static const storeKey = 'propertiesOrder';

  @override
  Future<List<PROPERTYX>> build() async {
    List<String>? storedList =
        (await ref.read(sharedPref.future)).getStringList(storeKey);
    if (storedList != null) {
      final newState = storedList
          .map(
            (storedString) => defaultPropertiesOrder.firstWhereOrNull(
              (property) =>
                  storedString ==
                  property.toString().substring('PROPERTYX.'.length),
            ),
          )
          .nonNulls
          .toList();
      // If there are different properties in the two lists
      if (newState.length != defaultPropertiesOrder.length) {
        newState.addAll(
            defaultPropertiesOrder.toSet().difference(newState.toSet()));
        (await ref.read(sharedPref.future))
            .setStringList(storeKey, _toStorableString(newState));
      }
      return newState;
    }
    return defaultPropertiesOrder;
  }

  bool set(List<int> newOrder) {
    final currentOrdering = state.value;
    if (currentOrdering == null) {
      return false;
    }
    // Check if newOrder contains all numbers from 0 to length - 1
    final Set<int> expectedSet =
        List.generate(currentOrdering.length, (i) => i).toSet();
    if (newOrder.length != currentOrdering.length ||
        !newOrder.toSet().containsAll(expectedSet)) {
      return false;
    }

    final propertiesOrder = newOrder.map((e) => currentOrdering[e]).toList();
    // Update the state
    state = AsyncData(propertiesOrder);
    // Store the new values
    ref.read(sharedPref.future).then((prefs) {
      prefs.setStringList(storeKey, _toStorableString(propertiesOrder));
    });
    return true;
  }

  List<String> _toStorableString(List<PROPERTYX> listToConvert) => listToConvert
      .map((e) => e.toString().substring('PROPERTYX.'.length))
      .toList();
}

extension ReversedPropertiesOrdering on List<PROPERTYX> {
  Map<PROPERTYX, int> inverse() =>
      Map.fromEntries(indexed.map((e) => MapEntry(e.$2, e.$1)));
}

class UnitsOrderNotifier extends AsyncNotifier<Map<PROPERTYX, List>> {
  static final provider =
      AsyncNotifierProvider<UnitsOrderNotifier, Map<PROPERTYX, List>>(
          UnitsOrderNotifier.new);

  @override
  Future<Map<PROPERTYX, List>> build() async {
    var prefs = await ref.read(sharedPref.future);

    final Map<PROPERTYX, List> newState = {};

    for (final property in defaultPropertiesOrder) {
      final storedList = prefs.getStringList(storeKey(property));
      final defaultOrder = defaultUnitsOrder[property]!;
      if (storedList == null) {
        newState[property] = defaultOrder;
      } else {
        final storedOrder = storedList
            .map(
              (storedString) => defaultOrder.firstWhereOrNull(
                (unit) => storedString == unit.toString(),
              ),
            )
            .nonNulls
            .cast()
            .toList();
        // Add missing units
        if (storedOrder.length != defaultOrder.length) {
          storedOrder
              .addAll(defaultOrder.toSet().difference(storedOrder.toSet()));
          (await ref.read(sharedPref.future)).setStringList(
              storeKey(property), _toStorableString(storedOrder));
        }
        newState[property] = storedOrder;
      }
    }
    return newState;
  }

  bool set(List<int>? newOrder, PROPERTYX property) {
    final currentState = state.value;
    if (newOrder == null || currentState == null) {
      return false;
    }
    final currentUnitsProperty = currentState[property];
    if (currentUnitsProperty == null) return false;

    // Check if newOrder contains all numbers from 0 to length - 1
    final Set<int> expectedSet =
        List.generate(currentUnitsProperty.length, (i) => i).toSet();
    if (newOrder.length != currentUnitsProperty.length ||
        !newOrder.toSet().containsAll(expectedSet)) {
      return false;
    }

    final unitsOrder = newOrder.map((e) => currentUnitsProperty[e]).toList();
    // Update the state
    final newState = {...currentState};
    newState[property] = unitsOrder;
    state = AsyncData(newState);
    // Store the new values
    ref.read(sharedPref.future).then((prefs) {
      prefs.setStringList(storeKey(property), _toStorableString(unitsOrder));
    });
    return true;
  }

  String storeKey(PROPERTYX property) =>
      'unitsOrder_${property.toString().substring('PROPERTYX.'.length)}';

  List<String> _toStorableString(List listToConvert) =>
      listToConvert.map((e) => e.toString()).toList();
}
