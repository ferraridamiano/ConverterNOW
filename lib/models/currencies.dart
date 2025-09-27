import 'dart:convert';
import 'package:converterpro/models/settings.dart';
import 'package:converterpro/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Currencies {
  static const defaultExchangeRates = {
    'EUR': 1.0,
    'AUD': 1.6514,
    'BGN': 1.9558,
    'BRL': 6.0127,
    'CAD': 1.4856,
    'CHF': 0.9442,
    'CNY': 7.6141,
    'CZK': 25.043,
    'DKK': 7.459,
    'GBP': 0.83215,
    'HKD': 8.1554,
    'HUF': 402.95,
    'IDR': 16980.33,
    'ILS': 3.7341,
    'INR': 90.81,
    'ISK': 147.3,
    'JPY': 160.09,
    'KRW': 1509.5,
    'MXN': 21.3146,
    'MYR': 4.647,
    'NOK': 11.6515,
    'NZD': 1.8352,
    'PHP': 60.487,
    'PLN': 4.1653,
    'RON': 4.977,
    'SEK': 11.2445,
    'SGD': 1.4052,
    'THB': 35.238,
    'TRY': 37.9486,
    'USD': 1.0478,
    'ZAR': 19.2555,
  };

  /// The conversion rates with respect to EUR
  Map<String, double> exchangeRates;

  /// The date of the last update encoded as 'yyyy-mm-dd'
  String lastUpdate;

  Currencies({
    this.exchangeRates = defaultExchangeRates,
    this.lastUpdate = '2025-02-15',
  });

  /// Transform the exchangeRates map into a json that can be stored
  String toJson() => jsonEncode(exchangeRates);

  /// It transforms a previous stored data (with the toJson method) into this
  /// object
  factory Currencies.fromJson(String jsonString) {
    var exchangeRates = Map<String, double>.from(defaultExchangeRates);
    Map jsonData = json.decode(jsonString);
    for (String key in jsonData.keys) {
      exchangeRates[key] = jsonData[key];
    }
    return Currencies(exchangeRates: exchangeRates);
  }

  Currencies copyWith({
    Map<String, double>? exchangeRates,
    String? lastUpdate,
  }) {
    return Currencies(
      exchangeRates: exchangeRates ?? this.exchangeRates,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

class CurrenciesNotifier extends AsyncNotifier<Currencies> {
  static final provider = AsyncNotifierProvider<CurrenciesNotifier, Currencies>(
      CurrenciesNotifier.new);
  late SharedPreferencesWithCache pref;

  @override
  Future<Currencies> build() async {
    pref = await ref.read(sharedPref.future);

    final String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    // Let's search before if we already have downloaded the exchange rates
    String? lastUpdate = pref.getString("lastUpdateCurrencies");
    // if I have never updated the conversions or if I have updated before today
    // I have to update
    if (!(ref.read(RevokeInternetNotifier.provider).value ?? false) &&
        (lastUpdate == null || lastUpdate != now)) {
      return _downloadCurrencies();
    }
    // If I already have the data of today I just use it, no need of read them
    // from the web
    return _readSavedCurrencies();
  }

  void forceCurrenciesDownload() async {
    state = AsyncData(await _downloadCurrencies());
  }

  Currencies _readSavedCurrencies() {
    String? lastUpdate = pref.getString('lastUpdateCurrencies');
    String? currenciesRead = pref.getString('currenciesRates');
    if (currenciesRead != null) {
      return Currencies.fromJson(currenciesRead)
          .copyWith(lastUpdate: lastUpdate);
    }
    return Currencies();
  }

  /// Updates the currencies exchange rates with the latest values. It will also
  /// update the status at the end (updated or error)
  Future<Currencies> _downloadCurrencies() async {
    final stringRequest =
        Currencies.defaultExchangeRates.keys.where((e) => e != 'EUR').join('+');
    try {
      var response = await http.get(
        Uri.https(
          'data-api.ecb.europa.eu',
          'service/data/EXR/D.$stringRequest.EUR.SP00.A',
          {'lastNObservations': '1', 'detail': 'dataonly', 'format': 'csvdata'},
        ),
      );

      // if successful
      if (response.statusCode == 200) {
        var lastUpdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        Map<String, double> exchangeRates = {'EUR': 1};
        final rows = const LineSplitter().convert(response.body);
        final tableHeader = rows[0].split(',');
        final valueIndex = tableHeader.indexOf('OBS_VALUE');
        final currencyIndex = tableHeader.indexOf('CURRENCY');
        rows.removeAt(0);
        for (var row in rows) {
          final elements = row.split(',');
          final currency = elements[currencyIndex];
          final value = double.parse(elements[valueIndex]);
          exchangeRates[currency] = value;
        }
        pref.setString('currenciesRates', jsonEncode(exchangeRates));
        pref.setString('lastUpdateCurrencies', lastUpdate);
        return Currencies(
          exchangeRates: exchangeRates,
          lastUpdate: lastUpdate,
        );
      }
    } catch (e) {
      dPrint(e.toString);
    }
    return _readSavedCurrencies();
  }
}
