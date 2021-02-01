import 'package:converterpro/pages/ReorderPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel with ChangeNotifier {
  //_conversionsOrderDrawer numbers until max conversion units - 1
  List<int> _conversionsOrderDrawer = List.generate(19, (index) => index);
  int _currentPage = 0;
  bool _isLogoVisible = true;

  AppModel() {
    _checkOrdersDrawer();
    _checkSettings();
  }

  ///Returns the order of the tile of the conversions in the drawer
  get conversionsOrderDrawer => _conversionsOrderDrawer;

  ///Returns the current page (e.g: temperature, mass, etc)
  get currentPage => _currentPage;

  ///Method needed to change the selected conversion page
  ///e.g: from temperature to mass, etc
  changeToPage(int index) {
    if (_currentPage != index) {
      _currentPage = index;
      notifyListeners();
    }
  }

  ///Updates the order of the tiles in the drawer
  _checkOrdersDrawer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList = prefs.getStringList("orderDrawer");
    if (stringList != null) {
      final int len = stringList.length;
      for (int i = 0; i < len; i++) {
        _conversionsOrderDrawer[i] = int.parse(stringList[i]);
        if (_conversionsOrderDrawer[i] == 0) _currentPage = i;
      }
      //If new units of mesurement will be added the following 2
      //lines of code ensure that everything will works fine
      for (int i = len; i < _conversionsOrderDrawer.length; i++) {
        _conversionsOrderDrawer[i] = i;
      }
    }
    notifyListeners();
  }

  ///Changes the orders of the tiles in the Drawer
  changeOrderDrawer(BuildContext context, List<String> titlesList) async {
    Navigator.of(context).pop(); //Close the drawer

    List<String> orderedList = new List(_conversionsOrderDrawer.length);
    for (int i = 0; i < _conversionsOrderDrawer.length; i++) {
      orderedList[_conversionsOrderDrawer[i]] = titlesList[i];
    }

    final List<int> result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ReorderPage(orderedList)));

    //if there arent't any modifications, do nothing
    if (result != null) {
      List arrayCopia = new List(_conversionsOrderDrawer.length);
      for (int i = 0; i < _conversionsOrderDrawer.length; i++) arrayCopia[i] = _conversionsOrderDrawer[i];
      for (int i = 0; i < _conversionsOrderDrawer.length; i++)
        _conversionsOrderDrawer[i] = result.indexOf(arrayCopia[i]);

      notifyListeners();
      //save new orders to memory
      List<String> toConvertList = new List();
      for (int item in _conversionsOrderDrawer) toConvertList.add(item.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList("orderDrawer", toConvertList);
    }
  }

  //Settings section------------------------------------------------------------------

  ///It reads the settings related to the appModel from the memory of the device
  ///(if there are options saved)
  _checkSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = prefs.getBool("isLogoVisible");
    if (val != null) {
      _isLogoVisible = val;
      notifyListeners();
    }
  }

  ///Returns true if the drawer logo is visible, false otherwise
  bool get isLogoVisible => _isLogoVisible;

  ///Set the drawer logo visibility and save to SharedPreferences
  set isLogoVisible(bool value) {
    _isLogoVisible = value;
    notifyListeners();
    _saveSettingsBool('isLogoVisible', _isLogoVisible);
  }

  ///Saves the key value with SharedPreferences
  _saveSettingsBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
}
