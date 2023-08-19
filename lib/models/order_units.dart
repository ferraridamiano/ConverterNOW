import 'package:converterpro/models/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderNotifier extends AsyncNotifier<List<int>> {
  static final provider =
      AsyncNotifierProvider<OrderNotifier, List<int>>(OrderNotifier.new);

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
    // Save new orders to memory
    List<String> toConvertList = [];
    for (int item in orderDrawer) {
      toConvertList.add(item.toString());
    }
    (await ref.read(sharedPrefs.future))
        .setStringList('orderDrawer', toConvertList);
  }
}
