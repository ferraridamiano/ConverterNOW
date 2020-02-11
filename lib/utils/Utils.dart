import 'package:converterpro/managers/ConversionManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'UtilsConversion.dart';

abstract class ListItem {}

class MyCard implements ListItem{
  MyCard({this.node, this.textField});

  Node node;
  final Widget textField;
}

class BigHeader implements ListItem{
  BigHeader({this.title, this.subTitle});
  String title;
  String subTitle;
}

class BigTitle extends StatelessWidget{

  BigTitle({this.text, this.subtitle});
  final String text;
  final String subtitle;

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
              child: Text(text,style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold,color: MediaQuery.of(context).platformBrightness==Brightness.dark ? Color(0xFFDDDDDD) : Color(0xFF666666)),),
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

  final Node node;
  final Widget textField;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
            padding: EdgeInsets.only(top: 14.0),
            child: new Card(
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: new Center(
                    child:this.textField
                  )),
              elevation: 4.0,
            )),
            node.symbol==null?SizedBox() : Align(
              alignment: Alignment(0.95, -0.9),
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(node.symbol, style: TextStyle(color: Colors.white, fontSize: 13.0,fontWeight: FontWeight.bold),),
                ),
                color: Theme.of(context).accentColor,
              ),
            )
      ],
    );
  }
}

class Calculator extends StatefulWidget{

  Calculator(this.color, this.width);
  final Color color;
  final double width;
  @override
  _Calculator createState() => new _Calculator();
}

class _Calculator extends State<Calculator>{
  String text="";
  static const double buttonHeight=70.0;
  static const double buttonOpSize=buttonHeight*0.8;
  static const double textSize=35.0;
  
  double result=0;
  bool alreadyDeleted=false;
  bool isResult=false;
  double firstNumber,secondNumber;
  int operation=0;
  @override
  Widget build(BuildContext context) {
    Color textButtonColor=Color(MediaQuery.of(context).platformBrightness==Brightness.dark ? 0xFFBBBBBB : 0xFF777777);
    return Container(
      height: 5*buttonHeight,
      decoration: BoxDecoration(
                  color: MediaQuery.of(context).platformBrightness==Brightness.dark ? Color(0xFF2e2e2e) : Colors.white
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
                child:Text(text,style: TextStyle(fontSize: 45.0,fontWeight: FontWeight.bold,color: MediaQuery.of(context).platformBrightness==Brightness.dark ? Colors.white : Colors.black),maxLines: 1,),
              ),
              Container(
                width: (widget.width*0.9)/4,
                alignment: Alignment.center,
                child:isResult ? IconButton(icon: Icon(Icons.content_copy,color: MediaQuery.of(context).platformBrightness==Brightness.dark ? Colors.white54 : Colors.black54,), onPressed: (){
                  Clipboard.setData(new ClipboardData(text: text));
                },) : Text(operation ==1 ? "+" : operation==2 ? "−" : operation==3? "×" : operation==4? "÷" : "",style: TextStyle(fontSize: 45.0,fontWeight: FontWeight.bold,color: MediaQuery.of(context).platformBrightness==Brightness.dark? Colors.white54 : Colors.black54),maxLines: 1,),
              ),
            ],),
          ),
          decoration: new BoxDecoration(
            color: MediaQuery.of(context).platformBrightness==Brightness.dark ? Color(0xFF2e2e2e) : Colors.white,
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

    isResult=false;
    
    //Se premo un tasto dopo aver premuto su un operazione devo cancellare
    if(!alreadyDeleted && firstNumber!=null && text.length>0){
      alreadyDeleted=true;
      setState(() {
        text="";
      });
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

    //Se voglio usare il risulato concatenandolo a una nuova operazione
    isResult=false;
    firstNumber=double.parse(text);
    secondNumber=null;
    alreadyDeleted=false;

    setState((){
      operation=op;
    });
  }
  void computeCalculus(){
    secondNumber=double.parse(text);
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
    operation=0;
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

class SearchUnit{
  String iconAsset;
  String unitName;
  Function onTap;
  SearchUnit({this.iconAsset,this.unitName, this.onTap});
}

class SearchUnitTile extends StatelessWidget{

  final SearchUnit searchUnit;
  final bool darkMode;
  SearchUnitTile(this.searchUnit, this.darkMode);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        "resources/images/${searchUnit.iconAsset}.png",
        height: 26.0,
        color: darkMode ? Colors.white : Colors.grey),
      title: Text(searchUnit.unitName),
      onTap: searchUnit.onTap,
    );
  }

}

class SuggestionList extends StatelessWidget {

  final List<SearchUnit> suggestions;
  final bool darkMode;
  const SuggestionList({this.suggestions, this.darkMode});
  

  @override
  Widget build(BuildContext context) {

    return ListView(
      children: <Widget>[
        for(int i=0;i<suggestions.length;i++)
          SearchUnitTile(suggestions[i], darkMode)
      ],

    );
  }
}

class SearchGridTile extends StatelessWidget {

  final String iconAsset;
  final String footer;
  final onTap;
  final bool darkMode;
  SearchGridTile({this.iconAsset, this.footer, this.onTap, this.darkMode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:Container(
        padding: EdgeInsets.all(5.0),
        child: Center(
          child: GridTile(
            footer: Text(footer, textAlign: TextAlign.center,style: TextStyle(fontSize: 18.0),),
            child: Align(
              alignment:Alignment.center,
              child: Container(
                width:55.0,
                height:55.0,
                child: Image.asset(
                  "resources/images/$iconAsset.png",
                  color: darkMode ? Colors.white : Colors.grey
                )
              )
            )
          )
        )
      )
    );
  }
}

class ListTileConversion extends StatefulWidget{
  final String text;
  final String imagePath;
  final bool selected;
  final Function onTapFunction;
  ListTileConversion(this.text, this.imagePath, this.selected,this.onTapFunction);

  @override
  _ListTileConversion createState() => new _ListTileConversion();
} 

class _ListTileConversion extends State<ListTileConversion>{

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      child:ListTile(
        title: Row(children: <Widget>[
          Image.asset(widget.imagePath,width: 30.0,height: 30.0, color:  (widget.selected ? Theme.of(context).accentColor : (MediaQuery.of(context).platformBrightness==Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54))),
          SizedBox(width: 20.0,),
          Text(
            widget.text,
            style: TextStyle(
              color: widget.selected ? Theme.of(context).accentColor : (MediaQuery.of(context).platformBrightness==Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54),
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