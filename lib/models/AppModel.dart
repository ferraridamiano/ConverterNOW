import 'package:converterpro/pages/ReorderPage.dart';
import 'package:converterpro/utils/Utils.dart';
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

  final Map<Locale, String> mapLocale = {
    const Locale('en'): 'English',
    const Locale('de'): 'Deutsch',
    const Locale('es'): 'Español',
    const Locale('fr'): 'Français',
    const Locale('it'): 'Italiano',
    const Locale('nb'): 'Norsk',
    const Locale('pt'): 'Português',
    const Locale('ru'): 'Pусский',
    const Locale('tr'): 'Türk',
  };

  Locale? _appLocale; // null means system locale
  Locale? _deviceLocale;

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

    final List<int>? result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ReorderPage(orderedList)));

    //if there arent't any modifications, do nothing
    if (result != null) {
      List arrayCopia = List.filled(_conversionsOrderDrawer.length, null);
      for (int i = 0; i < _conversionsOrderDrawer.length; i++){
        arrayCopia[i] = _conversionsOrderDrawer[i];
      }
      for (int i = 0; i < _conversionsOrderDrawer.length; i++){
        _conversionsOrderDrawer[i] = result.indexOf(arrayCopia[i]);
      }
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
    String? temp = prefs.getString('locale');
    _appLocale = temp == null || temp == 'null' ? null : Locale(temp);
    notifyListeners();
  }

  ///Returns true if the drawer logo is visible, false otherwise
  bool get isLogoVisible => _isLogoVisible;

  ///Set the drawer logo visibility and save to SharedPreferences
  set isLogoVisible(bool value) {
    _isLogoVisible = value;
    notifyListeners();
    saveSettings('isLogoVisible', _isLogoVisible);
  }

  set currentThemeMode(ThemeMode val) {
    _currentThemeMode = val;
    notifyListeners();
    saveSettings('currentThemeMode', _themeModeMap[_currentThemeMode]!);
  }

  ThemeMode get currentThemeMode => _currentThemeMode;

  set isDarkAmoled(bool val) {
    _isDarkAmoled = val;
    notifyListeners();
    saveSettings('isDarkAmoled', _isDarkAmoled);
  }

  bool get isDarkAmoled => _isDarkAmoled;

  /// Returns the list of the supported locale
  List<Locale> get supportedLocales => mapLocale.keys.toList();

  /// Returns the Locale of the app. If appLocale is set in the settings, it will use it. If it is a system settings and
  /// it is supported it returns null, otherwise returns the english language
  Locale? get appLocale {
    if (_appLocale != null) {
      return _appLocale!;
    }
    for (Locale supportedLocale in mapLocale.keys.toList()) {
      if (supportedLocale.languageCode == _deviceLocale?.languageCode ||
          supportedLocale.countryCode == _deviceLocale?.countryCode) {
        return null; // System Locale
      }
    }
    return Locale('en');
  }

  /// Set the Locale of the device (can be different from the locale of the app)
  set deviceLocale(Locale? locale) {
    Future.delayed(Duration.zero, () async {
      _deviceLocale = locale;
      notifyListeners();
    });
  }

  /// Set a Locale given the language name (e.g 'English', 'Italiano', etc.). If `localeString` is null then it is
  /// interpreted as "System settings"
  setLocaleString(String? localeString) {
    _appLocale =
        localeString == null ? null : mapLocale.keys.firstWhere((element) => mapLocale[element] == localeString);
    notifyListeners();
    // Save 'null' if it is system settings, otherwise save the language code
    saveSettings('locale', _appLocale == null ? 'null' : _appLocale!.languageCode);
  }

  /// Return a string locale (e.g 'English', 'Italiano', etc.) or null if it is "System settings"
  String? getLocaleString() {
    return mapLocale[mapLocale.keys.firstWhere(
      (element) => _appLocale!.languageCode == element.languageCode,
      orElse: null,
    )];
  }
}