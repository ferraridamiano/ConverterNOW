import 'package:converter_pro/ConversionPage.dart';
import 'package:converter_pro/Localization.dart';
import 'package:converter_pro/ReorderPage.dart';
import 'package:converter_pro/SettingsPage.dart';
import 'package:converter_pro/Utils.dart';
import 'package:converter_pro/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConversionManager extends StatefulWidget{
  @override
  _ConversionManager createState() => new _ConversionManager();

}

class _ConversionManager extends State<ConversionManager>{

  static final MAX_CONVERSION_UNITS =11;
  static List listaConversioni;
  static List listaColori=[Colors.red,Colors.deepOrange,Colors.amber,
  Colors.cyan, Colors.indigo, Colors.purple,
  Colors.blueGrey,Colors.green,Colors.pinkAccent,
  Colors.teal, Colors.blue];
  static List listaTitoli;
  static int _currentPage=0;
  static List orderLunghezza=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  static List orderSuperficie=[0,1,2,3,4,5,6,7,8,9];
  static List orderVolume=[0,1,2,3,4,5,6,7,8,9,10,11,12,13];
  static List orderTempo=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14];
  static List orderTemperatura=[0,1,2];
  static List orderVelocita=[0,1,2,3,4];
  static List orderPrefissi=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
  static List orderMassa=[0,1,2,3,4,5,6,7];
  static List orderPressione=[0,1,2,3,4,5];
  static List orderEnergia=[0,1,2,3];
  static List orderAngoli=[0,1,2,3];
  static List listaOrder=[orderLunghezza,orderSuperficie, orderVolume,orderTempo,orderTemperatura,orderVelocita,orderPrefissi,orderMassa,orderPressione,orderEnergia,orderAngoli];
  static List<Widget> listaDrawer=new List(MAX_CONVERSION_UNITS+2);//+2 perchè c'è l'intestazione con il logo e lo spazio finale
  static List<int> listaOrderDrawer=[0,1,2,3,4,5,6,7,8,9,10]; //fino a maxconversionunits

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  void initializeTiles(){
    listaDrawer[0]=(Stack(
      children: <Widget>[
        DrawerHeader(
          child: Container(
              child:SvgPicture.asset("resources/images/logo.svg",),
          ),
          decoration: BoxDecoration(color: listaColori[_currentPage],),
        ),
        Container(
          child:Column(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ],
          ),
          height: 190.0,
          alignment: FractionalOffset.bottomRight,
        )

      ],
      fit: StackFit.passthrough,
    ));
    listaDrawer[listaOrderDrawer[0]+1]=ListTileConversion(listaTitoli[0],"resources/images/lunghezza.svg",listaColori[0],_currentPage==0,(){_onSelectItem(0);});
    listaDrawer[listaOrderDrawer[1]+1]=ListTileConversion(listaTitoli[1],"resources/images/area.svg",listaColori[1],_currentPage==1,(){_onSelectItem(1);});
    listaDrawer[listaOrderDrawer[2]+1]=ListTileConversion(listaTitoli[2],"resources/images/volume.svg",listaColori[2],_currentPage==2,(){_onSelectItem(2);});
    listaDrawer[listaOrderDrawer[3]+1]=ListTileConversion(listaTitoli[3],"resources/images/tempo.svg",listaColori[3],_currentPage==3,(){_onSelectItem(3);});
    listaDrawer[listaOrderDrawer[4]+1]=ListTileConversion(listaTitoli[4],"resources/images/temperatura.svg",listaColori[4],_currentPage==4,(){_onSelectItem(4);});
    listaDrawer[listaOrderDrawer[5]+1]=ListTileConversion(listaTitoli[5],"resources/images/velocita.svg",listaColori[5],_currentPage==5,(){_onSelectItem(5);});
    listaDrawer[listaOrderDrawer[6]+1]=ListTileConversion(listaTitoli[6],"resources/images/prefissi.svg",listaColori[6],_currentPage==6,(){_onSelectItem(6);});
    listaDrawer[listaOrderDrawer[7]+1]=ListTileConversion(listaTitoli[7],"resources/images/massa.svg",listaColori[7],_currentPage==7,(){_onSelectItem(7);});
    listaDrawer[listaOrderDrawer[8]+1]=ListTileConversion(listaTitoli[8],"resources/images/pressione.svg",listaColori[8],_currentPage==8,(){_onSelectItem(8);});
    listaDrawer[listaOrderDrawer[9]+1]=ListTileConversion(listaTitoli[9],"resources/images/energia.svg",listaColori[9],_currentPage==9,(){_onSelectItem(9);});
    listaDrawer[listaOrderDrawer[10]+1]=ListTileConversion(listaTitoli[10],"resources/images/angoli.svg",listaColori[10],_currentPage==10,(){_onSelectItem(10);});
    listaDrawer[MAX_CONVERSION_UNITS+1]=SizedBox(height: AD_SIZE,);
  }

  _onSelectItem(int index) {
    if(_currentPage!=index) {
      setState(() {
        _currentPage = index;
        Navigator.of(context).pop();
      });
    }
  }


  _saveOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> toConvertList=new List();
    for(int item in listaOrder[_currentPage])
      toConvertList.add(item.toString());
    prefs.setStringList("conversion_$_currentPage", toConvertList);
  }
  _getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //aggiorno lista del drawer
    List <String> stringList=prefs.getStringList("orderDrawer");
    setState((){
      if(stringList!=null){
        for(int i=0;i<MAX_CONVERSION_UNITS;i++){
          listaOrderDrawer[i]=int.parse(stringList[i]);
        }
        _currentPage=listaOrderDrawer[0];
      }
    });


    //aggiorno ordine unità di ogni grandezza fisica
    for(int i=0;i<MAX_CONVERSION_UNITS;i++){
      stringList=prefs.getStringList("conversion_$i");

      if(stringList!=null){
        List intList=new List();
        for(int j=0;j<stringList.length;j++){
          intList.add(int.parse(stringList[j]));
        }
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
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

    Node metro=Node(name: MyLocalizations.of(context).trans('metro',),order: listaOrder[0][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('centimetro'),order: listaOrder[0][1], leafNodes: [
            Node(isMultiplication: true, coefficientPer: 2.54, name: MyLocalizations.of(context).trans('pollice'),order: listaOrder[0][2], leafNodes: [
              Node(isMultiplication: true, coefficientPer: 12.0, name: MyLocalizations.of(context).trans('piede'),order: listaOrder[0][3]),
            ]),
          ]),
          Node(isMultiplication: true, coefficientPer: 1852.0, name: MyLocalizations.of(context).trans('miglio_marino'),order: listaOrder[0][4],),
          Node(isMultiplication: true, coefficientPer: 0.9144, name: MyLocalizations.of(context).trans('yard'),order: listaOrder[0][5], leafNodes: [
            Node(isMultiplication: true, coefficientPer: 1760.0, name: MyLocalizations.of(context).trans('miglio_terrestre'),order: listaOrder[0][6],),
          ]),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millimetro'),order: listaOrder[0][7],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('micrometro'), order: listaOrder[0][8],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('nanometro'),order: listaOrder[0][9],),
          Node(isMultiplication: false, coefficientPer: 10000000000.0, name: MyLocalizations.of(context).trans('angstrom'),order: listaOrder[0][10],),
          Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: MyLocalizations.of(context).trans('picometro'),order: listaOrder[0][11],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('chilometro'),order: listaOrder[0][12],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 149597870.7, name: MyLocalizations.of(context).trans('unita_astronomica'),order: listaOrder[0][13],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 63241.1, name: MyLocalizations.of(context).trans('anno_luce'),order: listaOrder[0][14],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 3.26, name: MyLocalizations.of(context).trans('parsec'),order: listaOrder[0][15],),
              ]),
            ]),
          ]),
        ]);

    Node metroq=Node(name: MyLocalizations.of(context).trans('metro_quadrato'),order: listaOrder[1][0],leafNodes: [
      Node(isMultiplication: false, coefficientPer: 10000.0, name: MyLocalizations.of(context).trans('centimetro_quadrato'),order: listaOrder[1][1], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 6.4516, name: MyLocalizations.of(context).trans('pollice_quadrato'),order: listaOrder[1][2], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 144.0, name: MyLocalizations.of(context).trans('piede_quadrato'),order: listaOrder[1][3]),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('millimetro_quadrato'),order: listaOrder[1][4],),
      Node(isMultiplication: true, coefficientPer: 10000.0, name: MyLocalizations.of(context).trans('ettaro'),order: listaOrder[1][5],),
      Node(isMultiplication: true, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('chilometro_quadrato'),order: listaOrder[1][6],),
      Node(isMultiplication: true, coefficientPer: 0.83612736, name: MyLocalizations.of(context).trans('yard_quadrato'),order: listaOrder[1][7], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 3097600.0, name: MyLocalizations.of(context).trans('miglio_quadrato'),order: listaOrder[1][8]),
        Node(isMultiplication: true, coefficientPer: 4840.0, name: MyLocalizations.of(context).trans('acri'),order: listaOrder[1][9],),
      ]),
    ]);

    Node metroc=Node(name: MyLocalizations.of(context).trans('metro_cubo'),order: listaOrder[2][0],leafNodes: [
      Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('litro'),order: listaOrder[2][1],leafNodes: [
        Node(isMultiplication: true, coefficientPer: 4.54609, name: MyLocalizations.of(context).trans('gallone_imperiale'),order: listaOrder[2][2],),
        Node(isMultiplication: true, coefficientPer: 3.785411784, name: MyLocalizations.of(context).trans('gallone_us'),order: listaOrder[2][3],),
        Node(isMultiplication: true, coefficientPer: 0.56826125, name: MyLocalizations.of(context).trans('pinta_imperiale'),order: listaOrder[2][4],),
        Node(isMultiplication: true, coefficientPer: 0.473176473, name: MyLocalizations.of(context).trans('pinta_us'),order: listaOrder[2][5],),
        Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millilitro'),order: listaOrder[2][6], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 14.8, name: MyLocalizations.of(context).trans('tablespoon_us'),order: listaOrder[2][7],),
          Node(isMultiplication: true, coefficientPer: 20.0, name: MyLocalizations.of(context).trans('tablespoon_australian'),order:listaOrder[2][8],),
          Node(isMultiplication: true, coefficientPer: 240.0, name: MyLocalizations.of(context).trans('cup_us'),order: listaOrder[2][9],),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('centimetro_cubo'),order: listaOrder[2][10], leafNodes: [
        Node(isMultiplication: true, coefficientPer: 16.387064, name: MyLocalizations.of(context).trans('pollice_cubo'),order: listaOrder[2][11], leafNodes: [
          Node(isMultiplication: true, coefficientPer: 1728.0, name: MyLocalizations.of(context).trans('piede_cubo'),order: listaOrder[2][12],),
        ]),
      ]),
      Node(isMultiplication: false, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('millimetro_cubo'),order: listaOrder[2][13],),
    ]);

    Node secondo=Node(name: MyLocalizations.of(context).trans('secondo'),order: listaOrder[3][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 10.0, name: MyLocalizations.of(context).trans('decimo_secondo'),order: listaOrder[3][1],),
          Node(isMultiplication: false, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('centesimo_secondo'), order: listaOrder[3][2],),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millisecondo'),order: listaOrder[3][3],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('microsecondo'),order: listaOrder[3][4],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: MyLocalizations.of(context).trans('nanosecondo'),order: listaOrder[3][5],),
          Node(isMultiplication: true, coefficientPer: 60.0, name: MyLocalizations.of(context).trans('minuti'),order: listaOrder[3][6],leafNodes: [
            Node(isMultiplication: true, coefficientPer: 60.0, name: MyLocalizations.of(context).trans('ore'),order: listaOrder[3][7],leafNodes: [
              Node(isMultiplication: true, coefficientPer: 24.0, name: MyLocalizations.of(context).trans('giorni'),order: listaOrder[3][8],leafNodes: [
                Node(isMultiplication: true, coefficientPer: 7.0, name: MyLocalizations.of(context).trans('settimane'),order: listaOrder[3][9],),
                Node(isMultiplication: true, coefficientPer: 365.0, name: MyLocalizations.of(context).trans('anno'),order: listaOrder[3][10],leafNodes: [
                  Node(isMultiplication: true, coefficientPer: 5.0, name: MyLocalizations.of(context).trans('lustro'),order: listaOrder[3][11],),
                  Node(isMultiplication: true, coefficientPer: 10.0, name: MyLocalizations.of(context).trans('decade'),order: listaOrder[3][12],),
                  Node(isMultiplication: true, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('secolo'),order: listaOrder[3][13],),
                  Node(isMultiplication: true, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millennio'),order: listaOrder[3][14],),
                ]),
              ]),
            ]),
          ]),
        ]);

    Node celsius=Node(name: MyLocalizations.of(context).trans('fahrenheit'),order: listaOrder[4][0],leafNodes:[
      Node(isMultiplication: true, coefficientPer: 1.8, isSum: true, coefficientPlus: 32.0, name: MyLocalizations.of(context).trans('celsius'),order: listaOrder[4][1],leafNodes: [
        Node(isSum: false, coefficientPlus: 273.15, name: MyLocalizations.of(context).trans('kelvin'),order: listaOrder[4][2],),
      ]),
    ]);

    Node metri_secondo=Node(name: MyLocalizations.of(context).trans('metri_secondo'), order: listaOrder[5][0], leafNodes: [
      Node(isMultiplication: false, coefficientPer: 3.6, name: MyLocalizations.of(context).trans('chilometri_ora'),order: listaOrder[5][1], leafNodes:[
        Node(isMultiplication: true, coefficientPer: 1.609344, name: MyLocalizations.of(context).trans('miglia_ora'),order: listaOrder[5][2],),
        Node(isMultiplication: true, coefficientPer: 1.852, name: MyLocalizations.of(context).trans('nodi'),order: listaOrder[5][3],),
      ]),
      Node(isMultiplication: true, coefficientPer: 0.3048, name: MyLocalizations.of(context).trans('piedi_secondo'),order: listaOrder[5][4],),
    ]);

    Node SI=Node(name: "Base",order: listaOrder[6][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 10.0, name: "Deca [da]",order: listaOrder[6][1],),
          Node(isMultiplication: true, coefficientPer: 100.0, name: "Hecto [h]",order: listaOrder[6][2],),
          Node(isMultiplication: true, coefficientPer: 1000.0, name: "Kilo [k]",order: listaOrder[6][3],),
          Node(isMultiplication: true, coefficientPer: 1000000.0, name: "Mega [M]",order: listaOrder[6][4],),
          Node(isMultiplication: true, coefficientPer: 1000000000.0, name: "Giga [G]",order: listaOrder[6][5],),
          Node(isMultiplication: true, coefficientPer: 1000000000000.0, name: "Tera [T]",order: listaOrder[6][6],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000.0, name: "Peta [P]",order: listaOrder[6][7],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000.0, name: "Exa [E]",order: listaOrder[6][8],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000000.0, name: "Zetta [Z]",order: listaOrder[6][9],),
          Node(isMultiplication: true, coefficientPer: 1000000000000000000000000.0, name: "Yotta [Y]",order: listaOrder[6][10],),
          Node(isMultiplication: false, coefficientPer: 10.0, name: "Deci [d]",order: listaOrder[6][11],),
          Node(isMultiplication: false, coefficientPer: 100.0, name: "Centi [c]",order: listaOrder[6][12],),
          Node(isMultiplication: false, coefficientPer: 1000.0, name: "Milli [m]",order: listaOrder[6][13],),
          Node(isMultiplication: false, coefficientPer: 1000000.0, name: "Micro [µ]",order: listaOrder[6][14],),
          Node(isMultiplication: false, coefficientPer: 1000000000.0, name: "Nano [n]",order: listaOrder[6][15],),
          Node(isMultiplication: false, coefficientPer: 1000000000000.0, name: "Pico [p]",order: listaOrder[6][16],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000.0, name: "Femto [f]",order: listaOrder[6][17],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000.0, name: "Atto  [a]",order: listaOrder[6][18],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000000.0, name: "Zepto [z]",order: listaOrder[6][19],),
          Node(isMultiplication: false, coefficientPer: 1000000000000000000000000.0, name: "Yocto [y]",order: listaOrder[6][20],),
        ]
    );

    //da sistemare ordinamento e nome
    Node grammo=Node(name: MyLocalizations.of(context).trans('grammo'),order: listaOrder[7][0],
      leafNodes: [
      Node(isMultiplication: true, coefficientPer: 100.0, name: MyLocalizations.of(context).trans('ettogrammo'),order: listaOrder[7][1],),
      Node(isMultiplication: true, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('chilogrammo'),order: listaOrder[7][2],leafNodes:[
        Node(isMultiplication: true, coefficientPer: 0.45359237, name: MyLocalizations.of(context).trans('libbra'),order: listaOrder[7][3],),
      ]),
      Node(isMultiplication: true, coefficientPer: 100000.0, name: MyLocalizations.of(context).trans('quintale'),order: listaOrder[7][4],),
      Node(isMultiplication: true, coefficientPer: 1000000.0, name: MyLocalizations.of(context).trans('tonnellata'),order: listaOrder[7][5],),
      Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('milligrammo'),order: listaOrder[7][6],),
      Node(isMultiplication: true, coefficientPer: 1.660539e-24, name: MyLocalizations.of(context).trans('uma'),order: listaOrder[7][7],),
    ]);

    Node pascal=Node(name: MyLocalizations.of(context).trans('pascal'),order: listaOrder[8][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 101325.0, name: MyLocalizations.of(context).trans('atmosfere'),order: listaOrder[8][1],leafNodes:[
            Node(isMultiplication: true, coefficientPer: 0.987, name: MyLocalizations.of(context).trans('bar'),order: listaOrder[8][2],leafNodes:[
              Node(isMultiplication: false, coefficientPer: 1000.0, name: MyLocalizations.of(context).trans('millibar'),order: listaOrder[8][3],),
            ]),
          ]),
          Node(isMultiplication: true, coefficientPer: 6894.757293168, name: MyLocalizations.of(context).trans('psi'),order: listaOrder[8][4],),
          Node(isMultiplication: true, coefficientPer: 133.322368421, name: MyLocalizations.of(context).trans('torr'),order: listaOrder[8][5],),
    ]);

    Node joule=Node(name: MyLocalizations.of(context).trans('joule'),order: listaOrder[9][0],
        leafNodes: [
          Node(isMultiplication: true, coefficientPer: 4.1867999409, name: MyLocalizations.of(context).trans('calorie'),order: listaOrder[9][1]),
          Node(isMultiplication: true, coefficientPer: 3600000.0, name: MyLocalizations.of(context).trans('kilowattora'),order: listaOrder[9][2],),
          Node(isMultiplication: true, coefficientPer: 1.60217646e-19, name: MyLocalizations.of(context).trans('elettronvolt'),order: listaOrder[9][3],),
        ]);
    Node gradi=Node(name:MyLocalizations.of(context).trans('gradi'),order: listaOrder[10][0],
        leafNodes: [
          Node(isMultiplication: false, coefficientPer: 60.0, name: MyLocalizations.of(context).trans('primi'),order: listaOrder[10][1]),
          Node(isMultiplication: false, coefficientPer: 3600.0, name: MyLocalizations.of(context).trans('secondi'),order: listaOrder[10][2]),
          Node(isMultiplication: true, coefficientPer: 57.295779513, name: MyLocalizations.of(context).trans('radianti'),order: listaOrder[10][3]),
    ]);


    listaConversioni=[metro,metroq, metroc,secondo, celsius, metri_secondo,SI,grammo,pascal,joule,gradi];
    listaTitoli=[MyLocalizations.of(context).trans('lunghezza'),MyLocalizations.of(context).trans('superficie'),MyLocalizations.of(context).trans('volume'),
    MyLocalizations.of(context).trans('tempo'),MyLocalizations.of(context).trans('temperatura'),MyLocalizations.of(context).trans('velocita'),
    MyLocalizations.of(context).trans('prefissi_si'),MyLocalizations.of(context).trans('massa'),MyLocalizations.of(context).trans('pressione'),
    MyLocalizations.of(context).trans('energia'), MyLocalizations.of(context).trans('angoli')];
    initializeTiles();

    List<Choice> choices = <Choice>[
      Choice(title: MyLocalizations.of(context).trans('riordina'), icon: Icons.reorder),
    ];

    return Scaffold(
      appBar: AppBar(
        title: new Text(listaTitoli[_currentPage]),
        backgroundColor: listaColori[_currentPage],
        actions: <Widget>[
          IconButton(icon: Icon(Icons.clear,color: Colors.white,semanticLabel: 'Clear all',),
            onPressed: () {
              setState(() {
                listaConversioni[_currentPage].ClearAllValues();
              });
            },),
          PopupMenuButton<Choice>(
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
        ],
      ),
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: listaDrawer,
      ),
      ),
      body: ConversionPage(listaConversioni[_currentPage]),
      floatingActionButton: FloatingActionButton(
        child: SvgPicture.asset("resources/images/calculator.svg",width: 30.0,),
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(
                alignment: Alignment.center,
                child: Calculator(listaColori[_currentPage]),
              );
            }
          );
        },
        elevation: 10.0,
        backgroundColor: listaColori[_currentPage],
      ),

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
          SvgPicture.asset(widget.imagePath,width: 30.0,height: 30.0, color:  widget.selected ? widget.color : Colors.black54,),
          SizedBox(width: 20.0,),
          Text(widget.text)
        ],),
        selected: widget.selected,
        onTap: widget.onTapFunction
      ),
      selectedColor: widget.color,
    );
  }
}