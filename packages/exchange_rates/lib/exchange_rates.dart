import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

enum CurrencyStatus { outdated, error, updated }

class CurrenciesObject {
  /// String representation of the last update in a yyyy-mm-dd format
  String lastUpdateString = '2021-12-08';

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
    'AUD': 1.5841,
    'BGN': 1.9558,
    'BRL': 6.335,
    'CAD': 1.4281,
    'CHF': 1.0432,
    'CNY': 7.1726,
    'CZK': 25.475,
    'DKK': 7.4362,
    'GBP': 0.85603,
    'HKD': 8.8088,
    'HRK': 7.525,
    'HUF': 368.13,
    'IDR': 16205.54,
    'ILS': 3.5176,
    'INR': 85.2345,
    'ISK': 147.4,
    'JPY': 128.57,
    'KRW': 1328.25,
    'MAD': 10.7485,
    'MXN': 23.6365,
    'MYR': 4.7733,
    'NOK': 10.096,
    'NZD': 1.6659,
    'PHP': 56.784,
    'PLN': 4.5962,
    'RON': 4.9488,
    'RUB': 83.3019,
    'SEK': 10.2513,
    'SGD': 1.5415,
    'THB': 37.829,
    'TRY': 15.4796,
    'TWD': 33.4243,
    'USD': 1.1299,
    'ZAR': 17.8168,
  };

  CurrenciesObject() {
    lastUpdate = DateTime.parse(lastUpdateString);
  }

  /// It transforms a previous stored data (with the toJson method) into this
  /// object
  CurrenciesObject.fromJson(Map<String, double> jsonData, String lastUpdate) {
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

/*Future<void> main(List<String> args) async {
  CurrenciesObject object = CurrenciesObject();
  print(object.exchangeRates);
  print(object.lastUpdate);
  print(object.status);
  print('-----------------------------------------');
  await object.updateCurrencies();
  print(object.exchangeRates);
  print(object.lastUpdate);
  print(object.status);
}*/