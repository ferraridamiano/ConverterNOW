import 'package:converterpro/utils/UnitsData.dart';
import 'package:converterpro/utils/UtilsConversion.dart';
import 'package:flutter/foundation.dart';

class Conversions with ChangeNotifier {

  static List<int> _conversionsOrderDrawer = [0,1,2,4,5,6,17,7,11,12,14,3,15,16,13,8,18,9,10]; //fino a maxconversionunits-1
  static List<Node> _conversionsList;
  static String _lastUpdateCurrency = "Last update: 2019-10-29";
  Map<String, double> _currencyValues={"CAD":1.4487,"HKD":8.6923,"RUB":70.5328,"PHP":56.731,"DKK":7.4707,"NZD":1.7482,"CNY":7.8366,"AUD":1.6245,"RON":4.7559,"SEK":10.7503,"IDR":15536.21,"INR":78.4355,"BRL":4.4158,"USD":1.1087,"ILS":3.9187,"JPY":120.69,"THB":33.488,"CHF":1.1047,"CZK":25.48,"MYR":4.641,"TRY":6.3479,"MXN":21.1244,"NOK":10.2105,"HUF":328.16,"ZAR":16.1202,"SGD":1.5104,"GBP":0.86328,"KRW":1297.1,"PLN":4.2715}; //base euro (aggiornato a 29/10/2019)
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

  ///Returns the order of the tile of the conversions in the drawer
  get conversionsOrderDrawer => _conversionsOrderDrawer;

  get lastUpdateCurrency => _lastUpdateCurrency;

  get currencyValues => _currencyValues;

  //TODO: implement this features in the model
  /*_leggiCurrenciesSalvate(){
    String currencyRead=prefs.getString("currencyRates");
    if(currencyRead!=null){
      CurrencyJSONObject currencyObject = new CurrencyJSONObject.fromJson(json.decode(currencyRead));
      currencyValues=currencyObject.rates;

      String lastUpdateRead=currencyObject.date;
      if(lastUpdateRead!=null)
        lastUpdateCurrency=MyLocalizations.of(context).trans('ultimo_update_valute')+lastUpdateRead;
    }
  }

  _getCurrency() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
   
    String dataFetched=prefs.getString("currencyRates");
    if(dataFetched==null || CurrencyJSONObject.fromJson(json.decode(dataFetched)).date!=now){//se non ho mai aggiornato oppure se non aggiorno la lista da piú di un giorno allora aggiorno
        try{
          final response =await http.get('https://api.exchangeratesapi.io/latest?symbols=USD,GBP,INR,CNY,JPY,CHF,SEK,RUB,CAD,KRW,BRL,HKD,AUD,NZD,MXN,SGD,NOK,TRY,ZAR,DKK,PLN,THB,MYR,HUF,CZK,ILS,IDR,PHP,RON');
          if (response.statusCode == 200) { //if successful

            CurrencyJSONObject currencyObject = new CurrencyJSONObject.fromJson(json.decode(response.body));
            currencyValues=currencyObject.rates;  

            //se tutte le richieste vanno a buon fine aggiorna la data di ultimo aggiornamento
            lastUpdateCurrency=MyLocalizations.of(context).trans('ultimo_update_valute')+MyLocalizations.of(context).trans('oggi');

            //salva in memoria
            prefs.setString("currencyRates", response.body);
          }
          else    //se ho un'errore nella lettura dati dal web (per es non sono connesso)
            _leggiCurrenciesSalvate();//leggi ultimi dati salvati

        }catch(e){//se ho un'errore di comunicazione
          print(e);
          _leggiCurrenciesSalvate(); //leggi ultimi dati salvati
      }
    }
    else{         //se ho già i dati alavati di oggi perchè sono già entrato la prima volta nell'app
      _leggiCurrenciesSalvate();
      lastUpdateCurrency=MyLocalizations.of(context).trans('ultimo_update_valute')+MyLocalizations.of(context).trans('oggi');
    }
    setState(() {
      isCurrencyLoading=false;
    });
  }
  
  _getOrdersDrawer() async {
    //aggiorno lista del drawer
    List <String> stringList=prefs.getStringList("orderDrawer");
    setState((){
      if(stringList!=null){
        final int len=stringList.length;
        for(int i=0;i<len;i++){
          listaOrderDrawer[i]=int.parse(stringList[i]);
          if(listaOrderDrawer[i]==0)
             currentPage=i;
        }
        //risolve il problema di aggiunta di unità dopo un aggiornamento
        for(int i=len;i<MAX_CONVERSION_UNITS;i++){
          listaOrderDrawer[i]=i;
        }
      }
    });
  }

  _getOrdersUnita() async {

    List <String> stringList;
    //aggiorno ordine unità di ogni grandezza fisica
    for(int i=0;i<MAX_CONVERSION_UNITS;i++){
      stringList=prefs.getStringList("conversion_$i");

      if(stringList!=null){
        final int len=stringList.length;
        List intList=new List();
        for(int j=0;j<len;j++){
          intList.add(int.parse(stringList[j]));
        }
        //risolve il problema di aggiunta di unità dopo un aggiornamento
        for(int j=len; j<listaOrder[i].length;j++)     
          intList.add(j);
        
        if(i==currentPage){
          setState(() {
            listaOrder[i]=intList;
          });
        }
        else
          listaOrder[i]=intList;
      }
    }
  }

  _changeOrderDrawer(BuildContext context,String title) async{

    Navigator.of(context).pop();

    List orderedList=new List(MAX_CONVERSION_UNITS);
    for(int i=0;i<MAX_CONVERSION_UNITS;i++){
      orderedList[listaOrderDrawer[i]]=listaTitoli[i];
    }

    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReorderPage(
            title: title,
            listaElementi: orderedList, 
        ),));

    List arrayCopia=new List(listaOrderDrawer.length);
    for(int i=0;i<listaOrderDrawer.length;i++)
      arrayCopia[i]=listaOrderDrawer[i];
    setState(() {
      for(int i=0;i<listaOrderDrawer.length;i++)
        listaOrderDrawer[i]=result.indexOf(arrayCopia[i]);
    });

    List<String> toConvertList=new List();
    for(int item in listaOrderDrawer)
      toConvertList.add(item.toString());
    prefs.setStringList("orderDrawer", toConvertList);

  }
  
  */
}