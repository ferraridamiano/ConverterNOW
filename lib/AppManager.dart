import 'package:flutter/material.dart';
import 'ReorderPage.dart';
import 'SettingsPage.dart';
import 'Utils.dart';
import 'ConversionManager.dart';
import 'package:converter_pro/Localization.dart';
import 'main.dart';

int currentPage=0;

class AppManager extends StatefulWidget{
  @override
  _AppManagerState createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {

  static List<Widget> listaDrawer=new List(MAX_CONVERSION_UNITS+1);//+1 perchè c'è l'intestazione
  static List<int> listaOrderDrawer=[0,1,2,4,5,6,17,7,11,12,14,3,15,16,13,8,18,9,10]; //fino a maxconversionunits-1
  static List<String> listaTitoli;

  @override
  void initState() {
    _getOrders();
    super.initState();  
  }


  void initializeTiles(){
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
                          icon: Icon(Icons.reorder,color: Colors.white,),
                          onPressed:(){
                            _changeOrderDrawer(context, MyLocalizations.of(context).trans('mio_ordinamento'));
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
            decoration: BoxDecoration(color: Theme.of(context).primaryColor/*listaColori[currentPage],*/),
            child:SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.reorder,color: Colors.white,),
                    onPressed:(){
                      _changeOrderDrawer(context, MyLocalizations.of(context).trans('mio_ordinamento'));
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

    listaDrawer[listaOrderDrawer[0]+1]=ListTileConversion(listaTitoli[0],"resources/images/lunghezza.png",currentPage==0,(){_onSelectItem(0);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[1]+1]=ListTileConversion(listaTitoli[1],"resources/images/area.png",currentPage==1,(){_onSelectItem(1);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[2]+1]=ListTileConversion(listaTitoli[2],"resources/images/volume.png",currentPage==2,(){_onSelectItem(2);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[3]+1]=ListTileConversion(listaTitoli[3],"resources/images/tempo.png",currentPage==3,(){_onSelectItem(3);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[4]+1]=ListTileConversion(listaTitoli[4],"resources/images/temperatura.png",currentPage==4,(){_onSelectItem(4);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[5]+1]=ListTileConversion(listaTitoli[5],"resources/images/velocita.png",currentPage==5,(){_onSelectItem(5);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[6]+1]=ListTileConversion(listaTitoli[6],"resources/images/prefissi.png",currentPage==6,(){_onSelectItem(6);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[7]+1]=ListTileConversion(listaTitoli[7],"resources/images/massa.png",currentPage==7,(){_onSelectItem(7);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[8]+1]=ListTileConversion(listaTitoli[8],"resources/images/pressione.png",currentPage==8,(){_onSelectItem(8);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[9]+1]=ListTileConversion(listaTitoli[9],"resources/images/energia.png",currentPage==9,(){_onSelectItem(9);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[10]+1]=ListTileConversion(listaTitoli[10],"resources/images/angoli.png",currentPage==10,(){_onSelectItem(10);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[11]+1]=ListTileConversion(listaTitoli[11],"resources/images/valuta.png",currentPage==11,(){_onSelectItem(11);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[12]+1]=ListTileConversion(listaTitoli[12],"resources/images/scarpe.png",currentPage==12,(){_onSelectItem(12);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[13]+1]=ListTileConversion(listaTitoli[13],"resources/images/dati.png",currentPage==13,(){_onSelectItem(13);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[14]+1]=ListTileConversion(listaTitoli[14],"resources/images/potenza.png",currentPage==14,(){_onSelectItem(14);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[15]+1]=ListTileConversion(listaTitoli[15],"resources/images/forza.png",currentPage==15,(){_onSelectItem(15);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[16]+1]=ListTileConversion(listaTitoli[16],"resources/images/torque.png",currentPage==16,(){_onSelectItem(16);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[17]+1]=ListTileConversion(listaTitoli[17],"resources/images/consumo.png",currentPage==17,(){_onSelectItem(17);Navigator.of(context).pop();});
    listaDrawer[listaOrderDrawer[18]+1]=ListTileConversion(listaTitoli[18],"resources/images/conversione_base.png",currentPage==18,(){_onSelectItem(18);Navigator.of(context).pop();});
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
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

  _onSelectItem(int index) {
    if(currentPage!=index){
      setState(() {
        currentPage = index;
      });
    }
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
             currentPage=i;
        }
        //risolve il problema di aggiunta di unità dopo un aggiornamento
        for(int i=len;i<MAX_CONVERSION_UNITS;i++){
          listaOrderDrawer[i]=i;
        }
      }
    });
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

    GlobalKey scaffoldKey = GlobalKey();


    return Scaffold(
      key: scaffoldKey,
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: listaDrawer,
        ),
      ),
      body: Builder(
        builder: (context) => 
        ConversionManager(
          () { Scaffold.of(context).openDrawer(); },   //open Drawer
          currentPage,                              //first page
          _onSelectItem,                             //change page
          listaTitoli
        ),
      )
    );
  }
}

