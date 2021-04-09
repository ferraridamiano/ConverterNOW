import 'package:converterpro/pages/ReorderPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel with ChangeNotifier {
  //_conversionsOrderDrawer numbers until max conversion units - 1
  List<int> _conversionsOrderDrawer = List.generate(19, (index) => index);
  int _currentPage = 0;
  bool _isLogoVisible = true;
  ThemeMode _currentThemeMode = ThemeMode.system;
  bool _isDarkAmoled = false;
  Map<ThemeMode, int> _themeModeMap = {
    ThemeMode.system: 0,
    ThemeMode.dark: 1,
    ThemeMode.light: 2,
  };
  bool isDrawerFixed = true;

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
    List<String>? stringList = prefs.getStringList("orderDrawer");
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
    if (!isDrawerFixed) {
      Navigator.of(context).pop(); //Close the drawer
    }

    List<String> orderedList = List.filled(_conversionsOrderDrawer.length, "");
    for (int i = 0; i < _conversionsOrderDrawer.length; i++) {
      orderedList[_conversionsOrderDrawer[i]] = titlesList[i];
    }

    final List<int>? result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ReorderPage(orderedList)));

    //if there arent't any modifications, do nothing
    if (result != null) {
      List arrayCopia = List.filled(_conversionsOrderDrawer.length, null);
      for (int i = 0; i < _conversionsOrderDrawer.length; i++) arrayCopia[i] = _conversionsOrderDrawer[i];
      for (int i = 0; i < _conversionsOrderDrawer.length; i++) _conversionsOrderDrawer[i] = result.indexOf(arrayCopia[i]);

      notifyListeners();
      //save new orders to memory
      List<String> toConvertList = [];
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
    _isLogoVisible = prefs.getBool("isLogoVisible") ?? _isLogoVisible;
    _isDarkAmoled = prefs.getBool("isDarkAmoled") ?? _isDarkAmoled;
    int? valThemeMode = prefs.getInt('currentThemeMode');
    if (valThemeMode != null) {
      _currentThemeMode = _themeModeMap.keys.where((key) => _themeModeMap[key] == valThemeMode).single;
    }
    notifyListeners();
  }

  ///Returns true if the drawer logo is visible, false otherwise
  bool get isLogoVisible => _isLogoVisible;

  ///Set the drawer logo visibility and save to SharedPreferences
  set isLogoVisible(bool value) {
    _isLogoVisible = value;
    notifyListeners();
    _saveSettingsBool('isLogoVisible', _isLogoVisible);
  }

  set currentThemeMode(ThemeMode val) {
    _currentThemeMode = val;
    notifyListeners();
    _saveSettingsInt('currentThemeMode', _themeModeMap[_currentThemeMode]!);
  }

  ThemeMode get currentThemeMode => _currentThemeMode;

  set isDarkAmoled(bool val) {
    _isDarkAmoled = val;
    notifyListeners();
    _saveSettingsBool('isDarkAmoled', _isDarkAmoled);
  }

  bool get isDarkAmoled => _isDarkAmoled;

  ///Saves the key value with SharedPreferences
  _saveSettingsBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  ///Saves the key value with SharedPreferences
  _saveSettingsInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }
}
