import 'package:converterpro/utils/UnitsData.dart';
import 'package:converterpro/utils/UtilsConversion.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "dart:convert";
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Conversions with ChangeNotifier {

  static List<Node> _conversionsList;
  DateTime _lastUpdateCurrencies = DateTime(2019, 10, 29);
  Map<String, double> _currencyValues={"CAD":1.4487,"HKD":8.6923,"RUB":70.5328,"PHP":56.731,"DKK":7.4707,"NZD":1.7482,"CNY":7.8366,"AUD":1.6245,"RON":4.7559,"SEK":10.7503,"IDR":15536.21,"INR":78.4355,"BRL":4.4158,"USD":1.1087,"ILS":3.9187,"JPY":120.69,"THB":33.488,"CHF":1.1047,"CZK":25.48,"MYR":4.641,"TRY":6.3479,"MXN":21.1244,"NOK":10.2105,"HUF":328.16,"ZAR":16.1202,"SGD":1.5104,"GBP":0.86328,"KRW":1297.1,"PLN":4.2715};
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  static List _orderLunghezza=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  static List _orderSuperficie=[0,1,2,3,4,5,6,7,8,9,10];
  static List _orderVolume=[0,1,2,3,4,5,6,7,8,9,10,11,12,13];
  static List _orderTempo=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14];
  static List _orderTemperatura=[0,1,2,3,4,5,6];
  static List _orderVelocita=[0,1,2,3,4];
  static List _orderPrefissi=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
  static List _orderMassa=[0,1,2,3,4,5,6,7,8,9,10];
  static List _orderPressione=[0,1,2,3,4,5];
  static List _orderEnergia=[0,1,2,3];
  static List _orderAngoli=[0,1,2,3];
  static List _orderValute=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
  static List _orderScarpe=[0,1,2,3,4,5,6,7,8,9];
  static List _orderDati=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26];
  static List _orderPotenza=[0,1,2,3,4,5,6];
  static List _orderForza=[0,1,2,3,4];
  static List _orderTorque=[0,1,2,3,4];
  static List _orderConsumo=[0,1,2,3];
  static List _orderBasi=[0,1,2,3];
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  static List _conversionsOrder=[_orderLunghezza,_orderSuperficie, _orderVolume,_orderTempo,_orderTemperatura,_orderVelocita,_orderPrefissi,_orderMassa,_orderPressione,_orderEnergia,
  _orderAngoli, _orderValute, _orderScarpe, _orderDati, _orderPotenza, _orderForza, _orderTorque, _orderConsumo, _orderBasi];
  bool _isCurrenciesLoading = true;

  Conversions() {
    _checkCurrencies();   //update the currencies with the latest conversions rates and then
  }

  get conversionsList{
    //if _conversionsList is initialized it returns it
    if(_conversionsList != null)
      return _conversionsList;
    //otherwise it will be initialized and it returns it
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues);
    return _conversionsList;
  }

  ///Returns the order of the units of measurement of every conversions
  get conversionsOrder => _conversionsOrder;

  ///Returns the DateTime of the latest update of the currencies conversions
  ///ratio (year, month, day)
  get lastUpdateCurrency => _lastUpdateCurrencies;

  ///Returns a Map<String, double> of the latest currencies rate referred
  ///to the euro
  get currencyValues => _currencyValues;

  ///returns true if the currencies conversions ratio are not ready yet,
  ///returns false otherwise
  get isCurrenciesLoading => _isCurrenciesLoading;

  ///This method is used by _checkCurrencies to read the currencies conversions if
  ///the smartphone is offline
  _readSavedCurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currencyRead = prefs.getString("currencyRates");
    if(currencyRead!=null){
      CurrencyJSONObject currencyObject = new CurrencyJSONObject.fromJson(json.decode(currencyRead));
      _currencyValues = currencyObject.rates;
      String lastUpdateRead = currencyObject.date;
      if(lastUpdateRead != null)
        _lastUpdateCurrencies = DateTime.parse(lastUpdateRead);
    }
    
  }

  ///Updates the currencies conversions ratio with the latest values. The data comes from
  ///the internet if the connection is available or from memory if the smartphone is offline
  _checkCurrencies() async {
    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String dataFetched = prefs.getString("currencyRates");
    if(dataFetched==null || CurrencyJSONObject.fromJson(json.decode(dataFetched)).date!=now){//se non ho mai aggiornato oppure se non aggiorno la lista da piú di un giorno allora aggiorno
      try{
        var response = await http.get('https://api.exchangeratesapi.io/latest?symbols=USD,GBP,INR,CNY,JPY,CHF,SEK,RUB,CAD,KRW,BRL,HKD,AUD,NZD,MXN,SGD,NOK,TRY,ZAR,DKK,PLN,THB,MYR,HUF,CZK,ILS,IDR,PHP,RON');
        if (response.statusCode == 200) { //if successful
          CurrencyJSONObject currencyObject = new CurrencyJSONObject.fromJson(json.decode(response.body));
          _currencyValues = currencyObject.rates;
          //If the request recive an accettable response the last update is now
          _lastUpdateCurrencies = DateTime.now();
          //save to memory
          prefs.setString("currencyRates", response.body);
        }
        else  //if there's some error in the data read (e.g. I'm not connected)
          _readSavedCurrencies();//read the saved data
      }catch(e){//catch communication error
        print(e);
        _readSavedCurrencies(); //read the saved data
      }
    }
    else{  //If I already have the data of today I just use it, no need of read them from the web
      _readSavedCurrencies();
      _lastUpdateCurrencies = DateTime.now();
    }
    _isCurrenciesLoading = false; // stop the progress indicator to show the date of the latest update
    notifyListeners();    //change the value of the current conversions
  }

  _getOrdersUnita() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List <String> stringList;
      //Update every order of every conversion
    for(int i=0; i<conversionsList.length; i++){
      stringList = prefs.getStringList("conversion_$i");
      if(stringList!=null){
        final int len=stringList.length;
        List intList=new List();
        for(int j=0;j<len;j++){
          intList.add(int.parse(stringList[j]));
        }
        //risolve il problema di aggiunta di unità dopo un aggiornamento
        for(int j=len; j<_conversionsOrder[i].length;j++)     
          intList.add(j);
          
        /*if(i==currentPage){
          setState(() {
            listaOrder[i]=intList;
          });
        }*/
        /*else
          listaOrder[i]=intList;*/
        }
      }
  }
}