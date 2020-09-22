import 'package:converterpro/pages/ReorderPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel with ChangeNotifier {

  static List<int> _conversionsOrderDrawer = [0,1,2,4,5,6,17,7,11,12,14,3,15,16,13,8,18,9,10]; //until a max conversion units - 1
  int _currentPage = 0;

  ///Returns the order of the tile of the conversions in the drawer
  get conversionsOrderDrawer => _conversionsOrderDrawer;

  ///Returns the current page (e.g: temperature, mass, etc)
  get currentPage => _currentPage;

  ///Method needed to change the selected conversion page
  ///e.g: from temperature to mass, etc
  changeToPage(int index) {
    if(_currentPage!=index){
      _currentPage = index;
      notifyListeners();
    }
  }

  ///Updates the order of the tiles in the drawer
  _getOrdersDrawer() async {
    //aggiorno lista del drawer
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List <String> stringList=prefs.getStringList("orderDrawer");
    if(stringList!=null){
      final int len=stringList.length;
      for(int i=0;i<len;i++){
        _conversionsOrderDrawer[i]=int.parse(stringList[i]);
        if(_conversionsOrderDrawer[i]==0)
           _currentPage=i;
      }
      //risolve il problema di aggiunta di unità dopo un aggiornamento
      for(int i=len;i<_conversionsOrderDrawer.length;i++){
        _conversionsOrderDrawer[i]=i;
      }
    }
    notifyListeners();
  }

  ///Changes the orders of the tiles in the Drawer
  changeOrderDrawer(BuildContext context, String title, List<String> titlesList) async{

    List orderedList=new List(_conversionsOrderDrawer.length);
    for(int i=0;i<_conversionsOrderDrawer.length;i++){
      orderedList[_conversionsOrderDrawer[i]]=titlesList[i];
    }

    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReorderPage(
            title: title,
            listaElementi: orderedList, 
        ),));

    List arrayCopia=new List(_conversionsOrderDrawer.length);
    for(int i=0;i<_conversionsOrderDrawer.length;i++)
      arrayCopia[i]=_conversionsOrderDrawer[i];
    for(int i=0;i<_conversionsOrderDrawer.length;i++)
      _conversionsOrderDrawer[i]=result.indexOf(arrayCopia[i]);
    
    notifyListeners();

    List<String> toConvertList=new List();
    for(int item in _conversionsOrderDrawer)
      toConvertList.add(item.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("orderDrawer", toConvertList);

  }

}