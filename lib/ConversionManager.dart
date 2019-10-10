import 'package:converter_pro/ConversionPage.dart';
import 'package:converter_pro/Localization.dart';
import 'package:converter_pro/ReorderPage.dart';
import 'package:converter_pro/Utils.dart';
import 'package:converter_pro/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

import 'SettingsPage.dart';
import 'UnitsData.dart';

bool isCurrencyLoading=true;
double appBarSize;
Map jsonSearch;

class ConversionManager extends StatefulWidget{
  @override
  _ConversionManager createState() => new _ConversionManager();

}

class _ConversionManager extends State<ConversionManager>{

  static final MAX_CONVERSION_UNITS=19;
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  var currencyValues={"CAD":1.4642,"HKD":8.7482,"RUB":71.5025,"PHP":57.58,"DKK":7.4631,"NZD":1.6888,"CNY":7.7173,"AUD":1.6058,"RON":4.72,"SEK":10.5973,"IDR":15824.37,"INR":76.8955,"BRL":4.2752,"USD":1.1215,"ILS":4.0095,"JPY":121.8,"THB":34.514,"CHF":1.1127,"CZK":25.509,"MYR":4.6436,"TRY":6.4304,"MXN":21.2581,"NOK":9.684,"HUF":324.66,"ZAR":15.8813,"SGD":1.5247,"GBP":0.89625,"KRW":1322.07,"PLN":4.253}; //base euro (aggiornato a 08/07/2019)
  static String lastUpdateCurrency="Last update: 2019-07-08";
  static List listaConversioni;
  static List listaColori=[Colors.red,Colors.deepOrange,Colors.amber,Colors.cyan, Colors.indigo,
  Colors.purple,Colors.blueGrey,Colors.green,Colors.pinkAccent,Colors.teal,
  Colors.blue, Colors.yellow.shade700, Colors.brown, Colors.lightGreenAccent, Colors.deepPurple,
  Colors.lightBlue, Colors.lime,Colors.yellow, Colors.orange];
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  static List listaTitoli;
  static int _currentPage=0;
  static List orderLunghezza=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  static List orderSuperficie=[0,1,2,3,4,5,6,7,8,9,10];
  static List orderVolume=[0,1,2,3,4,5,6,7,8,9,10,11,12,13];
  static List orderTempo=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14];
  static List orderTemperatura=[0,1,2,3,4,5,6];
  static List orderVelocita=[0,1,2,3,4];
  static List orderPrefissi=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
  static List orderMassa=[0,1,2,3,4,5,6,7,8,9];
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
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  static List<Widget> listaDrawer=new List(MAX_CONVERSION_UNITS+1);//+1 perchè c'è l'intestazione
  static List<int> listaOrderDrawer=[0,1,2,4,5,6,17,7,11,12,14,3,15,16,13,8,18,9,10]; //fino a maxconversionunits-1
  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  final SearchDelegate _searchDelegate=CustomSearchDelegate();

  @override
  void initState() {
    _getOrders();
    _getCurrency();
    bool stopRequestRating = prefs.getBool("stop_request_rating") ?? false;
    if(numero_volte_accesso>=5 && !stopRequestRating && getBoolWithProbability(30))
      _showRateDialog();
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
    Color boxColor=Theme.of(context).primaryColor;
    listaDrawer[0]=
        isLogoVisible ? 
          Container(
            decoration: BoxDecoration(color: boxColor/*listaColori[_currentPage],*/),
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
                          icon: Icon(Icons.reorder,color: Colors.white,),
                          onPressed:(){
                            _changeOrderDrawer(context, MyLocalizations.of(context).trans('mio_ordinamento'), listaColori[_currentPage]);
                          }
                        ),
                        IconButton(
                          icon:Icon(Icons.settings,color: Colors.white,),
                          onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SettingsPage()),
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
            decoration: BoxDecoration(color: listaColori[_currentPage],),
            child:SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.reorder,color: Colors.white,),
                    onPressed:(){
                      _changeOrderDrawer(context, MyLocalizations.of(context).trans('mio_ordinamento'), listaColori[_currentPage]);
                    }
                  ),
                  IconButton(
                    icon:Icon(Icons.settings,color: Colors.white,),
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                ],
              ),
          ));

    listaDrawer[listaOrderDrawer[0]+1]=ListTileConversion(listaTitoli[0],"resources/images/lunghezza.png",listaColori[0],_currentPage==0,(){_onSelectItem(0);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[1]+1]=ListTileConversion(listaTitoli[1],"resources/images/area.png",listaColori[1],_currentPage==1,(){_onSelectItem(1);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[2]+1]=ListTileConversion(listaTitoli[2],"resources/images/volume.png",listaColori[2],_currentPage==2,(){_onSelectItem(2);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[3]+1]=ListTileConversion(listaTitoli[3],"resources/images/tempo.png",listaColori[3],_currentPage==3,(){_onSelectItem(3);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[4]+1]=ListTileConversion(listaTitoli[4],"resources/images/temperatura.png",listaColori[4],_currentPage==4,(){_onSelectItem(4);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[5]+1]=ListTileConversion(listaTitoli[5],"resources/images/velocita.png",listaColori[5],_currentPage==5,(){_onSelectItem(5);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[6]+1]=ListTileConversion(listaTitoli[6],"resources/images/prefissi.png",listaColori[6],_currentPage==6,(){_onSelectItem(6);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[7]+1]=ListTileConversion(listaTitoli[7],"resources/images/massa.png",listaColori[7],_currentPage==7,(){_onSelectItem(7);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[8]+1]=ListTileConversion(listaTitoli[8],"resources/images/pressione.png",listaColori[8],_currentPage==8,(){_onSelectItem(8);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[9]+1]=ListTileConversion(listaTitoli[9],"resources/images/energia.png",listaColori[9],_currentPage==9,(){_onSelectItem(9);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[10]+1]=ListTileConversion(listaTitoli[10],"resources/images/angoli.png",listaColori[10],_currentPage==10,(){_onSelectItem(10);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[11]+1]=ListTileConversion(listaTitoli[11],"resources/images/valuta.png",listaColori[11],_currentPage==11,(){_onSelectItem(11);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[12]+1]=ListTileConversion(listaTitoli[12],"resources/images/scarpe.png",listaColori[12],_currentPage==12,(){_onSelectItem(12);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[13]+1]=ListTileConversion(listaTitoli[13],"resources/images/dati.png",listaColori[13],_currentPage==13,(){_onSelectItem(13);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[14]+1]=ListTileConversion(listaTitoli[14],"resources/images/potenza.png",listaColori[14],_currentPage==14,(){_onSelectItem(14);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[15]+1]=ListTileConversion(listaTitoli[15],"resources/images/forza.png",listaColori[15],_currentPage==15,(){_onSelectItem(15);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[16]+1]=ListTileConversion(listaTitoli[16],"resources/images/torque.png",listaColori[16],_currentPage==16,(){_onSelectItem(16);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[17]+1]=ListTileConversion(listaTitoli[17],"resources/images/consumo.png",listaColori[17],_currentPage==17,(){_onSelectItem(17);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[18]+1]=ListTileConversion(listaTitoli[18],"resources/images/conversione_base.png",listaColori[18],_currentPage==18,(){_onSelectItem(18);Navigator.of(context).pop();});
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  }

  _onSelectItem(int index) {
    if(_currentPage!=index) {
      listaConversioni[_currentPage].ClearSelectedNode();
      setState(() {
        _currentPage = index;
      });
    }
  }

  _getJsonSearch(BuildContext context) async {
    jsonSearch ??= json.decode(await DefaultAssetBundle.of(context).loadString("resources/lang/${Localizations.localeOf(context).languageCode}.json"));
  }

  _saveOrders() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> toConvertList=new List();
    for(int item in listaOrder[_currentPage])
      toConvertList.add(item.toString());
    prefs.setStringList("conversion_$_currentPage", toConvertList);
  }
  _getOrders() async {

    //aggiorno lista del drawer
    List <String> stringList=prefs.getStringList("orderDrawer");
    setState((){
      if(stringList!=null){
        final int len=stringList.length;
        for(int i=0;i<len;i++){
          listaOrderDrawer[i]=int.parse(stringList[i]);
          if(listaOrderDrawer[i]==0)
             _currentPage=i;
        }
        //risolve il problema di aggiunta di unità dopo un aggiornamento
        for(int i=len;i<MAX_CONVERSION_UNITS;i++){
          listaOrderDrawer[i]=i;
        }
      }
    });


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
        
        if(i==_currentPage){
          setState(() {
            listaOrder[i]=intList;
          });
        }
        else
          listaOrder[i]=intList;

      }
    }
  }

  _changeOrderDrawer(BuildContext context,String title, Color color) async{

    //SharedPreferences prefs = await SharedPreferences.getInstance();
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
            color:color
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

  _changeOrderUnita(BuildContext context,String title, List listaStringhe, Color color) async{
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReorderPage(
            title: title,
            listaElementi: listaStringhe,
            color:color
        ),));
    List arrayCopia=new List(listaOrder[_currentPage].length);
    for(int i=0;i<listaOrder[_currentPage].length;i++)
      arrayCopia[i]=listaOrder[_currentPage][i];
    setState(() {
      for(int i=0;i<listaOrder[_currentPage].length;i++)
        listaOrder[_currentPage][i]=result.indexOf(arrayCopia[i]);
    });
    _saveOrders();
  }


  @override
  Widget build(BuildContext context) {
    _getJsonSearch(context);

    listaConversioni=InitializeUnits(context, listaOrder, currencyValues);
    listaTitoli=[MyLocalizations.of(context).trans('lunghezza'),MyLocalizations.of(context).trans('superficie'),MyLocalizations.of(context).trans('volume'),
    MyLocalizations.of(context).trans('tempo'),MyLocalizations.of(context).trans('temperatura'),MyLocalizations.of(context).trans('velocita'),
    MyLocalizations.of(context).trans('prefissi_si'),MyLocalizations.of(context).trans('massa'),MyLocalizations.of(context).trans('pressione'),
    MyLocalizations.of(context).trans('energia'), MyLocalizations.of(context).trans('angoli'),MyLocalizations.of(context).trans('valuta'),
    MyLocalizations.of(context).trans('taglia_scarpe'),MyLocalizations.of(context).trans('dati_digitali'),MyLocalizations.of(context).trans('potenza'),
    MyLocalizations.of(context).trans('forza'), MyLocalizations.of(context).trans('momento'),MyLocalizations.of(context).trans('consumo_carburante'),
    MyLocalizations.of(context).trans('basi_numeriche')];
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
    initializeTiles();
    

    List<Choice> choices = <Choice>[
      Choice(title: MyLocalizations.of(context).trans('riordina'), icon: Icons.reorder),
    ];
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(child:ConversionPage(listaConversioni[_currentPage],listaTitoli[_currentPage], _currentPage==11 ? lastUpdateCurrency : "")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: listaDrawer,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Builder(builder: (context) {
              return IconButton(icon: Icon(Icons.menu,color: Colors.white,), onPressed: () {
                Scaffold.of(context).openDrawer();
              });
            }),
            Row(children: <Widget>[
              IconButton(
                icon: Icon(Icons.clear,color: Colors.white),
                onPressed: () {
                  setState(() {
                    listaConversioni[_currentPage].ClearAllValues();
                  });
                },),
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () async {
                  final int paginaReindirizzamento=await showSearch(context: context,delegate: _searchDelegate);
                  if(paginaReindirizzamento!=null)
                    _onSelectItem(paginaReindirizzamento);
                },
              ),
              PopupMenuButton<Choice>(
                icon: Icon(Icons.more_vert,color: Colors.white,),
                onSelected: (Choice choice){
                  _changeOrderUnita(context, MyLocalizations.of(context).trans('mio_ordinamento'), listaConversioni[_currentPage].getStringOrderedNodiFiglio(), listaColori[_currentPage]);
                },
                itemBuilder: (BuildContext context) {
                  return choices.map((Choice choice) {
                    return PopupMenuItem<Choice>(
                      value: choice,
                      child: Text(choice.title),
                    );
                  }).toList();
                },
              ),
            ],)
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        child: Image.asset("resources/images/calculator.png",width: 30.0,),
        onPressed: (){
          _fabPressed();
        },
        elevation: 5.0,
        backgroundColor: Theme.of(context).accentColor,//Color(0xff2196f3)//listaColori[_currentPage],
      )

    );
  }

  _fabPressed(){
    showModalBottomSheet<void>(context: context,
      builder: (BuildContext context) {
        double displayWidth=MediaQuery.of(context).size.width;
        return Calculator(listaColori[_currentPage], displayWidth); 
      }
    );
  }

  void _showRateDialog() async {
    new Future.delayed(Duration.zero,() {
      showDialog(
        context: context,
        builder: (BuildContext dialogcontext) {
          return AlertDialog(
            title: new Text(MyLocalizations.of(context).trans('valuta_app')),
            content: new Text(MyLocalizations.of(context).trans('valuta_app2')),
            actions: <Widget>[
              new FlatButton(
                child: new Text(MyLocalizations.of(context).trans('gia_fatto')),
                onPressed: () {
                  prefs.setBool("stop_request_rating",true);
                  Navigator.of(dialogcontext).pop();
                },
              ),
              new FlatButton(
                child: new Text(MyLocalizations.of(context).trans('piu_tardi')),
                onPressed: () {
                  Navigator.of(dialogcontext).pop();
                },
              ),
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  launchURL("https://play.google.com/store/apps/details?id=com.ferrarid.converterpro");
                  Navigator.of(dialogcontext).pop();
                },
              ),
            ],
          );
        },
      );
      }
    );
  }
}


class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class ListTileConversion extends StatefulWidget{
  String text;
  String imagePath;
  Color color;
  bool selected;
  Function onTapFunction;
  ListTileConversion(this.text, this.imagePath, this.color, this.selected,this.onTapFunction);

  @override
  _ListTileConversion createState() => new _ListTileConversion();
} 

class _ListTileConversion extends State<ListTileConversion>{



  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      child:ListTile(
        title: Row(children: <Widget>[
          Image.asset(widget.imagePath,width: 30.0,height: 30.0, color:  widget.selected ? Theme.of(context).accentColor/*widget.color*/ : (MediaQuery.of(context).platformBrightness==Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54),),
          SizedBox(width: 20.0,),
          Text(
            widget.text,
            style: TextStyle(
              color: widget.selected ? Theme.of(context).accentColor/*widget.color*/ : (MediaQuery.of(context).platformBrightness==Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54),
              fontWeight: widget.selected ? FontWeight.bold : FontWeight.normal,
            ),
            
          )
        ],),
        selected: widget.selected,
        onTap: widget.onTapFunction
      ),
      selectedColor: Theme.of(context).accentColor//widget.color,
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<int> {  
  
  List<SearchUnit> _history = [
    SearchUnit(iconAsset: "lunghezza", unitName: "Lunghezza", onTap: (){print("Temperaura");}),
    SearchUnit(iconAsset: "tempo", unitName: "Tempo", onTap: (){print("Tempo");}),
    SearchUnit(iconAsset: "energia", unitName: "Energia", onTap: (){print("Energia");}),
    SearchUnit(iconAsset: "potenza", unitName: "Potenza", onTap: (){print("Potenza");})
  ];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
        final List<SearchUnit> _dataSearch=InitializeSearchUnits((int pageNumber){close(context,pageNumber);}, jsonSearch);
        final List<SearchGridTile> allConversions=InitializeGridSearch((int pageNumber) {close(context, pageNumber);}, jsonSearch, MediaQuery.of(context).platformBrightness==Brightness.dark);

        final Iterable<SearchUnit> suggestions = _dataSearch.where((searchUnit) => searchUnit.unitName.toLowerCase().contains(query.toLowerCase())); //.toLowercase per essere case insesitive
        
        return query.isNotEmpty ? SuggestionList(
          suggestions: suggestions.toList(),
          darkMode: MediaQuery.of(context).platformBrightness==Brightness.dark,
        )
        : GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0),
          children: allConversions,
          
        );
      }
    
      @override
      Widget buildResults(BuildContext context) {
        return Container();
      }
    
      @override
      List<Widget> buildActions(BuildContext context) {
        return <Widget>[
          if(query.isNotEmpty)
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
        ];
      }
}
