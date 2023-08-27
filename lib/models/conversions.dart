import 'package:converterpro/models/order.dart';
import 'package:converterpro/models/properties_list.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:units_converter/units_converter.dart';

class ConversionsNotifier extends AsyncNotifier<List<List<UnitData>>> {
  static final provider =
      AsyncNotifierProvider<ConversionsNotifier, List<List<UnitData>>>(
          ConversionsNotifier.new);

  @override
  Future<List<List<UnitData>>> build() async {
    List<List<int>> conversionsOrder =
        (await ref.watch(UnitsOrderNotifier.provider.future));

    List<Property> propertiesList =
        await ref.watch(propertiesListProvider.future);

    List<List<UnitData>> tempUnitDataList = [];
    for (int i = 0; i < propertiesList.length; i++) {
      List<UnitData> tempUnitData = List.filled(conversionsOrder[i].length,
          UnitData(Unit('none'), tec: TextEditingController()));
      Property property = propertiesList[i];
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

        tempUnitData[conversionsOrder[i][j]] = UnitData(
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

  /// Contains the List of the double (or String for numeral systems conversion)
  /// saved before the clear all operation. This need to be done in order to
  /// undo the clear all operation
  List<dynamic>? _savedUnitDataList;

  /// This contains the value of [_currentPage] when a clear all operation (and
  /// the corresponding value saving) is performed
  int? _savedPropertyIndex;

  UnitData? _selectedUnit; //unit where the user is writing the value

  /// This function get the value of the unit from currentProperty and update
  /// the currentUnitDataList values. It is used when a conversion changes the
  /// values of the units
  void _refreshCurrentUnitDataList(int page) {
    List<UnitData> currentUnitDataList = state.value![page];
    ref.read(propertiesListProvider.future).then((propertiesList) {
      for (UnitData currentUnitData in currentUnitDataList) {
        final currentProperty = propertiesList[page];
        currentUnitData.unit =
            currentProperty.getUnit(currentUnitData.unit.name);
        if (currentUnitData != _selectedUnit) {
          if (currentUnitData.unit.stringValue == null) {
            currentUnitData.tec.text = '';
          } else {
            currentUnitData.tec.text = currentUnitData.unit.stringValue!;
          }
        }
      }
    });
  }

  /// This function is used to convert all the values from one that has been
  /// modified
  void convert(UnitData unitData, var value, int page) {
    ref.read(propertiesListProvider.future).then((propertiesList) {
      propertiesList[page].convert(unitData.unit.name, value);
      _selectedUnit = unitData;
      _refreshCurrentUnitDataList(page);
    });
  }

  /// Returns a UnitDataList at a certain page with the current ordering
  /// (usefult with reorder units)
  List<UnitData> getUnitDataListAtPage(int page) => state.value![page];

  ///Clears the values of the current page
  clearAllValues(int page) {
    List<UnitData> currentUnitDataList = state.value![page];
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
      List<UnitData> listToUndo = state.value![_savedPropertyIndex!];
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
  bool shouldShowSnackbar(int page) => state.value![page][0].tec.text != '';
}
