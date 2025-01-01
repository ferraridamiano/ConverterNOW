import 'package:converterpro/models/currencies.dart';
import 'package:converterpro/models/settings.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:units_converter/units_converter.dart';

const Map<String, String> _currenciesSymbols = {
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

final propertiesMapProvider =
    FutureProvider<Map<PROPERTYX, Property>>((ref) async {
  final removeTrailingZeros =
      await ref.watch(RemoveTrailingZeros.provider.future);
  final significantFigures =
      await ref.watch(SignificantFigures.provider.future);
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
