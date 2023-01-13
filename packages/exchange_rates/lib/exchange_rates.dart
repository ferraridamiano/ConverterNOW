import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

enum CurrencyStatus { outdated, error, updated }

class CurrenciesObject {
  /// String representation of the last update in a yyyy-mm-dd format
  String lastUpdateString = '2023-01-13';

  /// DateTime representation of the last update
  late DateTime lastUpdate;

  /// Status of the current exchange rates:
  /// - outdated: values that are inserted in code
  /// - error: unable to update the exchange rates (e.g. no internet connection)
  /// - updated: the values are retrieved from internet and are updated
  CurrencyStatus status = CurrencyStatus.outdated;

  /// A map that represent the exchange rates of the currencies (ISO code) with
  /// resepct to Euro
  Map<String, double> exchangeRates = {
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

  CurrenciesObject() {
    lastUpdate = DateTime.parse(lastUpdateString);
  }

  /// It transforms a previous stored data (with the toJson method) into this
  /// object
  CurrenciesObject.fromJson(String jsonString, String lastUpdate) {
    Map jsonData = json.decode(jsonString);
    lastUpdateString = lastUpdate;
    this.lastUpdate = DateTime.parse(lastUpdateString);
    exchangeRates = Map.from(jsonData);
  }

  /// Transform the exchangeRates map into a json that can be stored
  String toJson() => jsonEncode(exchangeRates);

  /// Updates the currencies exchange rates with the latest values. It will also
  /// update the status at the end (updated or error)
  updateCurrencies() async {
    // stringRequest prepares the string request for all the currencies
    String stringRequest = '';
    for (String currency in exchangeRates.keys) {
      if (currency != 'EUR') {
        stringRequest += '$currency+';
      }
    }
    // removes the last '+'
    stringRequest = stringRequest.substring(0, stringRequest.length - 1);
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
      // if successful
      if (httpResponse.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(httpResponse.body);

        lastUpdateString = DateFormat("yyyy-MM-dd").format(DateTime.now());
        lastUpdate = DateTime.parse(lastUpdateString);
        for (int i = 0; i < exchangeRates.length - 1; i++) {
          //-1 because in this list there is not EUR because it is the base unit
          double value = jsonData['dataSets'][0]['series']['0:$i:0:0:0']
                  ['observations']
              .values
              .first[0]
              .toDouble();
          String name = jsonData['structure']['dimensions']['series'][1]
              ['values'][i]['id'];
          exchangeRates[name] = value;
        }
        status = CurrencyStatus.updated;
      } else {
        status = CurrencyStatus.error;
      }
    } catch (e) {
      status = CurrencyStatus.error;
    }
  }
}

/*
/// Code for retrieving updated exchange rates.
Future<void> main(List<String> args) async {
  CurrenciesObject object = CurrenciesObject();
  await object.updateCurrencies();
  Map<String, double> exchangeRates = object.exchangeRates;
  for (String key in exchangeRates.keys) {
    print('\'$key\': ${exchangeRates[key]},');
  }
  print(object.lastUpdate);
  print(object.status);
}
*/
