import 'package:converterpro/models/properties_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:exchange_rates/exchange_rates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:units_converter/units_converter.dart';

class ConversionsNotifier extends Notifier<List<List<UnitData>>> {
  //TODO watch never used on propertiesListProvider

  @override
  List<List<UnitData>> build() {
    //_checkCurrencies();
    _checkOrdersUnits();
    //_checkSettings();

    return _refreshOrderUnits();
  }

  /// Contains the List of the double (or String for numeral systems conversion)
  /// saved before the clear all operation. This need to be done in order to
  /// undo the clear all operation
  List<dynamic>? _savedUnitDataList;

  /// This contains the value of [_currentPage] when a clear all operation (and
  /// the corresponding value saving) is performed
  int? _savedPropertyIndex;

  UnitData? _selectedUnit; //unit where the user is writing the value
  CurrenciesObject _currenciesObject = CurrenciesObject();
  final Map<String, String> _currenciesSymbols = {
    'EUR': '€ 🇪🇺',
    'CAD': '\$ 🇨🇦',
    'HKD': 'HK\$ 🇭🇰',
    'PHP': '₱ 🇵🇭',
    'DKK': 'kr 🇩🇰',
    'NZD': 'NZ\$ 🇳🇿',
    'CNY': '¥ 🇨🇳',
    'AUD': 'A\$ 🇦🇺',
    'RON': 'L 🇷🇴',
    'SEK': 'kr 🇸🇪',
    'IDR': 'Rp 🇮🇩',
    'INR': '₹ 🇮🇳',
    'BRL': 'R\$ 🇧🇷',
    'USD': '\$ 🇺🇸',
    'ILS': '₪ 🇮🇱',
    'JPY': '¥ 🇯🇵',
    'THB': '฿ 🇹🇭',
    'CHF': 'Fr. 🇨🇭',
    'CZK': 'Kč 🇨🇿',
    'MYR': 'RM 🇲🇾',
    'TRY': '₺ 🇹🇷',
    'MXN': '\$ 🇲🇽',
    'NOK': 'kr 🇳🇴',
    'HUF': 'Ft 🇭🇺',
    'ZAR': 'R 🇿🇦',
    'SGD': 'S\$ 🇸🇬',
    'GBP': '£ 🇬🇧',
    'KRW': '₩ 🇰🇷',
    'PLN': 'zł 🇵🇱',
    'BGN': 'лв 🇧🇬',
    'ISK': 'kr 🇮🇸',
  };
  List<List<int>>? _conversionsOrder;
  bool _isCurrenciesLoading = true;

  /// Returns true if the model ha finished to load the stored
  /// _conversionsOrder and `state` is not empty, false otherwise.
  bool get isConversionsLoaded => state.isNotEmpty;

  /// This function get the value of the unit from currentProperty and update
  /// the currentUnitDataList values. It is used when a conversion changes the
  /// values of the units
  _refreshCurrentUnitDataList(int page) {
    List<UnitData> currentUnitDataList = state[page];
    for (UnitData currentUnitData in currentUnitDataList) {
      final currentProperty = ref.read(propertiesListProvider)[page];
      currentUnitData.unit = currentProperty.getUnit(currentUnitData.unit.name);
      if (currentUnitData != _selectedUnit) {
        if (currentUnitData.unit.stringValue == null) {
          currentUnitData.tec.text = '';
        } else {
          currentUnitData.tec.text = currentUnitData.unit.stringValue!;
        }
      }
    }
  }

  /// This function is used to convert all the values from one that has been
  /// modified
  convert(UnitData unitData, var value, int page) {
    ref.read(propertiesListProvider)[page].convert(unitData.unit.name, value);
    _selectedUnit = unitData;
    _refreshCurrentUnitDataList(page);
  }

  /// Returns a UnitDataList at a certain page with the current ordering
  /// (usefult with reorder units)
  List<UnitData> getUnitDataListAtPage(int page) => state[page];

  PROPERTYX getPropertyNameAtPage(int page) =>
      ref.read(propertiesListProvider)[page].name;

  ///Clears the values of the current page
  clearAllValues(int page) {
    List<UnitData> currentUnitDataList = state[page];
    if (currentUnitDataList[0].property == PROPERTYX.numeralSystems) {
      _savedUnitDataList = [
        ...currentUnitDataList.map((unitData) => unitData.unit.stringValue)
      ];
    } else {
      _savedUnitDataList = [
        ...currentUnitDataList.map((unitData) => unitData.unit.value)
      ];
    }
    _savedPropertyIndex = page;
    convert(currentUnitDataList[0], null, page);
    currentUnitDataList[0].tec.text =
        ''; // convert doesn't clear a selected textfield
  }

  /// Undo the last clear all operation performed
  undoClearOperation() {
    if (_savedUnitDataList != null && _savedPropertyIndex != null) {
      List<UnitData> listToUndo = state[_savedPropertyIndex!];
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
      _savedUnitDataList = _savedPropertyIndex = null;
    }
  }

  /// Returns true if we should show a snackbar when the user press on the clear
  /// all button (see [undoClearOperation]), false otherwise.
  bool shouldShowSnackbar(int page) => state[page][0].tec.text != '';

  /// Returns the DateTime of the latest update of the currencies conversions
  /// ratio (year, month, day)
  get lastUpdateCurrency => _currenciesObject.lastUpdate;

  /// Returns true if the currencies conversions ratio are not ready yet,
  /// returns false otherwise
  get isCurrenciesLoading => _isCurrenciesLoading;

  /// This method is used by _checkCurrencies to read the currencies conversions
  /// if the smartphone is offline
  _readSavedCurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currenciesRead = prefs.getString('currenciesRates');
    String? lastUpdate = prefs.getString("lastUpdateCurrencies");
    if (currenciesRead != null && lastUpdate != null) {
      _currenciesObject = CurrenciesObject.fromJson(currenciesRead, lastUpdate);
    }
  }

  /// Updates the currencies conversions ratio with the latest values. The data
  /// comes from the internet if the connection is available or from memory if
  /// the smartphone is offline
  /*_checkCurrencies() async {
    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Let's search before if we already have downloaded the exchange rates
    String? lastUpdate = prefs.getString("lastUpdateCurrencies");
    // if I have never updated the conversions or if I have updated before today
    // I have to update
    if (lastUpdate == null || lastUpdate != now) {
      await _currenciesObject.updateCurrencies();
      switch (_currenciesObject.status) {
        case CurrencyStatus.updated:
          prefs.setString('currenciesRates', _currenciesObject.toJson());
          prefs.setString('lastUpdateCurrencies', now);
          break;
        default:
          await _readSavedCurrencies();
          break;
      }
    } else {
      // If I already have the data of today I just use it, no need of read them
      // from the web
      await _readSavedCurrencies();
    }
    // stop the progress indicator to show the date of the latest update
    _isCurrenciesLoading = false;
    // we need to refresh the property list because we changed some conversions
    _initializePropertyList();
  }*/

  /// Get the orders of each units of measurement from the memory
  _checkOrdersUnits() {
    // Initialize the order for each property to default:
    // [0,1,2,...,size(property)]
    List<List<int>> temp = [];
    for (Property property in ref.read(propertiesListProvider)) {
      temp.add(List.generate(property.size, (index) => index));
    }

    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? stringList;
    // Update every order of every conversion
    for (int i = 0; i < _propertyList.length; i++) {
      stringList = prefs.getStringList('conversion_$i');
      if (stringList != null) {
        // If some units has been removed, adapt the reordering and save it.
        // It is triggered just the first time after an update
        if (_propertyList[i].size < stringList.length) {
          stringList.removeWhere(
              (element) => int.tryParse(element)! >= _propertyList[i].size);
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
    }*/
    _conversionsOrder = temp;
  }

  /// Apply the order defined in [_conversionsOrder] to [state].
  /// [state] will be redefined, so this function is used also during
  /// initialization
  List<List<UnitData>> _refreshOrderUnits() {
    assert(_conversionsOrder != null, true);
    List<List<UnitData>> tempUnitDataList = [];
    for (int i = 0; i < ref.read(propertiesListProvider).length; i++) {
      List<UnitData> tempUnitData = List.filled(_conversionsOrder![i].length,
          UnitData(Unit('none'), tec: TextEditingController()));
      Property property = ref.read(propertiesListProvider)[i];
      List<Unit> tempProperty = property.getAll();
      for (int j = 0; j < tempProperty.length; j++) {
        VALIDATOR validator;
        TextInputType textInputType;
        if (property.name == PROPERTYX.temperature) {
          switch (tempProperty[j].name) {
            // Just kelvin and rankine can't be negative
            case TEMPERATURE.kelvin:
            case TEMPERATURE.rankine:
              textInputType = const TextInputType.numberWithOptions(
                  decimal: true, signed: false);
              validator = VALIDATOR.rationalNonNegative;
              break;
            default:
              textInputType = const TextInputType.numberWithOptions(
                  decimal: true, signed: true);
              validator = VALIDATOR.rational;
          }
        } else if (property.name == PROPERTYX.numeralSystems) {
          switch (tempProperty[j].name) {
            case NUMERAL_SYSTEMS.binary:
              {
                validator = VALIDATOR.binary;
                textInputType = const TextInputType.numberWithOptions(
                    decimal: false, signed: false);
                break;
              }
            case NUMERAL_SYSTEMS.octal:
              {
                validator = VALIDATOR.octal;
                textInputType = const TextInputType.numberWithOptions(
                    decimal: false, signed: false);
                break;
              }
            case NUMERAL_SYSTEMS.decimal:
              {
                validator = VALIDATOR.decimal;
                textInputType = const TextInputType.numberWithOptions(
                    decimal: false, signed: false);
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
                textInputType = const TextInputType.numberWithOptions(
                    decimal: false, signed: false);
                validator = VALIDATOR.decimal;
              }
          }
        } else {
          textInputType = const TextInputType.numberWithOptions(
              decimal: true, signed: false);
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
      tempUnitDataList.add(tempUnitData);
    }
    return tempUnitDataList;
  }

  /// Given a new ordering of a specific page it applys it to the app and store
  /// it.
  saveOrderUnits(List<int>? newOrder, int pageNumber) async {
    assert(newOrder == null
        ? true
        : newOrder.length == _conversionsOrder![pageNumber].length);
    //if there arent't any modifications, do nothing
    if (newOrder != null) {
      List arrayCopy = List.filled(_conversionsOrder![pageNumber].length, null);
      for (int i = 0; i < _conversionsOrder![pageNumber].length; i++) {
        arrayCopy[i] = _conversionsOrder![pageNumber][i];
      }
      for (int i = 0; i < _conversionsOrder![pageNumber].length; i++) {
        _conversionsOrder![pageNumber][i] = newOrder.indexOf(arrayCopy[i]);
      }
      state = _refreshOrderUnits();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> toConvertList = [];
      for (int item in _conversionsOrder![pageNumber]) {
        toConvertList.add(item.toString());
      }
      prefs.setStringList("conversion_$pageNumber", toConvertList);
    }
  }
}

final conversionsProvider =
    NotifierProvider<ConversionsNotifier, List<List<UnitData>>>(
        ConversionsNotifier.new);
