import 'package:converterpro/pages/ReorderPage.dart';
import 'package:converterpro/utils/UnitsData.dart';
import 'package:converterpro/utils/UtilsConversion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "dart:convert";
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Conversions with ChangeNotifier {

  List<Node> _conversionsList;
  DateTime _lastUpdateCurrencies = DateTime(2019, 10, 29);
  Map<String, double> _currencyValues={"CAD":1.4487,"HKD":8.6923,"RUB":70.5328,"PHP":56.731,"DKK":7.4707,"NZD":1.7482,"CNY":7.8366,"AUD":1.6245,"RON":4.7559,"SEK":10.7503,"IDR":15536.21,"INR":78.4355,"BRL":4.4158,"USD":1.1087,"ILS":3.9187,"JPY":120.69,"THB":33.488,"CHF":1.1047,"CZK":25.48,"MYR":4.641,"TRY":6.3479,"MXN":21.1244,"NOK":10.2105,"HUF":328.16,"ZAR":16.1202,"SGD":1.5104,"GBP":0.86328,"KRW":1297.1,"PLN":4.2715};
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  static List<int> _orderLunghezza=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  static List<int> _orderSuperficie=[0,1,2,3,4,5,6,7,8,9,10];
  static List<int> _orderVolume=[0,1,2,3,4,5,6,7,8,9,10,11,12,13];
  static List<int> _orderTempo=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14];
  static List<int> _orderTemperatura=[0,1,2,3,4,5,6];
  static List<int> _orderVelocita=[0,1,2,3,4];
  static List<int> _orderPrefissi=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
  static List<int> _orderMassa=[0,1,2,3,4,5,6,7,8,9,10];
  static List<int> _orderPressione=[0,1,2,3,4,5];
  static List<int> _orderEnergia=[0,1,2,3];
  static List<int> _orderAngoli=[0,1,2,3];
  static List<int> _orderValute=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
  static List<int> _orderScarpe=[0,1,2,3,4,5,6,7,8,9];
  static List<int> _orderDati=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26];
  static List<int> _orderPotenza=[0,1,2,3,4,5,6];
  static List<int> _orderForza=[0,1,2,3,4];
  static List<int> _orderTorque=[0,1,2,3,4];
  static List<int> _orderConsumo=[0,1,2,3];
  static List<int> _orderBasi=[0,1,2,3];
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  static List<List<int>> _conversionsOrder=[_orderLunghezza,_orderSuperficie, _orderVolume,_orderTempo,_orderTemperatura,_orderVelocita,_orderPrefissi,_orderMassa,_orderPressione,_orderEnergia,
  _orderAngoli, _orderValute, _orderScarpe, _orderDati, _orderPotenza, _orderForza, _orderTorque, _orderConsumo, _orderBasi];
  bool _isCurrenciesLoading = true;
  bool _removeTrailingZeros = true;
  static final List<int> _significantFiguresList = <int>[6, 8, 10, 12, 14];
  int _significantFigures = _significantFiguresList[2];

  Conversions() {
    _checkCurrencies();   //update the currencies with the latest conversions rates and then
    _checkOrdersUnits();
  }

  get conversionsList{
    //if _conversionsList is initialized it returns it
    if(_conversionsList != null)
      return _conversionsList;
    //otherwise it will be initialized and it returns it
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
    return _conversionsList;
  }

  ///Returns the DateTime of the latest update of the currencies conversions
  ///ratio (year, month, day)
  get lastUpdateCurrency => _lastUpdateCurrencies;


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
    if(dataFetched==null || CurrencyJSONObject.fromJson(json.decode(dataFetched)).date!=now){//if I have never updated the conversions or if I have updated before today I have to update
      try{
        var response = await http.get('https://api.exchangeratesapi.io/latest?symbols=USD,GBP,INR,CNY,JPY,CHF,SEK,RUB,CAD,KRW,BRL,HKD,AUD,NZD,MXN,SGD,NOK,TRY,ZAR,DKK,PLN,THB,MYR,HUF,CZK,ILS,IDR,PHP,RON');
        if (response.statusCode == 200) { //if successful
          CurrencyJSONObject currencyObject = new CurrencyJSONObject.fromJson(json.decode(response.body));
          //the following line solves the problem that the http request gives a date refered to some
          //time zone that may be not the same of the time zone of the user. So I rewrite the date of
          //the response to be the same of the date of the user
          currencyObject.date = now;
          _currencyValues = currencyObject.rates; //updates the currency value with the new values
          //If the request recive an accettable response the last update is now
          _lastUpdateCurrencies = DateTime.now();
          //save to memory
          prefs.setString("currencyRates", currencyObject.toString());
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
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
    notifyListeners();    //change the value of the current conversions
  }

  ///Get the orders of each units of measurement from the memory
  _checkOrdersUnits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List <String> stringList;
      //Update every order of every conversion
    for(int i=0; i<conversionsList.length; i++){
      stringList = prefs.getStringList("conversion_$i");
      if(stringList!=null){
        final int len=stringList.length;
        List<int> intList=new List();
        for(int j=0;j<len;j++){
          intList.add(int.parse(stringList[j]));
        }
        //solves the problem of adding new units after an update
        for(int j=len; j<_conversionsOrder[i].length;j++)     
          intList.add(j);
        _conversionsOrder[i]=intList;
      }
    }
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
    notifyListeners();
  }

  ///Given a list of translated units of measurement it changes the order
  ///of the units (_conversionsOrder) opening a separate page (ReorderPage)
  changeOrderUnits(BuildContext context, List<String> listUnitsNames, int currentPage) async{
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReorderPage(
            listaElementi: listUnitsNames,
        ),));
    List arrayCopy=new List(_conversionsOrder[currentPage].length);
    for(int i=0;i<_conversionsOrder[currentPage].length;i++)
      arrayCopy[i]=_conversionsOrder[currentPage][i];
    for(int i=0;i<_conversionsOrder[currentPage].length;i++)
      _conversionsOrder[currentPage][i]=result.indexOf(arrayCopy[i]);
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
    notifyListeners(); 
    _saveOrders(currentPage);
  }

  _saveOrders(int currentPage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> toConvertList=new List();
    for(int item in _conversionsOrder[currentPage])
      toConvertList.add(item.toString());
    prefs.setStringList("conversion_$currentPage", toConvertList);
  }

  //Settings section------------------------------------------------------------------
  
  ///Returns true if you want to remove the trailing zeros of the conversions
  ///e.g. 1.000000000e20 becomes 1e20
  bool get removeTrailingZeros => _removeTrailingZeros;

  ///Returns the list of possibile significant figures
  List<int> get significantFiguresList => _significantFiguresList;

  ///Returns the current significant figures selection
  int get significantFigures => _significantFigures;

  ///Set the ability of remove unecessary trailing zeros and save to SharedPreferences
  ///e.g. 1.000000000e20 becomes 1e20
  set removeTrailingZeros (bool value){
    _removeTrailingZeros = value;
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
    notifyListeners();
    //it is not possibile to make a setter async, this is a workaround
    // ignore: unnecessary_statements
    () async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("remove_trailing_zeros", _removeTrailingZeros);
    };
  }

  ///Set the current significant figures selection and save to SharedPreferences
  set significantFigures (int value){
    _significantFigures = value;
    _conversionsList = initializeUnits(_conversionsOrder, _currencyValues, _significantFigures, _removeTrailingZeros);
    notifyListeners();
    //it is not possibile to make a setter async, this is a workaround
    // ignore: unnecessary_statements
    () async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("significant_figures", significantFigures);
    };
  }

}