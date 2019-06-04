import 'package:converter_pro/ConversionManager.dart';
import 'package:converter_pro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

const LINEAR_CONVERSION = 1;     // y=ax+b
const RECIPROCO_CONVERSION = 2;  // y=(a/x)+b
const BASE_CONVERSION = 3;       // conversione speciale (dec è father e tutti gli altri figlio)
const KEYBOARD_NUMBER_DECIMAL = 1; //tastiera con solo numeri (anche decimali)
const KEYBOARD_NUMBER_INTEGER = 2;//solo interi positivi
const KEYBOARD_COMPLETE = 3;       //tastiera con anche le lettere

abstract class ListItem {}

class myCard implements ListItem{
  myCard({this.node, this.textField});

  Node node;
  final Widget textField;
}

class bigHeader implements ListItem{
  bigHeader({this.title, this.subTitle});
  String title;
  String subTitle;
}

class bigTitle extends StatelessWidget{

  bigTitle(this.text, this.subtitle);
  String text;
  String subtitle="";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 83.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children:<Widget>[
          SizedBox(height: 20.0,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
            Container(
              child: Text(text,style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold,color: darkTheme ? Color(0xFFDDDDDD) : Color(0xFF666666)),),
            ),
            Container(
              height: 30.0,
              alignment: Alignment.bottomRight,
              child: (isCurrencyLoading && subtitle!="") ? Container(child:CircularProgressIndicator(),height: 25.0,width: 25.0,) : Text(subtitle,style: TextStyle(fontSize: 15.0,color: Color(0xFF999999)),),
            ),

          ],
          ),
          
          
          Divider(color: Colors.grey,),
        ]
      ),
    );
  }

}

class UnitCard extends StatelessWidget{
  UnitCard({this.node, this.textField});

  Node node;
  final Widget textField;

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(bottom: 5.0),
        child: new Card(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      node.name,
                      style: TextStyle(
                          fontSize: 18.0,
                          //fontWeight: FontWeight.bold
                      ),
                    ),
                    new SizedBox(
                      width: 20.0,
                    ),
                    this.textField
                  ])),
          elevation: 4.0,
        ));
  }
}

class Node {
  Node({
    this.leafNodes,
    this.isMultiplication=true,
    this.coefficientPer=1.0,
    this.isSum=true,
    this.coefficientPlus=0.0,
    this.name,
    this.value,
    this.convertedNode=false,
    this.selectedNode=false,
    this.conversionType=LINEAR_CONVERSION,
    this.keyboardType=KEYBOARD_NUMBER_DECIMAL,
    this.valueString,
    this.valueInt,
    this.base,
    @required this.order
  });

  List<Node> leafNodes;
  bool isMultiplication;
  double coefficientPer;
  bool isSum;
  double coefficientPlus;
  double value;
  String name;
  bool convertedNode;
  bool selectedNode;
  int conversionType;
  int order;
  int keyboardType;
  int base;
  String valueString;
  int valueInt;

  @override
  String toString() {
    return "isMultiplication:$isMultiplication, coefficient:$coefficientPer, "
        "value:$value, name:$name, coonvertedNode:$convertedNode, selectedNode:$selectedNode";
  }

  void Convert() {
    if(!convertedNode) {             //se non è già convertito
      for (Node node in leafNodes) { //per ogni nodo foglia controlla se ha valore
        switch(node.conversionType){
          case LINEAR_CONVERSION:{
            _LinearConvert(node);
            break;
          }
          case RECIPROCO_CONVERSION:{
            _ReciprocoConvert(node);
            break;
          }
          case BASE_CONVERSION:{
            _BaseConvert(node);
            break;
          }
        }
      }
    }
    else{ //se ha valore
      for (Node node in leafNodes) {
        if(node.convertedNode==false)
          _ApplyDown();
      }
    }
  }

  void _ApplyDown(){

    for(Node node in leafNodes){
      switch(node.conversionType){
        case LINEAR_CONVERSION:{
          _Linear_ApplyDown(node);
          break;
        }
        case RECIPROCO_CONVERSION:{
          _Reciproco_ApplyDown(node);
          break;
        }
        case BASE_CONVERSION:{
          _Base_ApplyDown(node);
          break;
        }

      }
    }
  }


  void _LinearConvert(Node node) { //da basso a alto
    if (node.convertedNode) {    //se un nodo foglia è già stato convertito
      value = node.value == null //faccio in calcoli del nodo padre rispetto a lui
          ? null
          : (node.isMultiplication ? node.value * node.coefficientPer : node.value / node.coefficientPer) +
          (node.isSum ? node.coefficientPlus : -node.coefficientPlus); //metto in questo nodo il valore convertito
      convertedNode = true;
      _ApplyDown(); //converto i nodi sottostanti
    }
    else if (node.leafNodes != null) { //Però ha almeno un nodo foglia
        node.Convert(); //ripeti la procedura    
        if(node.convertedNode)
          Convert();                             
    }
  }

  void _Linear_ApplyDown(Node node){//da alto a a basso
    node.value= value==null
      ? null
      : (node.isSum ? value-node.coefficientPlus : value+node.coefficientPlus)*(node.isMultiplication ? 1/node.coefficientPer : node.coefficientPer);//attenzione qui funziona al contrario
    node.convertedNode=true;

    if(node.leafNodes != null)                                                //se ha almeno un nodo foglia allora continuo
      node._ApplyDown();
  }

  void _ReciprocoConvert(Node node) { //da basso a alto
    if (node.convertedNode) {    //se un nodo foglia è già stato convertito
      value = node.value == null //faccio in calcoli del nodo padre rispetto a lui
          ? null
          : (node.coefficientPer/node.value)+node.coefficientPlus; //metto in questo nodo il valore convertito
      convertedNode = true;
      _ApplyDown(); //converto i nodi sottostanti
    }
    else if (node.leafNodes != null) { //Però ha almeno un nodo foglia
        node.Convert(); //ripeti la procedura    
        if(node.convertedNode)
          Convert();                             
    }
  }

  void _Reciproco_ApplyDown(Node node){//da alto a a basso
    node.value= value==null
      ? null
      : node.coefficientPer/(value-node.coefficientPlus);//attenzione qui funziona al contrario
    node.convertedNode=true;

    if(node.leafNodes != null)                                                //se ha almeno un nodo foglia allora continuo
      node._ApplyDown();
  }

  //attenzione! Questo tipo di conversione è stata costruita esclusivamente sulla struttura dec-(bin-oct-hex). Un padre con 3 figli
  void _BaseConvert(Node node) { //da basso a alto
    if (node.convertedNode) {    //se un nodo foglia è già stato convertito
      if((node.valueInt==null && node.keyboardType==KEYBOARD_NUMBER_INTEGER) || (node.valueString==null && node.keyboardType==KEYBOARD_COMPLETE))
        valueInt=null;
      else{
        if(node.keyboardType==KEYBOARD_NUMBER_INTEGER)
          valueInt=int.parse(baseToDec(node.valueInt.toString(), node.base));
        else if(node.keyboardType==KEYBOARD_COMPLETE)
          valueInt=int.parse(baseToDec(node.valueString, node.base));
      }
      convertedNode = true;
      _ApplyDown(); //converto i nodi sottostanti
    }
    else if (node.leafNodes != null) { //Però ha almeno un nodo foglia
        node.Convert(); //ripeti la procedura    
        if(node.convertedNode)
          Convert();                             
    }
  }

  void _Base_ApplyDown(Node node){//da alto a a basso
    if(valueInt==null){
      if(node.keyboardType==KEYBOARD_NUMBER_INTEGER)
        node.valueInt=null;
      else if(node.keyboardType==KEYBOARD_COMPLETE)
        node.valueString=null;
    }
    else{
      if(node.keyboardType==KEYBOARD_NUMBER_INTEGER)
        node.valueInt=int.parse(decToBase(valueInt.toString(), node.base));
      else if(node.keyboardType==KEYBOARD_COMPLETE)
        node.valueString=decToBase(valueInt.toString(), node.base);
    }

    node.convertedNode=true;

    if(node.leafNodes != null)                                                //se ha almeno un nodo foglia allora continuo
      node._ApplyDown();
  }


  /**
   * Resetta convertedNode su false per i nodi non selezionati dall'alto al basso (bisogna quindi chiamarlo dal nodo padre)
   */
  void ResetConvertedNode(){
    if(!selectedNode)                                                           //se non è il nodo selezionato
      convertedNode=false;                                                      //resetto il fatto che il nodo sia già stato convertito
    if(leafNodes!=null) {
      for (Node node in leafNodes) { //per ogni nodo dell'albero
        node.ResetConvertedNode();
      }
    }
  }

  /**
   * Resetta tutti i valori dei nodi (da chiamare sul nodo padre)
   */
  void ClearAllValues(){
    List<Node> listanodi=_getNodiFiglio();
    for(Node nodo in listanodi){
      nodo.value=null;
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

  void ReorderNodes(List<int> listaOrdine){
    List<Node> listaNodi=getOrderedNodiFiglio();
    for(int i=0; i<listaNodi.length;i++)
      listaNodi[i].order=listaOrdine[i];
  }

  String MantissaCorrection(){
    String stringValue=value.toString();

    //stacco la parte esponenziale e la attacco alla fine
    String append="";
    if(stringValue.contains("e")) {
      append = "e" + stringValue.split("e")[1];
      stringValue=stringValue.split("e")[0];
    }

    //risoluzione problema 0.99999999999 -> 1.0
    if(stringValue.contains("999999")){
      if(stringValue.indexOf("999999")>(stringValue.indexOf(".") ==-1 ? stringValue.indexOf("999999")+1 : stringValue.indexOf("."))){ // se il numero cercato è dopo la virgola
        int index=stringValue.split(".")[1].indexOf("999999"); //es:    1.999999 index=1;
        value=value+pow(10,-index-6);                          //10^-6 =0.000001 che sommato a value dà 2 (6 perchè 999999 ha 6 cifre)
        stringValue=value.toString();
      }
    }

    //eliminazione problema 1.00000000000000003 --> 1.0
    if(stringValue.contains(".")){
      List<String> parteIntDec=stringValue.split(".");
      if(parteIntDec[1].contains("000000")){
        parteIntDec[1]=parteIntDec[1].split("000000")[0];
        stringValue=parteIntDec[0]+"."+parteIntDec[1];
      }
    }
    

    //riduzione a 9 cifre significative dopo la virgola
    bool nonZero=false;
    bool virgola=false;
    int i;
    for(i=0;i<stringValue.length && !nonZero;i++){    //cerco l'indice del primo carattere non nullo dopo la virgola
      String char =stringValue.substring(i,i+1);      //estraggo ogni carattere
      if(char==".")                                   //se è passata la virgola
        virgola=true;                                 //metto il flag che è già stata passata
      else if(virgola && char!="0")                   //se la virgola è passata e il primo carattere  è diverso da "0"
        nonZero=true;
    }
    if(i+9<stringValue.length) {
      stringValue = stringValue.substring(0,i+9);
    }

    //correzione finali con .
    if(stringValue.endsWith("."))
      stringValue=stringValue+"0";
    return stringValue+append; //aggiungo la parte esponenziale se c'è

  }

}

class Calculator extends StatefulWidget{

  Calculator(this.color, this.width);
  Color color;
  double width;
  @override
  _Calculator createState() => new _Calculator();
}

class _Calculator extends State<Calculator>{
  String text="";
  static const double buttonHeight=70.0;
  static const double buttonOpSize=buttonHeight*0.8;
  static Color textButtonColor=Color(darkTheme ? 0xFFBBBBBB : 0xFF777777);
  static const double textSize=35.0;  

  bool alreadyDeleted=false;
  bool isResult=false;
  double firstNumber,secondNumber;
  int operation=0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5*buttonHeight,
      decoration: BoxDecoration(
                  color: darkTheme ? Color(0xFF2e2e2e) : Colors.white
                  ),
      child: Column(
        children: <Widget>[
        Container( 
          height: buttonHeight,
          alignment: Alignment(0, 0),
          child: Container(
            width: (widget.width*0.9),
            child:Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: (widget.width*0.9*3)/4,
                child:Text(text,style: TextStyle(fontSize: 45.0,fontWeight: FontWeight.bold,color: darkTheme ? Colors.white : Colors.black),maxLines: 1,),
              ),
              Container(
                width: (widget.width*0.9)/4,
                alignment: Alignment.center,
                child:isResult ? IconButton(icon: Icon(Icons.content_copy,color: darkTheme ? Colors.white54 : Colors.black54,), onPressed: (){
                  Clipboard.setData(new ClipboardData(text: text));
                },) : Text(operation ==1 ? "+" : operation==2 ? "−" : operation==3? "×" : operation==4? "÷" : "",style: TextStyle(fontSize: 45.0,fontWeight: FontWeight.bold,color: darkTheme? Colors.white54 : Colors.black54),maxLines: 1,),
              ),
            ],),
          ),
          decoration: new BoxDecoration(
            color: darkTheme ? Color(0xFF2e2e2e) : Colors.white,
            boxShadow: [new BoxShadow(
              color: Colors.black,
              blurRadius: 5.0,
            ),]
        ),
        ),
        //Divider(color: Colors.black,),
        Container(
          color: Colors.black.withAlpha(15),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Column(
            children: <Widget>[
            Row(
            children: <Widget>[
              _button("7", (){addChar("7");},buttonHeight,textButtonColor),
              _button("8", (){addChar("8");},buttonHeight,textButtonColor),
              _button("9", (){addChar("9");},buttonHeight,textButtonColor),
            ],),
            Row(
              children: <Widget>[
                _button("4", (){addChar("4");},buttonHeight,textButtonColor),
                _button("5", (){addChar("5");},buttonHeight,textButtonColor),
                _button("6", (){addChar("6");},buttonHeight,textButtonColor),
            ],),
            Row(
              children: <Widget>[
                _button("1", (){addChar("1");},buttonHeight,textButtonColor),
                _button("2", (){addChar("2");},buttonHeight,textButtonColor),
                _button("3", (){addChar("3");},buttonHeight,textButtonColor),
            ],),
            Row(
              children: <Widget>[
                _button(".", (){addChar(".");},buttonHeight,textButtonColor),
                _button("0", (){addChar("0");},buttonHeight,textButtonColor),
                _button("=", (){computeCalculus();},buttonHeight,textButtonColor),
              ]
            )
          ],),
          Container(                //divider
            width: 1.0,
            height: buttonHeight*3.9,
            color:Color(0xFFBBBBBB),
          ),
          Column(children: <Widget>[
            _button(isResult ? "CE" : "←", (){
              if(isResult){
                operation=0;
                firstNumber=secondNumber=null;
                setState((){
                  text="";
                });
              }
              isResult=false;
              deleteLastChar();
            },buttonOpSize,widget.color),
            _button("÷", (){setOperation(4);},buttonOpSize,widget.color),
            _button("×", (){setOperation(3);},buttonOpSize,widget.color),
            _button("−", (){setOperation(2);},buttonOpSize,widget.color),
            _button("+", (){setOperation(1);},buttonOpSize,widget.color),
            ],)   
      ],),),
        
    ],),
        
      

    );
  }

  void addChar(String char){
    //Se il risultato è stato scritto e premo su un numero azzero tutto
    if(isResult){
      isResult=false;
      operation=0;
      firstNumber=null;
      secondNumber=null;
      text="";
    }
    //Se premo un tasto dopo aver premuto su un operazione devo cancellare
    if(!alreadyDeleted && firstNumber!=null && text.length>0){
      text="";
      alreadyDeleted=true;
    }
    //Se premo un tasto devo aggiornare il testo dei numeri visualizzati
    if(char != "." || (char=="." && !text.contains(".") && text.length>0)){
      setState((){
        text+=char;
      });
    }
  }
  void deleteLastChar(){
    if(text.length>0){
      setState((){
        text=text.substring(0,text.length-1);
      });
    }
  }

  void setOperation(int op){
    setState((){
      operation=op;
      firstNumber=double.parse(text);
    });
  }
  void computeCalculus(){
    secondNumber=double.parse(text);
    double result;
    if(firstNumber==null || secondNumber==null || operation==0 || (operation==4 && secondNumber==0))
      result=null;
    else{
      switch(operation){
        case 1:
        result=firstNumber+secondNumber;
        break;
        case 2:
        result=firstNumber-secondNumber;
        break;
        case 3:
        result=firstNumber*secondNumber;
        break;
        case 4:
        result=firstNumber/secondNumber;
        break;
        
      }
    }
    if(result!=null){
      String stringResult=result.toString();
      if(stringResult.endsWith(".0"))
        stringResult=stringResult.substring(0,stringResult.length-2);
      setState((){
        text=stringResult;
      });
    }
    alreadyDeleted=false;
    isResult=true;
  }


  Widget _button (String number, Function() f, double size, Color color){ // Creating a method of return type Widget with number and function f as a parameter
    return ButtonTheme(
      minWidth: ((widget.width*0.9)/4),
      height: size,
      child:RaisedButton(
        child: number=="←" ? Icon(Icons.backspace,color: color,) : Text(number,
          style:  TextStyle(fontSize: textSize)),
          textColor: color,
          color: Colors.transparent,
          elevation: 0.0,
          onPressed: f,
      )      
    );
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

class CurrencyJSONObject{
  String base;
  var rates={"AUD":1.5794,"CHF":1.1206,"NZD":1.6551,"ILS":4.0513,"RUB":73.36,"PHP":58.608,"CAD":1.4964,"USD":1.1243,"THB":35.697,"SGD":1.5209,"JPY":125.3,"TRY":6.3014,"HKD":8.8246,"MYR":4.59,"NOK":9.6218,"SEK":10.43,"IDR":15939.2,"DKK":7.4643,"CZK":25.724,"HUF":320.05,"GBP":0.8539,"MXN":21.5195,"KRW":1275.35,"ZAR":15.912,"BRL":4.313,"PLN":4.293,"INR":76.9305,"RON":4.7555,"CNY":7.5423}; //base euro (aggiornato a 04/04/2019)

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
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

bool getBoolWithProbability(int probability){
  Random random = new Random();
  int num=random.nextInt(100);//numero da 0 a 99
  return num<probability;
}