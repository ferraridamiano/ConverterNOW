import 'dart:math';
import 'package:converterpro/main.dart';

const LINEAR_CONVERSION = 1;     // y=ax+b
const RECIPROCO_CONVERSION = 2;  // y=(a/x)+b
const BASE_CONVERSION = 3;       // conversione speciale (dec è father e tutti gli altri figlio)
const KEYBOARD_NUMBER_DECIMAL = 1; //tastiera con solo numeri (anche decimali)
const KEYBOARD_NUMBER_INTEGER = 2;//solo interi positivi
const KEYBOARD_COMPLETE = 3;       //tastiera con anche le lettere

class Node {
  Node({
    this.leafNodes,
    this.isMultiplication=true,
    this.coefficientPer=1.0,
    this.isSum=true,
    this.coefficientPlus=0.0,
    this.name,
    this.value,
    this.symbol,
    this.convertedNode=false,
    this.selectedNode=false,
    this.conversionType=LINEAR_CONVERSION,
    this.keyboardType=KEYBOARD_NUMBER_DECIMAL,
    this.valueString,
    this.base,
    this.order
  });

  List<Node> leafNodes;
  bool isMultiplication;
  double coefficientPer;
  bool isSum;
  double coefficientPlus;
  double value;
  String name;
  String symbol;
  bool convertedNode;
  bool selectedNode;
  int conversionType;
  int order;
  int keyboardType;
  int base;
  String valueString;

  void convert() {
    if(!convertedNode) {             //se non è già convertito
      for (Node node in leafNodes) { //per ogni nodo foglia controlla se ha valore
        switch(node.conversionType){
          case LINEAR_CONVERSION:{
            _linearConvert(node);
            break;
          }
          case RECIPROCO_CONVERSION:{
            _reciprocoConvert(node);
            break;
          }
          case BASE_CONVERSION:{
            _baseConvert(node);
            break;
          }
        }
      }
    }
    else{ //se ha valore
      for (Node node in leafNodes) {
        if(node.convertedNode==false)
          _applyDown();
      }
    }
  }

  void _applyDown(){

    for(Node node in leafNodes){
      switch(node.conversionType){
        case LINEAR_CONVERSION:{
          _linearApplyDown(node);
          break;
        }
        case RECIPROCO_CONVERSION:{
          _reciprocoApplyDown(node);
          break;
        }
        case BASE_CONVERSION:{
          _baseApplyDown(node);
          break;
        }

      }
    }
  }


  void _linearConvert(Node node) { //da basso a alto
    if (node.convertedNode) {    //se un nodo foglia è già stato convertito
      value = node.value == null //faccio in calcoli del nodo padre rispetto a lui
          ? null
          : (node.isMultiplication ? node.value * node.coefficientPer : node.value / node.coefficientPer) +
          (node.isSum ? node.coefficientPlus : -node.coefficientPlus); //metto in questo nodo il valore convertito
      convertedNode = true;
      _applyDown(); //converto i nodi sottostanti
    }
    else if (node.leafNodes != null) { //Però ha almeno un nodo foglia
        node.convert(); //ripeti la procedura    
        if(node.convertedNode)
          convert();                             
    }
  }

  void _linearApplyDown(Node node){//da alto a a basso
    node.value= value==null
      ? null
      : (node.isSum ? value-node.coefficientPlus : value+node.coefficientPlus)*(node.isMultiplication ? 1/node.coefficientPer : node.coefficientPer);//attenzione qui funziona al contrario
    node.convertedNode=true;

    if(node.leafNodes != null)                                                //se ha almeno un nodo foglia allora continuo
      node._applyDown();
  }

  void _reciprocoConvert(Node node) { //da basso a alto
    if (node.convertedNode) {    //se un nodo foglia è già stato convertito
      value = node.value == null //faccio in calcoli del nodo padre rispetto a lui
          ? null
          : (node.coefficientPer/node.value)+node.coefficientPlus; //metto in questo nodo il valore convertito
      convertedNode = true;
      _applyDown(); //converto i nodi sottostanti
    }
    else if (node.leafNodes != null) { //Però ha almeno un nodo foglia
        node.convert(); //ripeti la procedura    
        if(node.convertedNode)
          convert();                             
    }
  }

  void _reciprocoApplyDown(Node node){//da alto a a basso
    node.value= value==null
      ? null
      : node.coefficientPer/(value-node.coefficientPlus);//attenzione qui funziona al contrario
    node.convertedNode=true;

    if(node.leafNodes != null)                                                //se ha almeno un nodo foglia allora continuo
      node._applyDown();
  }

  //attenzione! Questo tipo di conversione è stata costruita esclusivamente sulla struttura dec-(bin-oct-hex). Un padre con 3 figli
  void _baseConvert(Node node) { //da basso a alto
    if (node.convertedNode) {    //se un nodo foglia è già stato convertito
      if(node.valueString==null)
        valueString=null;
      else{
        valueString=baseToDec(node.valueString, node.base);
      }
      convertedNode = true;
      _applyDown(); //converto i nodi sottostanti
    }
    else if (node.leafNodes != null) { //Però ha almeno un nodo foglia
        node.convert(); //ripeti la procedura    
        if(node.convertedNode)
          convert();                             
    }
  }

  void _baseApplyDown(Node node){//da alto a a basso
    if(valueString==null){
      node.valueString=null;
    }
    else{
      node.valueString=decToBase(valueString, node.base);
    }

    node.convertedNode=true;

    if(node.leafNodes != null)                                                //se ha almeno un nodo foglia allora continuo
      node._applyDown();
  }


  //Resetta convertedNode su false per i nodi non selezionati dall'alto al basso (bisogna quindi chiamarlo dal nodo padre)
  void resetConvertedNode(){
    if(!selectedNode)                                                           //se non è il nodo selezionato
      convertedNode=false;                                                      //resetto il fatto che il nodo sia già stato convertito
    if(leafNodes!=null) {
      for (Node node in leafNodes) { //per ogni nodo dell'albero
        node.resetConvertedNode();
      }
    }
  }

  // Resetta tutti i valori dei nodi (da chiamare sul nodo padre)
  void clearAllValues(){
    List<Node> listanodi=_getNodiFiglio();
    for(Node nodo in listanodi){
      nodo.value=null;
      nodo.valueString=null;
    }
  }

  //Da chiamare sul nodo padre, resetta lo stato di selezionato per tutti i nodi (utile per cambio pagina)
  void clearSelectedNode(){
    List<Node> listanodi=_getNodiFiglio();
    for(Node nodo in listanodi){
      nodo.selectedNode=false;
    }
  }

  List<Node> _getNodiFiglio(){

    List<Node> listaNodi=[this];
    if(leafNodes != null){
      for(Node node in leafNodes) {
        listaNodi.addAll(node._getNodiFiglio());
      }
    }
    return listaNodi;
  }

  List<Node> getOrderedNodiFiglio(){
    List<Node> listaNodi=_getNodiFiglio();
    List<Node> orderedNodi=new List(listaNodi.length);

    for(int i=0; i<listaNodi.length;i++){
      int j=0;
      while(listaNodi[j].order!=i)
        j++;
      orderedNodi[i]=(listaNodi[j]);
    }

    return orderedNodi;
  }

  List<String> getStringOrderedNodiFiglio(){
    List<Node> listaNodi=getOrderedNodiFiglio();
    List<String>listaString=new List();
    for(Node node in listaNodi){
      listaString.add(node.name);
    }
    return listaString;
  }

  void reorderNodes(List<int> listaOrdine){
    List<Node> listaNodi=getOrderedNodiFiglio();
    for(int i=0; i<listaNodi.length;i++)
      listaNodi[i].order=listaOrdine[i];
  }

  String mantissaCorrection(){
    //Round to a fixed number of significant figures
    String stringValue=value.toStringAsPrecision(significantFigures);
    String append="";

    //if the user want to remove the trailing zeros
    if(removeTrailingZeros){
      //remove exponential part and append to the end
      if(stringValue.contains("e")) {
        append = "e" + stringValue.split("e")[1];
        stringValue=stringValue.split("e")[0];
      }

      //remove trailing zeros (just fractional part)
      if (stringValue.contains(".")) {
        int firstZeroIndex = stringValue.length;
        for (; firstZeroIndex > stringValue.indexOf("."); firstZeroIndex--) {
          String charAtIndex = stringValue.substring(firstZeroIndex - 1, firstZeroIndex);
          if (charAtIndex != "0" && charAtIndex != ".")
            break;
        }
        stringValue = stringValue.substring(0, firstZeroIndex);
      }
    }
    
    return stringValue+append; //append exponential part

  }

}

class CurrencyObject{
  DoubleCurrencyConversion results;
  CurrencyObject({this.results});
  
  factory CurrencyObject.fromJson(Map<String, dynamic> json) {
    return CurrencyObject(
      results: DoubleCurrencyConversion.fromJson(json['property'])
    );
  }
}

class DoubleCurrencyConversion{
  CurrencyConversion conversion1;
  CurrencyConversion conversion2;
  DoubleCurrencyConversion({
    this.conversion1,
    this.conversion2,
  });

  factory DoubleCurrencyConversion.fromJson(Map<String, dynamic> json){
    return DoubleCurrencyConversion(
      conversion1: CurrencyConversion.fromJson(json['USD_EUR']),
      conversion2: CurrencyConversion.fromJson(json['USD_GBP'])
    );
  }
}

class CurrencyConversion{
  String id,to,fr;
  double val;

  CurrencyConversion({
    this.id,
    this.val,
    this.to,
    this.fr
  });

  factory CurrencyConversion.fromJson(Map<String, dynamic> json){
    return CurrencyConversion(
      id: json['id'],
      val: json['val'],
      to: json['to'],
      fr: json['fr']
    );
  }
}

String decToBase(String stringDec, int base){

  RegExp regExp= getBaseRegExp(10);
  if(!regExp.hasMatch(stringDec))
    return "";

  String myString="";
  String restoString;
  int resto;
  int dec=int.parse(stringDec);
  while(dec>0){
    resto=(dec%base);
    restoString=resto.toString();
    if(resto>=10){
      restoString=String.fromCharCode(resto+55);
    }
    myString= restoString + myString; //aggiungo in testa
    dec=dec~/base;
  }
  return myString;
}

String baseToDec(String daConvertire, int base){
  daConvertire=daConvertire.toUpperCase();

  RegExp regExp=getBaseRegExp(base);

  if(!regExp.hasMatch(daConvertire))
    return "";

  int conversione=0;
  int len=daConvertire.length;
  for(int i=0;i<len;i++){
    int unitCode=daConvertire.codeUnitAt(i);
    if(unitCode>=65 && unitCode <= 70){ // da A a F
      conversione=conversione+(unitCode-55)*pow(base,i);
    }
    else if(unitCode>=48 && unitCode <= 57){ //da 0 a 9
      conversione=conversione+(unitCode-48)*pow(base,len-i-1);
    }
  }
  return conversione.toString();
}

RegExp getBaseRegExp(int base){
  RegExp regExp;
  switch(base){
    case 2:{
      regExp = new RegExp(r'^[0-1]+$');
      break;
    }
    case 8:{
      regExp = new RegExp(r'^[0-7]+$');
      break;
    }
    case 10:{
      regExp = new RegExp(r'^[0-9]+$');
      break;
    }
    case 16:{
      regExp = new RegExp(r'^[0-9A-Fa-f]+$');
      break;
    }
  }
  return regExp;
}

class CurrencyJSONObject{
  String base;
  Map<String, double> rates={"AUD":1.5794,"CHF":1.1206,"NZD":1.6551,"ILS":4.0513,"RUB":73.36,"PHP":58.608,"CAD":1.4964,"USD":1.1243,"THB":35.697,"SGD":1.5209,"JPY":125.3,"TRY":6.3014,"HKD":8.8246,"MYR":4.59,"NOK":9.6218,"SEK":10.43,"IDR":15939.2,"DKK":7.4643,"CZK":25.724,"HUF":320.05,"GBP":0.8539,"MXN":21.5195,"KRW":1275.35,"ZAR":15.912,"BRL":4.313,"PLN":4.293,"INR":76.9305,"RON":4.7555,"CNY":7.5423}; //base euro (aggiornato a 04/04/2019)

  String date;

  CurrencyJSONObject({this.base, this.rates, this.date});

  factory CurrencyJSONObject.fromJson(Map<String, dynamic> parsedJson){
    Map<String, dynamic> ratesJson=parsedJson['rates'];
    return CurrencyJSONObject(
      base: parsedJson['base'],
      date: parsedJson['date'],
      rates: {
        "INR":ratesJson['INR'],
        "SEK":ratesJson['SEK'],
        "GBP":ratesJson['GBP'],
        "CHF":ratesJson['CHF'],
        "CNY":ratesJson['CNY'],
        "RUB":ratesJson['RUB'],
        "USD":ratesJson['USD'],
        "KRW":ratesJson['KRW'],
        "JPY":ratesJson['JPY'],
        "BRL":ratesJson['BRL'],
        "CAD":ratesJson['CAD'],
        "HKD":ratesJson['HKD'],
        "AUD":ratesJson['AUD'],
        "NZD":ratesJson['NZD'],
        "MXN":ratesJson['MXN'],
        "SGD":ratesJson['SGD'],
        "NOK":ratesJson['NOK'],
        "TRY":ratesJson['TRY'],
        "ZAR":ratesJson['ZAR'],
        "DKK":ratesJson['DKK'],
        "PLN":ratesJson['PLN'],
        "THB":ratesJson['THB'],
        "MYR":ratesJson['MYR'],
        "HUF":ratesJson['HUF'],
        "CZK":ratesJson['CZK'],
        "ILS":ratesJson['ILS'],
        "IDR":ratesJson['IDR'],
        "PHP":ratesJson['PHP'],
        "RON":ratesJson['RON']}
    );
  }

  ///Recreates the body of the http response (json format) as a String
  String toString(){
    String myString = '{"rates":{';
    rates.forEach((key, value) => myString += '"$key":${value.toString()},'); //add all the currency values
    myString = myString.replaceRange(myString.length-1, myString.length,''); //remove latest comma
    myString += '},"base":"$base","date":"$date"}';
    return myString;
  }
}