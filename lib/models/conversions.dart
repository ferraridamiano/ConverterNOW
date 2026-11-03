import 'package:converterpro/models/order.dart';
import 'package:converterpro/models/properties_list.dart';
import 'package:converterpro/models/settings.dart';
import 'package:converterpro/utils/number_format.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:units_converter/units_converter.dart';

class ConversionsNotifier
    extends AsyncNotifier<Map<PROPERTYX, List<UnitData>>> {
  static final provider =
      AsyncNotifierProvider<
        ConversionsNotifier,
        Map<PROPERTYX, List<UnitData>>
      >(ConversionsNotifier.new);

  @override
  Future<Map<PROPERTYX, List<UnitData>>> build() async {
    final conversionsOrder = (await ref.watch(
      UnitsOrderNotifier.provider.future,
    ));
    final propertiesMap = await ref.watch(propertiesMapProvider.future);
    final previousState = state.value;

    // If the language changed, the decimal/grouping separators may have
    // changed too (e.g. from "." to ","), so we update the text currently
    // displayed by the textfields. The same happens when the thousands
    // separator setting is toggled.
    final decimalSeparator = ref.watch(decimalSeparatorProvider);
    final groupingSeparator = ref.watch(groupingSeparatorProvider);
    final thousandsSeparator =
        await ref.watch(thousandsSeparatorProvider.future) ?? true;
    final bool formattingChanged =
        decimalSeparator != _lastSeparator ||
        groupingSeparator != _lastGroupingSeparator ||
        thousandsSeparator != _lastThousandsSeparator;
    if (previousState != null && formattingChanged) {
      for (final entry in previousState.entries) {
        if (entry.key == PROPERTYX.numeralSystems) {
          for (final unitData in entry.value) {
            if (unitData.validator != VALIDATOR.binary) continue;
            final text = unitData.tec.value.text;
            if (text.isEmpty) continue;
            final newText = formatBinary(text, grouping: thousandsSeparator);
            if (newText != text) {
              unitData.tec.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length),
              );
            }
          }
          continue;
        }
        for (final unitData in entry.value) {
          final String text = unitData.tec.value.text;
          if (text.isNotEmpty) {
            // First normalize the old text, then apply the new separators.
            final raw = normalizeNumber(
              text,
              decimalSeparator: _lastSeparator,
              groupingSeparator: _lastThousandsSeparator
                  ? _lastGroupingSeparator
                  : null,
            );
            final newText = formatCanonicalNumber(
              raw,
              decimalSeparator: decimalSeparator,
              groupingSeparator: thousandsSeparator ? groupingSeparator : null,
            );
            unitData.tec.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: newText.length),
            );
          }
        }
      }
    }
    _lastSeparator = decimalSeparator;
    _lastGroupingSeparator = groupingSeparator;
    _lastThousandsSeparator = thousandsSeparator;

    return conversionsOrder.map((propertyx, orderedUnits) {
      final previousList = previousState?[propertyx];
      final previousMap = {
        for (final ud in previousList ?? <UnitData>[]) ud.unit.name: ud,
      };

      return MapEntry(
        propertyx,
        orderedUnits.map((e) {
          final existing = previousMap[e];
          if (existing != null) {
            return existing;
          }
          return UnitData(
            propertiesMap[propertyx]!.getUnit(e),
            tec: TextEditingController(),
            property: propertyx,
            textInputType: switch (e) {
              TEMPERATURE.celsius ||
              TEMPERATURE.fahrenheit ||
              TEMPERATURE.delisle ||
              TEMPERATURE.reamur ||
              TEMPERATURE.romer => const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              NUMERAL_SYSTEMS.binary ||
              NUMERAL_SYSTEMS.octal ||
              NUMERAL_SYSTEMS.decimal => const TextInputType.numberWithOptions(
                decimal: false,
                signed: false,
              ),
              NUMERAL_SYSTEMS.hexadecimal => TextInputType.text,
              _ => const TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
            },
            validator: switch (e) {
              TEMPERATURE.celsius ||
              TEMPERATURE.fahrenheit ||
              TEMPERATURE.delisle ||
              TEMPERATURE.reamur ||
              TEMPERATURE.romer => VALIDATOR.rational,
              NUMERAL_SYSTEMS.binary => VALIDATOR.binary,
              NUMERAL_SYSTEMS.octal => VALIDATOR.octal,
              NUMERAL_SYSTEMS.decimal => VALIDATOR.decimal,
              NUMERAL_SYSTEMS.hexadecimal => VALIDATOR.hexadecimal,
              _ => VALIDATOR.rationalNonNegative,
            },
          );
        }).toList(),
      );
    });
  }

  String _lastSeparator = '.'; //separator used the last time build() was run
  String _lastGroupingSeparator = ',';
  bool _lastThousandsSeparator = true;

  /// The list of values that has been just cleared out
  List<dynamic>? _savedUnitDataList;

  /// Which [PROPERTYX] has been just cleared
  PROPERTYX? _savedProperty;

  UnitData? _selectedUnit; //unit where the user is writing the value

  /// This function get the value of the unit from currentProperty and update
  /// the currentUnitDataList values. It is used when a conversion changes the
  /// values of the units
  Future<void> _refreshCurrentUnitDataList(PROPERTYX property) async {
    final currentUnitDataList = state.value![property]!;
    final propertiesMap = await ref.read(propertiesMapProvider.future);
    final decimalSeparator = ref.read(decimalSeparatorProvider);
    final groupingSeparator = ref.read(groupingSeparatorProvider);
    final thousandsSeparator =
        ref.read(thousandsSeparatorProvider).value ?? true;
    for (UnitData currentUnitData in currentUnitDataList) {
      final currentProperty = propertiesMap[property]!;
      currentUnitData.unit = currentProperty.getUnit(currentUnitData.unit.name);
      if (currentUnitData != _selectedUnit) {
        final stringValue = currentUnitData.unit.stringValue;
        if (stringValue == null) {
          currentUnitData.tec.value = TextEditingValue.empty;
        } else {
          final String text;
          if (currentUnitData.validator == VALIDATOR.binary) {
            text = formatBinary(stringValue, grouping: thousandsSeparator);
          } else if (property == PROPERTYX.numeralSystems) {
            text = stringValue;
          } else {
            text = formatNumber(
              stringValue,
              decimalSeparator: decimalSeparator,
              groupingSeparator: thousandsSeparator ? groupingSeparator : null,
            );
          }
          currentUnitData.tec.value = TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        }
      }
    }
  }

  /// This function is used to convert all the values from one that has been
  /// modified
  Future<void> convert(UnitData unitData, var value, PROPERTYX property) async {
    final propertiesMap = await ref.read(propertiesMapProvider.future);
    propertiesMap[property]!.convert(unitData.unit.name, value);
    _selectedUnit = unitData;
    await _refreshCurrentUnitDataList(property);
  }

  /// Returns a UnitDataList at a certain page with the current ordering
  /// (usefult with reorder units)
  List<UnitData> getUnitDataListAtPage(PROPERTYX property) =>
      state.value![property]!;

  ///Clears the values of the current page
  Future<void> clearAllValues(PROPERTYX property) async {
    List<UnitData> currentUnitDataList = state.value![property]!;
    if (currentUnitDataList[0].property == PROPERTYX.numeralSystems) {
      _savedUnitDataList = [
        ...currentUnitDataList.map((unitData) => unitData.unit.stringValue),
      ];
    } else {
      _savedUnitDataList = [
        ...currentUnitDataList.map((unitData) => unitData.unit.value),
      ];
    }
    _savedProperty = property;
    await convert(currentUnitDataList[0], null, property);
    // convert doesn't clear a selected textfield
    currentUnitDataList[0].tec.value = TextEditingValue.empty;
  }

  /// Undo the last clear all operation performed
  Future<void> undoClearOperation() async {
    if (_savedUnitDataList != null && _savedProperty != null) {
      List<UnitData> listToUndo = state.value![_savedProperty!]!;
      if (_savedUnitDataList![0] is double) {
        final decimalSeparator = ref.read(decimalSeparatorProvider);
        final groupingSeparator = ref.read(groupingSeparatorProvider);
        final thousandsSeparator =
            ref.read(thousandsSeparatorProvider).value ?? true;
        for (int i = 0; i < listToUndo.length; i++) {
          final text = formatNumber(
            swapDecimalSeparator(
              _savedUnitDataList![i].toString(),
              decimalSeparator,
            ),
            decimalSeparator: decimalSeparator,
            groupingSeparator: thousandsSeparator ? groupingSeparator : null,
          );
          listToUndo[i]
            ..unit.value = _savedUnitDataList![i]
            ..tec.value = TextEditingValue(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
        }
      } else if (_savedUnitDataList![0] is String) {
        final thousandsSeparator =
            ref.read(thousandsSeparatorProvider).value ?? true;
        for (int i = 0; i < listToUndo.length; i++) {
          final value = _savedUnitDataList![i] as String;
          final text = listToUndo[i].validator == VALIDATOR.binary
              ? formatBinary(value, grouping: thousandsSeparator)
              : value;
          listToUndo[i]
            ..unit.stringValue = value
            ..tec.value = TextEditingValue(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
        }
      }
      _savedUnitDataList = _savedProperty = null;
    }
  }

  /// Returns true if we should show a snackbar when the user press on the clear
  /// all button (see [undoClearOperation]), false otherwise.
  bool shouldShowSnackbar(PROPERTYX property) =>
      state.value![property]![0].tec.value.text != '';
}
