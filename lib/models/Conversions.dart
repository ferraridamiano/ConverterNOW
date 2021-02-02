import 'package:converterpro/pages/ReorderPage.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "dart:convert";
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:units_converter/units_converter.dart';

class Conversions with ChangeNotifier {
  List<Property> _propertyList;
  List<List<UnitData>> _unitDataList = [];
  List<UnitData> currentUnitDataList;
  Property _currentProperty;
  UnitData _selectedUnit; //unit where the user is writing the value
  int _currentPage = 0; //from appModel
  DateTime _lastUpdateCurrencies = DateTime(2021, 2, 1); //1st of february 2021
  Map<CURRENCIES, double> _currencyValues = {
    CURRENCIES.EUR: 1.0,
    CURRENCIES.CAD: 1.5474,
    CURRENCIES.HKD: 9.3687,
    CURRENCIES.RUB: 91.6248,
    CURRENCIES.PHP: 58.083,
    CURRENCIES.DKK: 7.4373,
    CURRENCIES.NZD: 1.6844,
    CURRENCIES.CNY: 7.8143,
    CURRENCIES.AUD: 1.5831,
    CURRENCIES.RON: 4.8735,
    CURRENCIES.SEK: 10.1627,
    CURRENCIES.IDR: 17011.92,
    CURRENCIES.INR: 88.345,
    CURRENCIES.BRL: 6.5765,
    CURRENCIES.USD: 1.2084,
    CURRENCIES.ILS: 3.9739,
    CURRENCIES.JPY: 126.77,
    CURRENCIES.THB: 36.228,
    CURRENCIES.CHF: 1.0816,
    CURRENCIES.CZK: 25.975,
    CURRENCIES.MYR: 4.885,
    CURRENCIES.TRY: 8.6902,
    CURRENCIES.MXN: 24.5157,
    CURRENCIES.NOK: 10.389,
    CURRENCIES.HUF: 356.35,
    CURRENCIES.ZAR: 18.1574,
    CURRENCIES.SGD: 1.6092,
    CURRENCIES.GBP: 0.882,
    CURRENCIES.KRW: 1351.21,
    CURRENCIES.PLN: 4.508,
  };
  Map<CURRENCIES, String> _currenciesSymbols = {
    CURRENCIES.EUR: '€ 🇪🇺',
    CURRENCIES.CAD: '\$ 🇨🇦',
    CURRENCIES.HKD: 'HK\$ 🇭🇰',
    CURRENCIES.RUB: '₽ 🇷🇺',
    CURRENCIES.PHP: '₱ 🇵🇭',
    CURRENCIES.DKK: 'kr 🇩🇰',
    CURRENCIES.NZD: 'NZ\$ 🇳🇿',
    CURRENCIES.CNY: '¥ 🇨🇳',
    CURRENCIES.AUD: 'A\$ 🇦🇺',
    CURRENCIES.RON: 'L 🇷🇴',
    CURRENCIES.SEK: 'kr 🇸🇪',
    CURRENCIES.IDR: 'Rp 🇮🇩',
    CURRENCIES.INR: '₹ 🇮🇳',
    CURRENCIES.BRL: 'R\$ 🇧🇷',
    CURRENCIES.USD: '\$ 🇺🇸',
    CURRENCIES.ILS: '₪ 🇮🇱',
    CURRENCIES.JPY: '¥ 🇯🇵',
    CURRENCIES.THB: '฿ 🇹🇭',
    CURRENCIES.CHF: 'Fr. 🇨🇭',
    CURRENCIES.CZK: 'Kč 🇨🇿',
    CURRENCIES.MYR: 'RM 🇲🇾',
    CURRENCIES.TRY: '₺ 🇹🇷',
    CURRENCIES.MXN: '\$ 🇲🇽',
    CURRENCIES.NOK: 'kr 🇳🇴',
    CURRENCIES.HUF: 'Ft 🇭🇺',
    CURRENCIES.ZAR: 'R 🇿🇦',
    CURRENCIES.SGD: 'S\$ 🇸🇬',
    CURRENCIES.GBP: '£ 🇬🇧',
    CURRENCIES.KRW: '₩ 🇰🇷',
    CURRENCIES.PLN: 'zł 🇵🇱',
  };
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  static List<int> _orderLunghezza = List.generate(16, (index) => index);
  static List<int> _orderSuperficie = List.generate(11, (index) => index);
  static List<int> _orderVolume = List.generate(14, (index) => index);
  static List<int> _orderTempo = List.generate(15, (index) => index);
  static List<int> _orderTemperatura = List.generate(7, (index) => index);
  static List<int> _orderVelocita = List.generate(5, (index) => index);
  static List<int> _orderPrefissi = List.generate(21, (index) => index);
  static List<int> _orderMassa = List.generate(11, (index) => index);
  static List<int> _orderPressione = List.generate(6, (index) => index);
  static List<int> _orderEnergia = List.generate(4, (index) => index);
  static List<int> _orderAngoli = List.generate(4, (index) => index);
  static List<int> _orderValute = List.generate(30, (index) => index);
  static List<int> _orderScarpe = List.generate(10, (index) => index);
  static List<int> _orderDati = List.generate(27, (index) => index);
  static List<int> _orderPotenza = List.generate(7, (index) => index);
  static List<int> _orderForza = List.generate(5, (index) => index);
  static List<int> _orderTorque = List.generate(5, (index) => index);
  static List<int> _orderConsumo = List.generate(4, (index) => index);
  static List<int> _orderBasi = List.generate(4, (index) => index);
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  static List<List<int>> _conversionsOrder = [
    _orderLunghezza,
    _orderSuperficie,
    _orderVolume,
    _orderTempo,
    _orderTemperatura,
    _orderVelocita,
    _orderPrefissi,
    _orderMassa,
    _orderPressione,
    _orderEnergia,
    _orderAngoli,
    _orderValute,
    _orderScarpe,
    _orderDati,
    _orderPotenza,
    _orderForza,
    _orderTorque,
    _orderConsumo,
    _orderBasi
  ];
  bool _isCurrenciesLoading = true;
  bool _removeTrailingZeros = true;
  static final List<int> _significantFiguresList = <int>[6, 8, 10, 12, 14];
  int _significantFigures = _significantFiguresList[2];

  Conversions() {
    _checkCurrencies(); //update the currencies with the latest conversions rates and then
    //_checkOrdersUnits();
    //_checkSettings();
    _refreshConversionsList();
    _currentProperty = _propertyList[_currentPage];

    //Initialize of all the UnitData: name, textEditingController, symbol
    List<Unit> tempProperty;
    List<UnitData> tempUnitData = [];
    for (Property property in _propertyList) {
      tempProperty = property.getAll();
      for (Unit unit in tempProperty) {
        tempUnitData.add(
          UnitData(
            unit,
            property: property.name,
            tec: TextEditingController(),
          ),
        );
      }
      _unitDataList.add(tempUnitData);
      tempUnitData = [];
    }
    currentUnitDataList = _unitDataList[_currentPage];
  }

  _refreshConversionsList() {
    _propertyList = [
      Angle(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.ANGLE),
      Area(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.AREA),
      SimpleCustomConversion(_currencyValues,
          mapSymbols: _currenciesSymbols, significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.CURRENCIES),
      DigitalData(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.DIGITAL_DATA),
      Energy(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.ENERGY),
      Force(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.FORCE),
      FuelConsumption(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.FUEL_CONSUMPTION),
      Length(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.LENGTH),
      Mass(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.MASS),
      NumeralSystems(name: PROPERTYX.NUMERAL_SYSTEMS),
      Power(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.POWER),
      Pressure(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.PRESSURE),
      ShoeSize(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.SHOE_SIZE),
      SIPrefixes(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.SI_PREFIXES),
      Speed(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.SPEED),
      Temperature(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.TEMPERATURE),
      Time(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.TIME),
      Torque(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.TORQUE),
      Volume(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.VOLUME),
    ];
  }

  _refreshCurrentUnitDataList() {
    int len = currentUnitDataList.length;
    List<Unit> updatedUnit = _currentProperty.getAll();
    for (int i = 0; i < len; i++) {
      UnitData currentUnitData = currentUnitDataList[i];
      currentUnitData.unit = updatedUnit[i];
      if (currentUnitData != _selectedUnit && currentUnitData.unit.stringValue != null) {
        currentUnitDataList[i].tec.text = currentUnitData.unit.stringValue;
      } else if (currentUnitData.unit.stringValue == null) {
        currentUnitDataList[i].tec.text = '';
      }
    }
  }

  convert(UnitData unitData, var value) {
    _currentProperty.convert(unitData.unit.name, value);
    _selectedUnit = unitData;
    _refreshCurrentUnitDataList();
    notifyListeners();
  }

  set currentPage(int currentPage) {
    _currentPage = currentPage;
    _currentProperty = _propertyList[_currentPage];
    currentUnitDataList = _unitDataList[_currentPage];
    notifyListeners();
  }

  get currentPropertyName => _currentProperty.name;

  ///Clears the values of the current page
  clearAllValues() {
    convert(_selectedUnit ?? currentUnitDataList[0], null);
  }

  ///Returns the DateTime of the latest update of the currencies conversions
  ///ratio (year, month, day)
  get lastUpdateCurrency => _lastUpdateCurrencies;

  ///returns true if the currencies conversions ratio are not ready yet,
  ///returns false otherwise
  get isCurrenciesLoading => _isCurrenciesLoading;

  ///This method is used by _checkCurrencies to read the currencies conversions if
  ///the smartphone is offline
  _readSavedCurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currencyRead = prefs.getString("currencyRates");
    if (currencyRead != null) {
      CurrencyJSONObject currencyObject = new CurrencyJSONObject.fromJson(json.decode(currencyRead));
      _currencyValues = currencyObject.rates;
      String lastUpdateRead = currencyObject.date;
      if (lastUpdateRead != null) _lastUpdateCurrencies = DateTime.parse(lastUpdateRead);
    }
  }

  ///Updates the currencies conversions ratio with the latest values. The data comes from
  ///the internet if the connection is available or from memory if the smartphone is offline
  _checkCurrencies() async {
    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String dataFetched = prefs.getString("currencyRates");
    if (dataFetched == null || CurrencyJSONObject.fromJson(json.decode(dataFetched)).date != now) {
      //if I have never updated the conversions or if I have updated before today I have to update
      try {
        var response = await http.get(
            'https://api.exchangeratesapi.io/latest?symbols=USD,GBP,INR,CNY,JPY,CHF,SEK,RUB,CAD,KRW,BRL,HKD,AUD,NZD,MXN,SGD,NOK,TRY,ZAR,DKK,PLN,THB,MYR,HUF,CZK,ILS,IDR,PHP,RON');
        if (response.statusCode == 200) {
          //if successful
          CurrencyJSONObject currencyObject = new CurrencyJSONObject.fromJson(json.decode(response.body));
          //the following line solves the problem that the http request gives a date refered to some
          //time zone that may be not the same of the time zone of the user. So I rewrite the date of
          //the response to be the same of the date of the user
          currencyObject.date = now;
          _currencyValues = currencyObject.rates; //updates the currency value with the new values
          _currencyValues.putIfAbsent(CURRENCIES.EUR, () => 1.0);
          //If the request recive an accettable response the last update is now
          _lastUpdateCurrencies = DateTime.now();
          //save to memory
          prefs.setString("currencyRates", currencyObject.toString());
        } else //if there's some error in the data read (e.g. I'm not connected)
          await _readSavedCurrencies(); //read the saved data
      } catch (e) {
        //catch communication error
        print(e);
        await _readSavedCurrencies(); //read the saved data
      }
    } else {
      //If I already have the data of today I just use it, no need of read them from the web
      await _readSavedCurrencies();
      _lastUpdateCurrencies = DateTime.now();
    }
    _isCurrenciesLoading = false; // stop the progress indicator to show the date of the latest update
    _refreshConversionsList();
    notifyListeners(); //change the value of the current conversions
  }

  /*
  ///Get the orders of each units of measurement from the memory
  _checkOrdersUnits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringList;
    //Update every order of every conversion
    for (int i = 0; i < conversionsList.length; i++) {
      stringList = prefs.getStringList("conversion_$i");
      if (stringList != null) {
        final int len = stringList.length;
        List<int> intList = new List();
        for (int j = 0; j < len; j++) {
          intList.add(int.parse(stringList[j]));
        }
        //solves the problem of adding new units after an update
        for (int j = len; j < _conversionsOrder[i].length; j++) intList.add(j);
        _conversionsOrder[i] = intList;
      }
    }
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
    notifyListeners();
  }

  ///Given a list of translated units of measurement it changes the order
  ///of the units (_conversionsOrder) opening a separate page (ReorderPage)
  changeOrderUnits(BuildContext context, List<String> listUnitsNames, int currentPage) async {
    final List<int> result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReorderPage(listUnitsNames),
      ),
    );
    //if there arent't any modifications, do nothing
    if (result != null) {
      List arrayCopy = new List(_conversionsOrder[currentPage].length);
      for (int i = 0; i < _conversionsOrder[currentPage].length; i++) arrayCopy[i] = _conversionsOrder[currentPage][i];
      for (int i = 0; i < _conversionsOrder[currentPage].length; i++) _conversionsOrder[currentPage][i] = result.indexOf(arrayCopy[i]);
      _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
      notifyListeners();
      _saveOrders(currentPage);
    }
  }

  _saveOrders(int currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> toConvertList = new List();
    for (int item in _conversionsOrder[currentPage]) toConvertList.add(item.toString());
    prefs.setStringList("conversion_$currentPage", toConvertList);
  }

  //Settings section------------------------------------------------------------------

  ///It reads the settings related to the conversions model from the memory of the device
  ///(if there are options saved)
  _checkSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int val1 = prefs.getInt("significant_figures");
    bool val2 = prefs.getBool("remove_trailing_zeros");

    if (val1 != null || val2 != null) {
      if (val1 != null) _significantFigures = val1;

      if (val2 != null) _removeTrailingZeros = val2;

      _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
      notifyListeners();
    }
  }

  ///Returns true if you want to remove the trailing zeros of the conversions
  ///e.g. 1.000000000e20 becomes 1e20
  bool get removeTrailingZeros => _removeTrailingZeros;

  ///Returns the list of possibile significant figures
  List<int> get significantFiguresList => _significantFiguresList;

  ///Returns the current significant figures selection
  int get significantFigures => _significantFigures;

  ///Set the ability of remove unecessary trailing zeros and save to SharedPreferences
  ///e.g. 1.000000000e20 becomes 1e20
  set removeTrailingZeros(bool value) {
    _removeTrailingZeros = value;
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
    notifyListeners();
    _saveSettingsBool('remove_trailing_zeros', _removeTrailingZeros);
  }

  ///Set the current significant figures selection and save to SharedPreferences
  set significantFigures(int value) {
    _significantFigures = value;
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
    notifyListeners();
    _saveSettingsInt('significant_figures', _significantFigures);
  }*/

  ///Saves the key value with SharedPreferences
  _saveSettingsInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  ///Saves the key value with SharedPreferences
  _saveSettingsBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
}
