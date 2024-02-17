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

final propertiesListProvider = FutureProvider<List<Property>>((ref) async {
  var removeTrailingZeros =
      await ref.watch(RemoveTrailingZeros.provider.future);
  var significantFigures = await ref.watch(SignificantFigures.provider.future);
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
        ref.watch(CurrenciesNotifier.provider).when(
            data: (currencies) => currencies.exchangeRates,
            error: (_, trace) => Currencies.defaultExchangeRates,
            loading: () => Currencies.defaultExchangeRates),
        mapSymbols: _currenciesSymbols,
        significantFigures: significantFigures,
        removeTrailingZeros: removeTrailingZeros,
        name: PROPERTYX.currencies),
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
