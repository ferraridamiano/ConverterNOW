import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:units_converter/units_converter.dart';

class Conversions with ChangeNotifier {
  List<List<UnitData>> _unitDataList = [];

  /// Contains the List of the double (or String for numeral systems conversion) saved before the clear all operation.
  /// This need to be done in order to undo the clear all operation
  List<dynamic>? _savedUnitDataList;

  /// This contains the value of [_currentPage] when a clear all operation (and the corresponding value saving) is
  /// performed
  int? _savedPropertyIndex;

  UnitData? _selectedUnit; //unit where the user is writing the value
  CurrenciesObject _currenciesObject = CurrenciesObject();
  final Map<CURRENCIES, String> _currenciesSymbols = {
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
    CURRENCIES.HRK: 'kn 🇭🇷',
    CURRENCIES.BGN: 'лв 🇧🇬',
    CURRENCIES.ISK: 'kr 🇮🇸',
    CURRENCIES.TWD: 'NT\$ 🇹🇼',
    CURRENCIES.MAD: 'د.م. 🇲🇦',
  };
  List<Property> _propertyList = [];
  List<List<int>>? _conversionsOrder;
  bool _isCurrenciesLoading = true;
  bool _removeTrailingZeros = true;
  static const List<int> _significantFiguresList = <int>[6, 8, 10, 12, 14];
  int _significantFigures = _significantFiguresList[2];

  Conversions() {
    _checkCurrencies(); //update the currencies with the latest conversions rates and then
    _initializePropertyList();
    _checkOrdersUnits();
    _checkSettings();
  }

  void _initializePropertyList() {
    _propertyList = [
      Length(
          significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.length),
      Area(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.area),
      Volume(
          significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.volume),
      SimpleCustomConversion(_currenciesObject.values,
          mapSymbols: _currenciesSymbols,
          significantFigures: _significantFigures,
          removeTrailingZeros: _removeTrailingZeros,
          name: PROPERTYX.currencies),
      Time(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.time),
      Temperature(
          significantFigures: _significantFigures,
          removeTrailingZeros: _removeTrailingZeros,
          name: PROPERTYX.temperature),
      Speed(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.speed),
      Mass(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.mass),
      Force(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.force),
      FuelConsumption(
          significantFigures: _significantFigures,
          removeTrailingZeros: _removeTrailingZeros,
          name: PROPERTYX.fuelConsumption),
      NumeralSystems(name: PROPERTYX.numeralSystems),
      Pressure(
          significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.pressure),
      Energy(
          significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.energy),
      Power(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.power),
      Angle(significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.angle),
      ShoeSize(
          significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.shoeSize),
      DigitalData(
          significantFigures: _significantFigures,
          removeTrailingZeros: _removeTrailingZeros,
          name: PROPERTYX.digitalData),
      SIPrefixes(
          significantFigures: _significantFigures,
          removeTrailingZeros: _removeTrailingZeros,
          name: PROPERTYX.siPrefixes),
      Torque(
          significantFigures: _significantFigures, removeTrailingZeros: _removeTrailingZeros, name: PROPERTYX.torque),
    ];
  }

  /// Returns true if the model ha finished to load the stored
  /// _conversionsOrder and `_unitDataList` is not empty, false otherwise.
  bool get isConversionsLoaded => _unitDataList.isNotEmpty;

  /// This function get the value of the unit from currentProperty and update
  /// the currentUnitDataList values. It is used when a conversion changes the
  /// values of the units
  _refreshCurrentUnitDataList(int page) {
    List<UnitData> currentUnitDataList = _unitDataList[page];
    for (UnitData currentUnitData in currentUnitDataList) {
      final _currentProperty = _propertyList[page];
      currentUnitData.unit = _currentProperty.getUnit(currentUnitData.unit.name);
      if (currentUnitData != _selectedUnit) {
        if (currentUnitData.unit.stringValue == null) {
          currentUnitData.tec.text = '';
        } else {
          currentUnitData.tec.text = currentUnitData.unit.stringValue!;
        }
      }
    }
  }

  /// This function is used to convert all the values from one that has been modified
  convert(UnitData unitData, var value, int page) {
    _propertyList[page].convert(unitData.unit.name, value);
    _selectedUnit = unitData;
    _refreshCurrentUnitDataList(page);
    notifyListeners();
  }

  /// Returns a UnitDataList at a certain page with the current ordering (usefult with reorder units)
  List<UnitData> getUnitDataListAtPage(int page) => _unitDataList[page];

  PROPERTYX getPropertyNameAtPage(int page) => _propertyList[page].name;

  ///Clears the values of the current page
  clearAllValues(int page) {
    List<UnitData> currentUnitDataList = _unitDataList[page];
    if (currentUnitDataList[0].property == PROPERTYX.numeralSystems) {
      _savedUnitDataList = [...currentUnitDataList.map((unitData) => unitData.unit.stringValue)];
    } else {
      _savedUnitDataList = [...currentUnitDataList.map((unitData) => unitData.unit.value)];
    }
    _savedPropertyIndex = page;
    convert(currentUnitDataList[0], null, page);
    currentUnitDataList[0].tec.text = ''; // convert doesn't clear a selected textfield
  }

  /// Undo the last clear all operation performed
  undoClearOperation() {
    if (_savedUnitDataList != null && _savedPropertyIndex != null) {
      List<UnitData> listToUndo = _unitDataList[_savedPropertyIndex!];
      if (_savedUnitDataList![0] is double) {
        for (int i = 0; i < listToUndo.length; i++) {
          listToUndo[i]
            ..unit.value = _savedUnitDataList![i]
            ..tec.text = _savedUnitDataList![i].toString();
        }
      } else if (_savedUnitDataList![0] is String) {
        for (int i = 0; i < listToUndo.length; i++) {
          listToUndo[i]
            ..unit.stringValue = _savedUnitDataList![i]
            ..tec.text = _savedUnitDataList![i];
        }
      }
      notifyListeners();
      _savedUnitDataList = _savedPropertyIndex = null;
    }
  }

  /// Returns true if we should show a snackbar when the user press on the clear
  /// all button (see [undoClearOperation]), false otherwise.
  bool shouldShowSnackbar(int page) => _unitDataList[page][0].tec.text != '';

  ///Returns the DateTime of the latest update of the currencies conversions
  ///ratio (year, month, day)
  get lastUpdateCurrency => _currenciesObject.lastUpdate;

  ///returns true if the currencies conversions ratio are not ready yet,
  ///returns false otherwise
  get isCurrenciesLoading => _isCurrenciesLoading;

  ///This method is used by _checkCurrencies to read the currencies conversions if
  ///the smartphone is offline
  _readSavedCurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currenciesRead = prefs.getString('currenciesRates');
    String? lastUpdate = prefs.getString("lastUpdateCurrencies");
    if (currenciesRead != null && lastUpdate != null) {
      _currenciesObject = CurrenciesObject.fromJson(json.decode(currenciesRead), lastUpdate);
    }
  }

  ///Updates the currencies conversions ratio with the latest values. The data comes from
  ///the internet if the connection is available or from memory if the smartphone is offline
  _checkCurrencies() async {
    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Let's search before if we already have downloaded the exchange rates
    String? lastUpdate = prefs.getString("lastUpdateCurrencies");
    //if I have never updated the conversions or if I have updated before today I have to update
    if (lastUpdate == null || lastUpdate != now) {
      //stringRequest prepares the string request for all the currencies in the enum CURRENICES
      String stringRequest = '';
      for (CURRENCIES currency in CURRENCIES.values) {
        if (currency != CURRENCIES.EUR) {
          stringRequest +=
              (currency.toString().substring(11).toUpperCase() + '+'); // removes the first part: 'CURRENCIES.'
        }
      }
      stringRequest = stringRequest.substring(0, stringRequest.length - 1); //removes the last '+'
      try {
        http.Response httpResponse = await http.get(
          Uri.https(
            'sdw-wsrest.ecb.europa.eu',
            'service/data/EXR/D.$stringRequest.EUR.SP00.A',
            {
              'lastNObservations': '1',
              'detail': 'dataonly',
            },
          ),
          headers: {'Accept': 'application/vnd.sdmx.data+json;version=1.0.0-wd'},
        );
        //if successful
        if (httpResponse.statusCode == 200) {
          _currenciesObject = CurrenciesObject.fromJsonResponse(json.decode(httpResponse.body));
          prefs.setString('currenciesRates', _currenciesObject.toJson());
          prefs.setString('lastUpdateCurrencies', now);
        } else {
          //if there's some error in the data read (e.g. I'm not connected)
          await _readSavedCurrencies(); //read the saved data
        }
      } catch (e) {
        //catch communication error
        // ignore: avoid_print
        print(e);
        await _readSavedCurrencies(); //read the saved data
      }
    } else {
      //If I already have the data of today I just use it, no need of read them from the web
      await _readSavedCurrencies();
    }
    _isCurrenciesLoading = false; // stop the progress indicator to show the date of the latest update
    _initializePropertyList(); //we need to refresh the property list because we changed some conversions
    notifyListeners(); //change the value of the current conversions
  }

  ///Get the orders of each units of measurement from the memory
  _checkOrdersUnits() async {
    //Initialize the order for each property to default: [0,1,2,...,size(property)]
    List<List<int>> temp = [];
    for (Property property in _propertyList) {
      temp.add(List.generate(property.size, (index) => index));
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? stringList;
    //Update every order of every conversion
    for (int i = 0; i < _propertyList.length; i++) {
      stringList = prefs.getStringList("conversion_$i");
      if (stringList != null) {
        final int len = stringList.length;
        List<int> intList = [];
        for (int j = 0; j < len; j++) {
          intList.add(int.parse(stringList[j]));
        }
        //solves the problem of adding new units after an update
        for (int j = len; j < temp[i].length; j++) {
          intList.add(j);
        }
        temp[i] = intList;
      }
    }
    _conversionsOrder = temp;
    _refreshOrderUnits();
    notifyListeners();
  }

  /// Apply the order defined in [_conversionsOrder] to [_unitDataList]. [_unitDataList] will be redefined, so this function is used also during initialization
  _refreshOrderUnits() {
    assert(_conversionsOrder != null, true);
    List<List<UnitData>> _tempUnitDataList = [];
    for (int i = 0; i < _propertyList.length; i++) {
      List<UnitData> tempUnitData =
          List.filled(_conversionsOrder![i].length, UnitData(Unit('none'), tec: TextEditingController()));
      Property property = _propertyList[i];
      List<Unit> tempProperty = property.getAll();
      for (int j = 0; j < tempProperty.length; j++) {
        VALIDATOR validator;
        TextInputType textInputType;
        if (property.name == PROPERTYX.temperature) {
          switch (tempProperty[j].name) {
            // Just kelvin and rankine can't be negative
            case TEMPERATURE.kelvin:
            case TEMPERATURE.rankine:
              textInputType = const TextInputType.numberWithOptions(decimal: true, signed: false);
              validator = VALIDATOR.rationalNonNegative;
              break;
            default:
              textInputType = const TextInputType.numberWithOptions(decimal: true, signed: true);
              validator = VALIDATOR.rational;
          }
        } else if (property.name == PROPERTYX.numeralSystems) {
          switch (tempProperty[j].name) {
            case NUMERAL_SYSTEMS.binary:
              {
                validator = VALIDATOR.binary;
                textInputType = const TextInputType.numberWithOptions(decimal: false, signed: false);
                break;
              }
            case NUMERAL_SYSTEMS.octal:
              {
                validator = VALIDATOR.octal;
                textInputType = const TextInputType.numberWithOptions(decimal: false, signed: false);
                break;
              }
            case NUMERAL_SYSTEMS.decimal:
              {
                validator = VALIDATOR.decimal;
                textInputType = const TextInputType.numberWithOptions(decimal: false, signed: false);
                break;
              }
            case NUMERAL_SYSTEMS.hexadecimal:
              {
                validator = VALIDATOR.hexadecimal;
                textInputType = TextInputType.text;
                break;
              }
            default:
              {
                textInputType = const TextInputType.numberWithOptions(decimal: false, signed: false);
                validator = VALIDATOR.decimal;
              }
          }
        } else {
          textInputType = const TextInputType.numberWithOptions(decimal: true, signed: false);
          validator = VALIDATOR.rationalNonNegative;
        }

        tempUnitData[_conversionsOrder![i][j]] = UnitData(
          tempProperty[j],
          property: property.name,
          tec: TextEditingController(),
          validator: validator,
          textInputType: textInputType,
        );
      }
      _tempUnitDataList.add(tempUnitData);
    }
    _unitDataList = _tempUnitDataList;
  }

  ///Given a new ordering of a specific page it applys it to the app and store it.
  saveOrderUnits(List<int>? newOrder, int pageNumber) async {
    assert(newOrder == null ? true : newOrder.length == _conversionsOrder![pageNumber].length);
    //if there arent't any modifications, do nothing
    if (newOrder != null) {
      List arrayCopy = List.filled(_conversionsOrder![pageNumber].length, null);
      for (int i = 0; i < _conversionsOrder![pageNumber].length; i++) {
        arrayCopy[i] = _conversionsOrder![pageNumber][i];
      }
      for (int i = 0; i < _conversionsOrder![pageNumber].length; i++) {
        _conversionsOrder![pageNumber][i] = newOrder.indexOf(arrayCopy[i]);
      }
      _refreshOrderUnits();
      notifyListeners();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> toConvertList = [];
      for (int item in _conversionsOrder![pageNumber]) {
        toConvertList.add(item.toString());
      }
      prefs.setStringList("conversion_$pageNumber", toConvertList);
    }
  }

  //Settings section------------------------------------------------------------------

  ///It reads the settings related to the conversions model from the memory of the device
  ///(if there are options saved)
  _checkSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? val1 = prefs.getInt("significant_figures");
    bool? val2 = prefs.getBool("remove_trailing_zeros");

    if (val1 != null || val2 != null) {
      if (val1 != null) {
        _significantFigures = val1;
      }
      if (val2 != null) {
        _removeTrailingZeros = val2;
      }
      _initializePropertyList();
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
    _initializePropertyList();
    _refreshOrderUnits();
    notifyListeners();
    _saveSettingsBool('remove_trailing_zeros', _removeTrailingZeros);
  }

  ///Set the current significant figures selection and save to SharedPreferences
  set significantFigures(int value) {
    _significantFigures = value;
    _initializePropertyList();
    _refreshOrderUnits();
    notifyListeners();
    _saveSettingsInt('significant_figures', _significantFigures);
  }

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
