import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier{
  bool _isLogoVisible = true;
  bool _removeTrailingZeros = true;
  static final List<int> _significantFiguresList = <int>[6, 8, 10, 12, 14];
  int _significantFigures = _significantFiguresList[2];
  SharedPreferences prefs;

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