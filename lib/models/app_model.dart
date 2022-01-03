import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MAIN_SCREEN {
  settings,
  conversion,
  reorderProperties,
  reorderUnits,
}

class AppModel with ChangeNotifier {
  //_conversionsOrderDrawer numbers until max conversion units - 1
  final List<int> _conversionsOrderDrawer = List.generate(19, (index) => index);
  MAIN_SCREEN _currentScreen = MAIN_SCREEN.conversion;
  int _currentPage = 0;
  ThemeMode _currentThemeMode = ThemeMode.system;
  bool _isDarkAmoled = false;
  final Map<ThemeMode, int> _themeModeMap = {
    ThemeMode.system: 0,
    ThemeMode.dark: 1,
    ThemeMode.light: 2,
  };

  final Map<Locale, String> mapLocale = {
    const Locale('en'): 'English',
    const Locale('de'): 'Deutsch',
    const Locale('es'): 'Español',
    const Locale('fr'): 'Français',
    const Locale('hr'): 'Hrvatski',
    const Locale('id'): 'Bahasa Indonesia',
    const Locale('it'): 'Italiano',
    const Locale('ja'): '日本語',
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
  List<int> get conversionsOrderDrawer => _conversionsOrderDrawer;

  ///Returns the current page (e.g: temperature, mass, etc)
  int get currentPage => _currentPage;

  ///Method needed to change the selected conversion page
  ///e.g: from temperature to mass, etc
  changeToPage(int index) {
    if (_currentPage != index) {
      _currentPage = index;
      notifyListeners();
    }
  }

  set currentScreen(MAIN_SCREEN screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  MAIN_SCREEN get currentScreen => _currentScreen;

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
  saveOrderDrawer(List<int>? newOrder) async {
    //if there arent't any modifications, do nothing
    if (newOrder != null) {
      List arrayCopia = List.filled(_conversionsOrderDrawer.length, null);
      for (int i = 0; i < _conversionsOrderDrawer.length; i++) {
        arrayCopia[i] = _conversionsOrderDrawer[i];
      }
      for (int i = 0; i < _conversionsOrderDrawer.length; i++) {
        _conversionsOrderDrawer[i] = newOrder.indexOf(arrayCopia[i]);
      }
      notifyListeners();
      //save new orders to memory
      List<String> toConvertList = [];
      for (int item in _conversionsOrderDrawer) {
        toConvertList.add(item.toString());
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList("orderDrawer", toConvertList);
    }
  }

  //Settings section------------------------------------------------------------------

  ///It reads the settings related to the appModel from the memory of the device
  ///(if there are options saved)
  _checkSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkAmoled = prefs.getBool("isDarkAmoled") ?? _isDarkAmoled;
    int? valThemeMode = prefs.getInt('currentThemeMode');
    if (valThemeMode != null) {
      _currentThemeMode = _themeModeMap.keys.where((key) => _themeModeMap[key] == valThemeMode).single;
    }
    String? temp = prefs.getString('locale');
    _appLocale = temp == null || temp == 'null' ? null : Locale(temp);
    notifyListeners();
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
    return const Locale('en');
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
    try{
      return mapLocale[mapLocale.keys.firstWhere(
      (element) => _appLocale!.languageCode == element.languageCode)];
    }
    catch(error){
      // if there isn't a locale, then a StateError is thrown
      if(error is StateError){
        return null;
      }
    }
  }
}
