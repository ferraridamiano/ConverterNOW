import 'package:converterpro/models/AppModel.dart';
import 'package:converterpro/models/Conversions.dart';
import 'package:converterpro/models/Settings.dart';
import 'package:converterpro/pages/SettingsPage.dart';
import 'package:converterpro/utils/Localization.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'ConversionManager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AppManager extends StatefulWidget{
  @override
  _AppManagerState createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {

  static List<Widget> listaDrawer=new List(MAX_CONVERSION_UNITS+1);//+1 perchè c'è l'intestazione
  static List<String> titlesList;
  static bool showRateSnackBar = false;  

  @override
  void initState() {
    //_getOrdersDrawer();
    //_getOrdersUnita();
    //TODO: snackbar
    //bool stopRequestRating = prefs.getBool("stop_request_rating") ?? false;
    //if(numeroVolteAccesso>=5 && !stopRequestRating && getBoolWithProbability(30))
      //showRateSnackBar=true;
    /*SchedulerBinding.instance.addPostFrameCallback((_) {
      _getCurrency();
    });*/
    
      
    super.initState();  
  }

  void initializeTiles(){
    Color boxColor=Theme.of(context).primaryColor;

    List<Widget> drawerActions = <Widget>[
      Consumer<AppModel>(
        builder: (context, appModel, _) => IconButton(
          tooltip: MyLocalizations.of(context).trans('riordina'),
          icon: Icon(Icons.reorder,color: Colors.white,),
          onPressed:() => appModel.changeOrderDrawer(context, titlesList)
        ),
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
    ];

    bool logoVisibility = context.select<Settings, bool>(
      (settings) => settings.isLogoVisible,
    );

    listaDrawer[0]=
        logoVisibility ? 
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
                      children: drawerActions
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
                children: drawerActions,
              ),
          ));
    
    List<int> conversionsOrderDrawer = context.watch<AppModel>().conversionsOrderDrawer;

    //*the following lines are more optimized then the prvious one but don't know
    //*why they don't work :(
    /*List<int> conversionsOrderDrawer = context.select<AppModel, List<int>>(
      (appModel) => appModel.conversionsOrderDrawer
    );*/
    int currentPage = context.select<AppModel, int>(
      (appModel) => appModel.currentPage
    );

    listaDrawer[conversionsOrderDrawer[0]+1]=ListTileConversion(titlesList[0],"resources/images/lunghezza.png",currentPage==0,(){ context.read<AppModel>().changeToPage(0);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[1]+1]=ListTileConversion(titlesList[1],"resources/images/area.png",currentPage==1,(){ context.read<AppModel>().changeToPage(1);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[2]+1]=ListTileConversion(titlesList[2],"resources/images/volume.png",currentPage==2,(){ context.read<AppModel>().changeToPage(2);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[3]+1]=ListTileConversion(titlesList[3],"resources/images/tempo.png",currentPage==3,(){ context.read<AppModel>().changeToPage(3);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[4]+1]=ListTileConversion(titlesList[4],"resources/images/temperatura.png",currentPage==4,(){ context.read<AppModel>().changeToPage(4);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[5]+1]=ListTileConversion(titlesList[5],"resources/images/velocita.png",currentPage==5,(){ context.read<AppModel>().changeToPage(5);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[6]+1]=ListTileConversion(titlesList[6],"resources/images/prefissi.png",currentPage==6,(){ context.read<AppModel>().changeToPage(6);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[7]+1]=ListTileConversion(titlesList[7],"resources/images/massa.png",currentPage==7,(){ context.read<AppModel>().changeToPage(7);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[8]+1]=ListTileConversion(titlesList[8],"resources/images/pressione.png",currentPage==8,(){ context.read<AppModel>().changeToPage(8);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[9]+1]=ListTileConversion(titlesList[9],"resources/images/energia.png",currentPage==9,(){ context.read<AppModel>().changeToPage(9);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[10]+1]=ListTileConversion(titlesList[10],"resources/images/angoli.png",currentPage==10,(){ context.read<AppModel>().changeToPage(10);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[11]+1]=ListTileConversion(titlesList[11],"resources/images/valuta.png",currentPage==11,(){ context.read<AppModel>().changeToPage(11);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[12]+1]=ListTileConversion(titlesList[12],"resources/images/scarpe.png",currentPage==12,(){ context.read<AppModel>().changeToPage(12);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[13]+1]=ListTileConversion(titlesList[13],"resources/images/dati.png",currentPage==13,(){ context.read<AppModel>().changeToPage(13);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[14]+1]=ListTileConversion(titlesList[14],"resources/images/potenza.png",currentPage==14,(){ context.read<AppModel>().changeToPage(14);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[15]+1]=ListTileConversion(titlesList[15],"resources/images/forza.png",currentPage==15,(){ context.read<AppModel>().changeToPage(15);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[16]+1]=ListTileConversion(titlesList[16],"resources/images/torque.png",currentPage==16,(){ context.read<AppModel>().changeToPage(16);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[17]+1]=ListTileConversion(titlesList[17],"resources/images/consumo.png",currentPage==17,(){ context.read<AppModel>().changeToPage(17);Navigator.of(context).pop();});
    listaDrawer[conversionsOrderDrawer[18]+1]=ListTileConversion(titlesList[18],"resources/images/conversione_base.png",currentPage==18,(){ context.read<AppModel>().changeToPage(18);Navigator.of(context).pop();});
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  }

  @override
  Widget build(BuildContext context) {

    titlesList=[MyLocalizations.of(context).trans('lunghezza'),MyLocalizations.of(context).trans('superficie'),MyLocalizations.of(context).trans('volume'),
    MyLocalizations.of(context).trans('tempo'),MyLocalizations.of(context).trans('temperatura'),MyLocalizations.of(context).trans('velocita'),
    MyLocalizations.of(context).trans('prefissi_si'),MyLocalizations.of(context).trans('massa'),MyLocalizations.of(context).trans('pressione'),
    MyLocalizations.of(context).trans('energia'), MyLocalizations.of(context).trans('angoli'),MyLocalizations.of(context).trans('valuta'),
    MyLocalizations.of(context).trans('taglia_scarpe'),MyLocalizations.of(context).trans('dati_digitali'),MyLocalizations.of(context).trans('potenza'),
    MyLocalizations.of(context).trans('forza'), MyLocalizations.of(context).trans('momento'),MyLocalizations.of(context).trans('consumo_carburante'),
    MyLocalizations.of(context).trans('basi_numeriche')];

    initializeTiles();

    DateTime lastUpdateCurrencies = context.select<Conversions, DateTime>(
      (settings) => settings.lastUpdateCurrency,
    );

    String stringLastUpdateCurrencies;
    DateTime dateNow = DateTime.now();
    if(lastUpdateCurrencies.day == dateNow.day && lastUpdateCurrencies.month == dateNow.month && lastUpdateCurrencies.year == dateNow.year)
      stringLastUpdateCurrencies = MyLocalizations.of(context).trans('ultimo_update_valute') + MyLocalizations.of(context).trans('oggi');
    else
      stringLastUpdateCurrencies = MyLocalizations.of(context).trans('ultimo_update_valute') + DateFormat("yyyy-MM-dd").format(lastUpdateCurrencies);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: listaDrawer,
        ),
      ),
      body: Builder(
        builder: (context) => 
        Consumer<Conversions>(
          builder: (context, conversions, _) => ConversionManager(
            openDrawer: () { Scaffold.of(context).openDrawer(); },
            titlesList: titlesList,
            showRateSnackBar: showRateSnackBar,
            lastUpdateCurrency: stringLastUpdateCurrencies,
            currencyValues: conversions.currencyValues,
            isCurrenciesLoading: conversions.isCurrenciesLoading,
          ),
        ),
      )
    );
  }
}

