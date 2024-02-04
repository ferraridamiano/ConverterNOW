import 'dart:convert';
import 'package:converterpro/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Currencies {
  static const defaultExchangeRates = {
    'EUR': 1.0,
    'AUD': 1.5586,
    'BGN': 1.9558,
    'BRL': 5.5512,
    'CAD': 1.4494,
    'CHF': 1.0051,
    'CNY': 7.2729,
    'CZK': 24.011,
    'DKK': 7.4387,
    'GBP': 0.888,
    'HKD': 8.4471,
    'HUF': 396.96,
    'IDR': 16412.0,
    'ILS': 3.7032,
    'INR': 88.096,
    'ISK': 154.3,
    'JPY': 139.02,
    'KRW': 1343.41,
    'MXN': 20.4391,
    'MYR': 4.689,
    'NOK': 10.6945,
    'NZD': 1.7014,
    'PHP': 59.44,
    'PLN': 4.6888,
    'RON': 4.9423,
    'SEK': 11.2528,
    'SGD': 1.4311,
    'THB': 35.751,
    'TRY': 20.3196,
    'USD': 1.0814,
    'ZAR': 18.2482,
  };

  /// The conversion rates with respect to EUR
  Map<String, double> exchangeRates;

  /// The date of the last update encoded as 'yyyy-mm-dd'
  String lastUpdate;

  Currencies({
    this.exchangeRates = defaultExchangeRates,
    this.lastUpdate = '2023-01-13',
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

final currenciesProvider = FutureProvider<Currencies>((ref) async {
  var pref = await ref.watch(sharedPref.future);

  Currencies readSavedCurrencies() {
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
  Future<Currencies> downloadCurrencies() async {
    // stringRequest prepares the string request for all the currencies
    String stringRequest = '';
    for (String currency in Currencies().exchangeRates.keys) {
      if (currency != 'EUR') {
        stringRequest += '$currency+';
      }
    }
    // removes the last '+'
    stringRequest = stringRequest.substring(0, stringRequest.length - 1);
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
      debugPrint(e.toString());
    }
    return readSavedCurrencies();
  }

  final String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  // Let's search before if we already have downloaded the exchange rates
  String? lastUpdate = pref.getString("lastUpdateCurrencies");
  // if I have never updated the conversions or if I have updated before today
  // I have to update
  if (!(ref.read(RevokeInternetNotifier.provider).valueOrNull ?? false) &&
      (lastUpdate == null || lastUpdate != now)) {
    return downloadCurrencies();
  }
  // If I already have the data of today I just use it, no need of read them
  // from the web
  return readSavedCurrencies();
});
