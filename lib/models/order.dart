import 'package:collection/collection.dart';
import 'package:converterpro/data/default_order.dart';
import 'package:converterpro/models/properties_list.dart';
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
            (storedString) => PROPERTYX.values.firstWhereOrNull(
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

  void set(List<int> newOrder) async {
    final propertiesOrder =
        newOrder.map((e) => defaultPropertiesOrder[e]).toList();
    // Update the state
    state = AsyncData(propertiesOrder);
    // Store the new values
    (await ref.read(sharedPref.future))
        .setStringList(storeKey, _toStorableString(propertiesOrder));
  }

  List<String> _toStorableString(List<PROPERTYX> listToConvert) => listToConvert
      .map((e) => e.toString().substring('PROPERTYX.'.length))
      .toList();
}

extension ReversedPropertiesOrdering on List<PROPERTYX> {
  Map<PROPERTYX, int> inverse() =>
      Map.fromEntries(indexed.map((e) => MapEntry(e.$2, e.$1)));
}

class UnitsOrderNotifier extends AsyncNotifier<List<List<int>>> {
  static final provider =
      AsyncNotifierProvider<UnitsOrderNotifier, List<List<int>>>(
          UnitsOrderNotifier.new);

  @override
  Future<List<List<int>>> build() async {
    // Initialize the order for each property to default:
    // [0,1,2,...,size(property)]
    var propertyList = await ref.read(propertiesListProvider.future);
    List<List<int>> temp = [];
    for (var property in propertyList) {
      temp.add(List.generate(property.size, (index) => index));
    }

    var prefs = await ref.read(sharedPref.future);
    List<String>? stringList;
    // Update every order of every conversion
    for (int i = 0; i < propertyList.length; i++) {
      stringList = prefs.getStringList('conversion_$i');
      if (stringList != null) {
        // If some units has been removed, adapt the reordering and save it.
        // It is triggered just the first time after an update
        if (propertyList[i].size < stringList.length) {
          stringList.removeWhere(
              (element) => int.tryParse(element)! >= propertyList[i].size);
          prefs.setStringList('conversion_$i', stringList);
        }

        final int len = stringList.length;
        List<int> intList = [];
        for (int j = 0; j < len; j++) {
          intList.add(int.parse(stringList[j]));
        }
        // solves the problem of adding new units after an update
        for (int j = len; j < temp[i].length; j++) {
          intList.add(j);
        }
        temp[i] = intList;
      }
    }
    return temp;
  }

  void set(List<int>? newOrder, int pageNumber) async {
    assert(newOrder == null
        ? true
        : newOrder.length == state.value![pageNumber].length);
    // if there aren't any changes, do nothing
    if (newOrder != null) {
      List<int?> arrayCopy = List.filled(state.value![pageNumber].length, null);
      for (int i = 0; i < state.value![pageNumber].length; i++) {
        arrayCopy[i] = state.value![pageNumber][i];
      }
      var stateCopy = _copyState();
      for (int i = 0; i < state.value![pageNumber].length; i++) {
        stateCopy[pageNumber][i] = newOrder.indexOf(arrayCopy[i]!);
      }
      state = AsyncData(stateCopy);
      // Save to storage
      List<String> toConvertList = [];
      for (int item in stateCopy[pageNumber]) {
        toConvertList.add(item.toString());
      }
      (await ref.read(sharedPref.future))
          .setStringList("conversion_$pageNumber", toConvertList);
    }
  }

  List<List<int>> _copyState() =>
      state.value!.map((subList) => List<int>.from(subList)).toList();
}
