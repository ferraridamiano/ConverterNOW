import 'package:converterpro/models/currencies.dart';
import 'package:converterpro/models/settings.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:units_converter/units_converter.dart';

const Map<String, String> _currenciesSymbols = {
  'EUR': '€ assets/flags/eu.png',
  'CAD': '\$ assets/flags_opti/ca.svg.vec',
  'HKD': 'HK\$ assets/flags_opti/hk.svg.vec',
  'PHP': '₱ assets/flags_opti/ph.svg.vec',
  'DKK': 'kr assets/flags_opti/dk.svg.vec',
  'NZD': 'NZ\$ assets/flags/nz.png',
  'CNY': '¥ assets/flags_opti/cn.svg.vec',
  'AUD': 'A\$ assets/flags_opti/au.svg.vec',
  'RON': 'L assets/flags_opti/ro.svg.vec',
  'SEK': 'kr assets/flags_opti/se.svg.vec',
  'IDR': 'Rp assets/flags_opti/id.svg.vec',
  'INR': '₹ assets/flags/in.png',
  'BRL': 'R\$ assets/flags/br.png',
  'USD': '\$ assets/flags/us.png',
  'ILS': '₪ assets/flags_opti/il.svg.vec',
  'JPY': '¥ assets/flags_opti/jp.svg.vec',
  'THB': '฿ assets/flags_opti/th.svg.vec',
  'CHF': 'Fr. assets/flags_opti/ch.svg.vec',
  'CZK': 'Kč assets/flags_opti/cz.svg.vec',
  'MYR': 'RM assets/flags_opti/my.svg.vec',
  'TRY': '₺ assets/flags_opti/tr.svg.vec',
  'MXN': '\$ assets/flags/mx.png',
  'NOK': 'kr assets/flags_opti/no.svg.vec',
  'HUF': 'Ft assets/flags_opti/hu.svg.vec',
  'ZAR': 'R assets/flags_opti/za.svg.vec',
  'SGD': 'S\$ assets/flags_opti/sg.svg.vec',
  'GBP': '£ assets/flags_opti/gb.svg.vec',
  'KRW': '₩ assets/flags_opti/kr.svg.vec',
  'PLN': 'zł assets/flags_opti/pl.svg.vec',
  'ISK': 'kr assets/flags_opti/is.svg.vec',
};

final propertiesMapProvider =
    FutureProvider<Map<PROPERTYX, Property>>((ref) async {
  final removeTrailingZeros =
      (await ref.watch(removeTrailingZerosProvider.future))!;
  final significantFigures =
      (await ref.watch(significantFiguresProvider.future))!;
  return {
    PROPERTYX.length: Length(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.length,
    ),
    PROPERTYX.area: Area(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.area,
    ),
    PROPERTYX.density: Density(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.density,
    ),
    PROPERTYX.volume: Volume(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.volume,
    ),
    PROPERTYX.currencies: SimpleCustomProperty(
      ref.watch(CurrenciesNotifier.provider).when(
          data: (currencies) => currencies.exchangeRates,
          error: (_, trace) => Currencies.defaultExchangeRates,
          loading: () => Currencies.defaultExchangeRates),
      mapSymbols: _currenciesSymbols,
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.currencies,
    ),
    PROPERTYX.time: Time(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.time,
    ),
    PROPERTYX.temperature: Temperature(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.temperature,
    ),
    PROPERTYX.speed: Speed(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.speed,
    ),
    PROPERTYX.mass: Mass(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.mass,
    ),
    PROPERTYX.force: Force(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.force,
    ),
    PROPERTYX.fuelConsumption: FuelConsumption(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.fuelConsumption,
    ),
    PROPERTYX.numeralSystems: NumeralSystems(name: PROPERTYX.numeralSystems),
    PROPERTYX.pressure: Pressure(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.pressure,
    ),
    PROPERTYX.energy: Energy(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.energy,
    ),
    PROPERTYX.power: Power(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.power,
    ),
    PROPERTYX.angle: Angle(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.angle,
    ),
    PROPERTYX.shoeSize: ShoeSize(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.shoeSize,
    ),
    PROPERTYX.digitalData: DigitalData(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.digitalData,
    ),
    PROPERTYX.siPrefixes: SIPrefixes(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.siPrefixes,
    ),
    PROPERTYX.torque: Torque(
      significantFigures: significantFigures,
      removeTrailingZeros: removeTrailingZeros,
      name: PROPERTYX.torque,
    ),
  };
});
