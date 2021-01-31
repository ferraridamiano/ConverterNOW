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
  UnitData selectedUnit; //unit where the user is writing the value
  int _currentPage = 0; //from appModel
  DateTime _lastUpdateCurrencies = DateTime(2019, 10, 29);
  Map<String, double> _currencyValues = {
    "CAD": 1.4487,
    "hkd": 8.6923,
    "RUB": 70.5328,
    "php": 56.731,
    "dkk": 7.4707,
    "nzd": 1.7482,
    "cny": 7.8366,
    "aud": 1.6245,
    "RON": 4.7559,
    "sek": 10.7503,
    "IDR": 15536.21,
    "inr": 78.4355,
    "brl": 4.4158,
    "usd": 1.1087,
    "ILS": 3.9187,
    "jpy": 120.69,
    "thb": 33.488,
    "chf": 1.1047,
    "czk": 25.48,
    "myr": 4.641,
    "TRY": 6.3479,
    "mxn": 21.1244,
    "nok": 10.2105,
    "huf": 328.16,
    "zar": 16.1202,
    "sgd": 1.5104,
    "gbp": 0.86328,
    "krw": 1297.1,
    "pln": 4.2715
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
    //_checkCurrencies(); //update the currencies with the latest conversions rates and then
    //_checkOrdersUnits();
    //_checkSettings();
    _refreshConversionsList();
    _currentProperty = _propertyList[0];

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
    currentUnitDataList = _unitDataList[0];
  }

  _refreshConversionsList() {
    _propertyList = [
      Length(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Area(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Time(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Temperature(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Speed(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      SIPrefixes(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Mass(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Pressure(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Energy(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Angle(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      ShoeSize(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      DigitalData(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Power(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Force(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      Torque(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      FuelConsumption(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros),
      NumeralSystems(),
    ];
  }

  _refreshCurrentUnitDataList() {
    int len = currentUnitDataList.length;
    List<Unit> updatedUnit = _currentProperty.getAll();
    for (int i = 0; i < len; i++) {
      UnitData currentUnitData = currentUnitDataList[i];
      currentUnitData.unit = updatedUnit[i];
      if (currentUnitData != selectedUnit && currentUnitData.unit.stringValue != null) {
        currentUnitDataList[i].tec.text = currentUnitData.unit.stringValue;
      } else if (currentUnitData.unit.stringValue == null) {
        currentUnitDataList[i].tec.text = '';
      }
    }
  }

  convert(UnitData unitData, var value) {
    _currentProperty.convert(unitData.unit.name, value);
    selectedUnit = unitData;
    _refreshCurrentUnitDataList();
    notifyListeners();
  }

  set currentPage(int currentPage) {
    _currentPage = currentPage;
    notifyListeners();
  }

  get currentPropertyName =>  _currentProperty.name;

  ///Clears the values of the current page
  clearAllValues() {
    convert(selectedUnit ?? currentUnitDataList[0], null);
  }

  ///Returns the DateTime of the latest update of the currencies conversions
  ///ratio (year, month, day)
  get lastUpdateCurrency => _lastUpdateCurrencies;

  ///returns true if the currencies conversions ratio are not ready yet,
  ///returns false otherwise
  get isCurrenciesLoading => _isCurrenciesLoading;

  /*
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
            'https://api.exchangeratesapi.io/latest?symbols=usd,gbp,inr,cny,jpy,chf,sek,RUB,CAD,krw,brl,hkd,aud,nzd,mxn,sgd,nok,TRY,zar,dkk,pln,thb,myr,huf,czk,ILS,IDR,php,RON');
        if (response.statusCode == 200) {
          //if successful
          CurrencyJSONObject currencyObject = new CurrencyJSONObject.fromJson(json.decode(response.body));
          //the following line solves the problem that the http request gives a date refered to some
          //time zone that may be not the same of the time zone of the user. So I rewrite the date of
          //the response to be the same of the date of the user
          currencyObject.date = now;
          _currencyValues = currencyObject.rates; //updates the currency value with the new values
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
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
    notifyListeners(); //change the value of the current conversions
  }

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
