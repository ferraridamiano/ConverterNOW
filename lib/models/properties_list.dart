import 'package:converterpro/models/settings.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:units_converter/units_converter.dart';

final propertiesListProvider = StateProvider<List<Property>>((ref) {
  var removeTrailingZeros = ref.watch(RemoveTrailingZeros.provider);
  var significantFigures = ref.watch(SignificantFigures.provider);
  return [
    Length(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.length),
    Area(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.area),
    Volume(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.volume),
    SimpleCustomProperty(
        {'EUR': 1, 'USD': 1.1}, //_currenciesObject.exchangeRates,
        //mapSymbols: _currenciesSymbols,
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.currencies), //TODO
    Time(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.time),
    Temperature(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.temperature),
    Speed(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.speed),
    Mass(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.mass),
    Force(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.force),
    FuelConsumption(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.fuelConsumption),
    NumeralSystems(name: PROPERTYX.numeralSystems),
    Pressure(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.pressure),
    Energy(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.energy),
    Power(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.power),
    Angle(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.angle),
    ShoeSize(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.shoeSize),
    DigitalData(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.digitalData),
    SIPrefixes(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.siPrefixes),
    Torque(
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.torque),
  ];
});
