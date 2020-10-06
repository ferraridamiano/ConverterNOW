import 'package:converterpro/pages/ReorderPage.dart';
import 'package:converterpro/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel with ChangeNotifier {

  List<int> _conversionsOrderDrawer = [0,1,2,4,5,6,17,7,11,12,14,3,15,16,13,8,18,9,10]; //until a max conversion units - 1
  int _currentPage = 0;
  bool _showRateSnackBar = false;
  bool _isLogoVisible = true;
  bool _removeTrailingZeros = true;
  static final List<int> _significantFiguresList = <int>[6, 8, 10, 12, 14];
  int _significantFigures = _significantFiguresList[2];
  SharedPreferences prefs;

  AppModel(){
    _checkOrdersDrawer();
    _getShowRateSnackBar();
  }

  ///Returns the order of the tile of the conversions in the drawer
  get conversionsOrderDrawer => _conversionsOrderDrawer;

  ///Returns the current page (e.g: temperature, mass, etc)
  get currentPage => _currentPage;

  ///Returns true if the UI have to request if the user wants to rate the app, false otherwise.
  ///Returns true if the user has accessed the app at least 5 times AND if the user has not
  ///already rated the app AND with a probability of 30%
  get showRateSnackbar => _showRateSnackBar;

  ///Method needed to change the selected conversion page
  ///e.g: from temperature to mass, etc
  changeToPage(int index) {
    if(_currentPage != index){
      _currentPage = index;
      notifyListeners();
    }
  }

  ///Updates the order of the tiles in the drawer
  _checkOrdersDrawer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List <String> stringList = prefs.getStringList("orderDrawer");
    if(stringList != null){
      final int len = stringList.length;
      for(int i=0;i<len;i++){
        _conversionsOrderDrawer[i]=int.parse(stringList[i]);
        if(_conversionsOrderDrawer[i]==0)
           _currentPage=i;
      }
      //If new units of mesurement will be added the following 2
      //lines of code ensure that everything will works fine
      for(int i=len;i<_conversionsOrderDrawer.length;i++){
        _conversionsOrderDrawer[i]=i;
      }
    }
    notifyListeners();
  }

  ///Changes the orders of the tiles in the Drawer
  changeOrderDrawer(BuildContext context, List<String> titlesList) async{
    Navigator.of(context).pop();    //Close the drawer

    List orderedList=new List(_conversionsOrderDrawer.length);
    for(int i=0;i<_conversionsOrderDrawer.length;i++){
      orderedList[_conversionsOrderDrawer[i]]=titlesList[i];
    }

    final result = await Navigator.push(context,MaterialPageRoute(builder: (context) => ReorderPage(listaElementi: orderedList,)));

    List arrayCopia=new List(_conversionsOrderDrawer.length);
    for(int i=0;i<_conversionsOrderDrawer.length;i++)
      arrayCopia[i]=_conversionsOrderDrawer[i];
    for(int i=0;i<_conversionsOrderDrawer.length;i++)
      _conversionsOrderDrawer[i]=result.indexOf(arrayCopia[i]);

    notifyListeners();
    //save new orders to memory
    List<String> toConvertList=new List();
    for(int item in _conversionsOrderDrawer)
      toConvertList.add(item.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("orderDrawer", toConvertList);
  }

  ///Returns true if the UI have to request if the user wants to rate the app, false otherwise.
  ///Returns true if the user has accessed the app at least 5 times AND if the user has not
  ///already rated the app AND with a probability of 30%
  _getShowRateSnackBar() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int numberOfAccess = prefs.getInt("access_number") ?? 0;
    numberOfAccess++;
    if (numberOfAccess < 5) //traccio solo i primi 5 accessi per dialog rating
      prefs.setInt("access_number", numberOfAccess);
    bool stopRequestRating = prefs.getBool("stop_request_rating") ?? false;
    if(numberOfAccess >=5 && !stopRequestRating && getBoolWithProbability(30))
      _showRateSnackBar = true;
    _showRateSnackBar = false;
    notifyListeners();
  }

  //Settings section------------------------------------------------------------------
  ///Returns true if the drawer logo is visible, false otherwise
  bool get isLogoVisible => _isLogoVisible;
  
  ///Returns true if you want to remove the trailing zeros of the conversions
  ///e.g. 1.000000000e20 becomes 1e20
  bool get removeTrailingZeros => _removeTrailingZeros;

  ///Returns the list of possibile significant figures
  List<int> get significantFiguresList => _significantFiguresList;

  ///Returns the current significant figures selection
  int get significantFigures => _significantFigures;

  ///Set the drawer logo visibility and save to SharedPreferences
  set isLogoVisible (bool value){
    _isLogoVisible = value;
    notifyListeners();
    _getPreferences().then((myPrefs) => myPrefs.setBool("isLogoVisible", _isLogoVisible));
  }

  ///Set the ability of remove unecessary trailing zeros and save to SharedPreferences
  ///e.g. 1.000000000e20 becomes 1e20
  set removeTrailingZeros (bool value){
    _removeTrailingZeros = value;
    notifyListeners();
    _getPreferences().then((myPrefs) => myPrefs.setBool("remove_trailing_zeros", removeTrailingZeros));
  }

  ///Set the current significant figures selection and save to SharedPreferences
  set significantFigures (int value){
    _significantFigures = value;
    notifyListeners();
    _getPreferences().then((myPrefs) => myPrefs.setInt("significant_figures", significantFigures));
  }

  Future<SharedPreferences> _getPreferences() async {
    if(prefs != null)
      return prefs;
    else{
      prefs = await SharedPreferences.getInstance();
      return prefs;
    }
  }

}