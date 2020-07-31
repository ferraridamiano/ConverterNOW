import 'package:converterpro/managers/ToolsManager.dart';
import 'package:converterpro/pages/ReorderPage.dart';
import 'package:converterpro/pages/SettingsPage.dart';
import 'package:converterpro/utils/Localization.dart';
import 'package:converterpro/utils/UnitsData.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:converterpro/utils/UtilsConversion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../main.dart';
import 'ConversionManager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import "dart:convert";

int currentPage=0;    //page of a topic (e.g. length)
int currentTopic=0;   //topic (e.g. conversions)
const MAX_CONVERSION_UNITS=19;
const MAX_TOOLS_NUMBER=1;

class AppManager extends StatefulWidget{
  @override
  _AppManagerState createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {

  static List<Widget> listaDrawer = new List(3); //titolo + conversioni + tools
  static List<ListTileDrawer> listaDrawerConversions=new List(MAX_CONVERSION_UNITS);//+1 perchè c'è l'intestazione
  static List<ListTileDrawer> listDrawerTools = new List(MAX_TOOLS_NUMBER);
  static List<int> listaOrderDrawer=[0,1,2,4,5,6,17,7,11,12,14,3,15,16,13,8,18,9,10]; //fino a maxconversionunits-1
  static List<String> listaTitoli;
  static bool showRateSnackBar = false;
  static List<Node> listaConversioni;
  static String lastUpdateCurrency="Last update: 2019-10-29";
  var currencyValues={"CAD":1.4487,"HKD":8.6923,"RUB":70.5328,"PHP":56.731,"DKK":7.4707,"NZD":1.7482,"CNY":7.8366,"AUD":1.6245,"RON":4.7559,"SEK":10.7503,"IDR":15536.21,"INR":78.4355,"BRL":4.4158,"USD":1.1087,"ILS":3.9187,"JPY":120.69,"THB":33.488,"CHF":1.1047,"CZK":25.48,"MYR":4.641,"TRY":6.3479,"MXN":21.1244,"NOK":10.2105,"HUF":328.16,"ZAR":16.1202,"SGD":1.5104,"GBP":0.86328,"KRW":1297.1,"PLN":4.2715}; //base euro (aggiornato a 29/10/2019)
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  static List orderLunghezza=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  static List orderSuperficie=[0,1,2,3,4,5,6,7,8,9,10];
  static List orderVolume=[0,1,2,3,4,5,6,7,8,9,10,11,12,13];
  static List orderTempo=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14];
  static List orderTemperatura=[0,1,2,3,4,5,6];
  static List orderVelocita=[0,1,2,3,4];
  static List orderPrefissi=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
  static List orderMassa=[0,1,2,3,4,5,6,7,8,9,10];
  static List orderPressione=[0,1,2,3,4,5];
  static List orderEnergia=[0,1,2,3];
  static List orderAngoli=[0,1,2,3];
  static List orderValute=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29];
  static List orderScarpe=[0,1,2,3,4,5,6,7,8,9];
  static List orderDati=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26];
  static List orderPotenza=[0,1,2,3,4,5,6];
  static List orderForza=[0,1,2,3,4];
  static List orderTorque=[0,1,2,3,4];
  static List orderConsumo=[0,1,2,3];
  static List orderBasi=[0,1,2,3];
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  static List listaOrder=[orderLunghezza,orderSuperficie, orderVolume,orderTempo,orderTemperatura,orderVelocita,orderPrefissi,orderMassa,orderPressione,orderEnergia,
  orderAngoli, orderValute, orderScarpe, orderDati, orderPotenza, orderForza, orderTorque, orderConsumo, orderBasi];

  @override
  void initState() {
    _getOrdersDrawer();
    _getOrdersUnita();
    bool stopRequestRating = prefs.getBool("stop_request_rating") ?? false;
    if(numeroVolteAccesso>=5 && !stopRequestRating && getBoolWithProbability(30))
      showRateSnackBar=true;
    listaConversioni=initializeUnits(listaOrder, currencyValues); 
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _getCurrency();
    });
    
      
    super.initState();  
  }

  _leggiCurrenciesSalvate(){
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


  void initializeTiles(){

    listDrawerTools[0] = ListTileDrawer("Tool 1","resources/images/lunghezza.png",currentTopic==0 && currentPage==0,(){_onSelectItem(0,0);Navigator.of(context).pop();});
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    listaDrawerConversions[listaOrderDrawer[0]]=ListTileDrawer(listaTitoli[0],"resources/images/lunghezza.png",currentTopic==1 && currentPage==0,(){_onSelectItem(1,0);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[1]]=ListTileDrawer(listaTitoli[1],"resources/images/area.png",currentTopic==1 && currentPage==1,(){_onSelectItem(1,1);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[2]]=ListTileDrawer(listaTitoli[2],"resources/images/volume.png",currentTopic==1 && currentPage==2,(){_onSelectItem(1,2);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[3]]=ListTileDrawer(listaTitoli[3],"resources/images/tempo.png",currentTopic==1 && currentPage==3,(){_onSelectItem(1,3);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[4]]=ListTileDrawer(listaTitoli[4],"resources/images/temperatura.png",currentTopic==1 && currentPage==4,(){_onSelectItem(1,4);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[5]]=ListTileDrawer(listaTitoli[5],"resources/images/velocita.png",currentTopic==1 && currentPage==5,(){_onSelectItem(1,5);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[6]]=ListTileDrawer(listaTitoli[6],"resources/images/prefissi.png",currentTopic==1 && currentPage==6,(){_onSelectItem(1,6);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[7]]=ListTileDrawer(listaTitoli[7],"resources/images/massa.png",currentTopic==1 && currentPage==7,(){_onSelectItem(1,7);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[8]]=ListTileDrawer(listaTitoli[8],"resources/images/pressione.png",currentTopic==1 && currentPage==8,(){_onSelectItem(1,8);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[9]]=ListTileDrawer(listaTitoli[9],"resources/images/energia.png",currentTopic==1 && currentPage==9,(){_onSelectItem(1,9);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[10]]=ListTileDrawer(listaTitoli[10],"resources/images/angoli.png",currentTopic==1 && currentPage==10,(){_onSelectItem(1,10);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[11]]=ListTileDrawer(listaTitoli[11],"resources/images/valuta.png",currentTopic==1 && currentPage==11,(){_onSelectItem(1,11);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[12]]=ListTileDrawer(listaTitoli[12],"resources/images/scarpe.png",currentTopic==1 && currentPage==12,(){_onSelectItem(1,12);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[13]]=ListTileDrawer(listaTitoli[13],"resources/images/dati.png",currentTopic==1 && currentPage==13,(){_onSelectItem(1,13);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[14]]=ListTileDrawer(listaTitoli[14],"resources/images/potenza.png",currentTopic==1 && currentPage==14,(){_onSelectItem(1,14);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[15]]=ListTileDrawer(listaTitoli[15],"resources/images/forza.png",currentTopic==1 && currentPage==15,(){_onSelectItem(1,15);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[16]]=ListTileDrawer(listaTitoli[16],"resources/images/torque.png",currentTopic==1 && currentPage==16,(){_onSelectItem(1,16);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[17]]=ListTileDrawer(listaTitoli[17],"resources/images/consumo.png",currentTopic==1 && currentPage==17,(){_onSelectItem(1,17);Navigator.of(context).pop();});
    listaDrawerConversions[listaOrderDrawer[18]]=ListTileDrawer(listaTitoli[18],"resources/images/conversione_base.png",currentTopic==1 && currentPage==18,(){_onSelectItem(1,18);Navigator.of(context).pop();});
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    Color boxColor=Theme.of(context).primaryColor;
    listaDrawer[0]=
        isLogoVisible ? 
          Container(
            decoration: BoxDecoration(color: boxColor/*listaColori[currentPage],*/),
            child:SafeArea(
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child:Image.asset("resources/images/logo.png"),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(color: boxColor,),),
                  Container(
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          tooltip: MyLocalizations.of(context).trans('riordina'),
                          icon: Icon(Icons.reorder,color: Colors.white,),
                          onPressed:(){
                            _changeOrderDrawer(context, MyLocalizations.of(context).trans('mio_ordinamento'));
                          }
                        ),
                        IconButton(
                          tooltip: MyLocalizations.of(context).trans('impostazioni'),
                          icon:Icon(Icons.settings,color: Colors.white,),
                          onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SettingsPage(Theme.of(context).primaryColor, Theme.of(context).accentColor)),
                            );
                          },
                        ),
                      ],
                    ),
                    height: 160.0,
                    alignment: FractionalOffset.bottomRight,
                  )  
                ]
            )
          ))
          :
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor/*listaColori[currentPage],*/),
            child:SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    tooltip: MyLocalizations.of(context).trans('riordina'),
                    icon: Icon(Icons.reorder,color: Colors.white,),
                    onPressed:(){
                      _changeOrderDrawer(context, MyLocalizations.of(context).trans('mio_ordinamento'));
                    }
                  ),
                  IconButton(
                    tooltip: MyLocalizations.of(context).trans('impostazioni'),
                    icon:Icon(Icons.settings,color: Colors.white,),
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage(Theme.of(context).primaryColor, Theme.of(context).accentColor)),
                      );
                    },
                  ),
                ],
              ),
          ));
    listaDrawer[1] = myExpansionTile(
      title: "Tools",
      leadingImageAsset: "resources/images/tools.png",
      selectedColor: Theme.of(context).accentColor,
      unSelectedColor: MediaQuery.of(context).platformBrightness==Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54,
      children: listDrawerTools,
      selected: currentTopic==0,
    );
    listaDrawer[2]=myExpansionTile(
      title: "Conversions",
      leadingImageAsset: "resources/images/conversion.png",
      selectedColor: Theme.of(context).accentColor,
      unSelectedColor: MediaQuery.of(context).platformBrightness==Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54,
      children: listaDrawerConversions,
      selected: currentTopic==1,
    );
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

  _onSelectItem(int topic, int index) {
    if(!(currentTopic==topic && currentPage==index)){
      setState(() {
        currentTopic = topic;
        currentPage = index;
      });
    }
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

  Builder _getCurrentBody(){
    if(currentTopic == 0){    //tools
      return Builder(
        builder: (context) => 
        ToolsManager(
          () { Scaffold.of(context).openDrawer();},//open Drawer
        ),
      );
    }
    return Builder(           //conversions
        builder: (context) => 
        ConversionManager(
          () { Scaffold.of(context).openDrawer(); },//open Drawer
          currentPage,                              //first page
          _onSelectItem,                            //change page
          listaTitoli,
          showRateSnackBar,
          listaConversioni,
          listaOrder,
          lastUpdateCurrency,
          currencyValues 
        ),
      );
  }


  @override
  Widget build(BuildContext context) {

    listaTitoli=[MyLocalizations.of(context).trans('lunghezza'),MyLocalizations.of(context).trans('superficie'),MyLocalizations.of(context).trans('volume'),
    MyLocalizations.of(context).trans('tempo'),MyLocalizations.of(context).trans('temperatura'),MyLocalizations.of(context).trans('velocita'),
    MyLocalizations.of(context).trans('prefissi_si'),MyLocalizations.of(context).trans('massa'),MyLocalizations.of(context).trans('pressione'),
    MyLocalizations.of(context).trans('energia'), MyLocalizations.of(context).trans('angoli'),MyLocalizations.of(context).trans('valuta'),
    MyLocalizations.of(context).trans('taglia_scarpe'),MyLocalizations.of(context).trans('dati_digitali'),MyLocalizations.of(context).trans('potenza'),
    MyLocalizations.of(context).trans('forza'), MyLocalizations.of(context).trans('momento'),MyLocalizations.of(context).trans('consumo_carburante'),
    MyLocalizations.of(context).trans('basi_numeriche')];

    initializeTiles();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: listaDrawer,
        ),
      ),
      body: _getCurrentBody()
    );
  }
}

