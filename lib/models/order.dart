import 'package:converterpro/models/properties_list.dart';
import 'package:converterpro/models/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PropertiesOrderNotifier extends AsyncNotifier<List<int>> {
  static final provider =
      AsyncNotifierProvider<PropertiesOrderNotifier, List<int>>(
          PropertiesOrderNotifier.new);

  @override
  Future<List<int>> build() async {
    List<int> temp = List.generate(19, (index) => index);
    List<String>? stringList =
        (await ref.read(sharedPrefs.future)).getStringList('orderDrawer');
    if (stringList != null) {
      final int len = stringList.length;
      for (int i = 0; i < len; i++) {
        temp[i] = int.parse(stringList[i]);
      }
      // If new units of measurement will be added, the following 2
      // lines of code ensure that everything will works fine
      for (int i = len; i < temp.length; i++) {
        temp[i] = i;
      }
    }
    return temp;
  }

  void set(List<int> newOrder) async {
    List<int> orderDrawer = List<int>.from(state.value!);
    List arrayCopy = List.filled(orderDrawer.length, null);
    for (int i = 0; i < orderDrawer.length; i++) {
      arrayCopy[i] = orderDrawer[i];
    }
    for (int i = 0; i < orderDrawer.length; i++) {
      orderDrawer[i] = newOrder.indexOf(arrayCopy[i]);
    }
    state = AsyncData(orderDrawer);
    // Save new orders to storage
    List<String> toConvertList = [];
    for (int item in orderDrawer) {
      toConvertList.add(item.toString());
    }
    (await ref.read(sharedPrefs.future))
        .setStringList('orderDrawer', toConvertList);
  }
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

    var prefs = await ref.read(sharedPrefs.future);
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
      (await ref.read(sharedPrefs.future))
          .setStringList("conversion_$pageNumber", toConvertList);
    }
  }

  List<List<int>> _copyState() =>
      state.value!.map((subList) => List<int>.from(subList)).toList();
}
