import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';

class ConversionPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    Node foot=Node(isMultiplication: true, coefficient: 12.0, name: "foot", value: 10.0);
    Node inch=Node(isMultiplication: true, coefficient: 2.54, name: "inch", leafNodes: [foot]);
    Node millimetro=Node(isMultiplication: false, coefficient: 10.0, name: "millimetro");
    Node centimetro=Node(isMultiplication: false, coefficient: 100.0, name: "centimetro", leafNodes: [millimetro,inch]);
    Node metro=Node(name: "metro", leafNodes: [centimetro]);

    return Scaffold(
      appBar: AppBar(title: new Text("Lunghezza"),),
      body: ListView(
        padding: new EdgeInsets.all(10.0),
        children: <Widget>[
          UnitCard(
            title: new Text("Metro", style: TextStyle(fontSize: 16.0),),
            textField: new TextField(
              style: TextStyle(fontSize: 16.0,color: Colors.black,),
              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),),
          ),
          UnitCard(
            title: new Text("Chilometro", style: TextStyle(fontSize: 16.0),),
            textField: new TextField(
              style: TextStyle(fontSize: 16.0,color: Colors.black,),
              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),),
          ),
          UnitCard(
            title: new Text("Centimetri", style: TextStyle(fontSize: 16.0),),
            textField: new TextField(
              style: TextStyle(fontSize: 16.0,color: Colors.black,),
              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),),
          ),
          UnitCard(
            title: new Text("Millimetri", style: TextStyle(fontSize: 16.0),),
            textField: new TextField(
              style: TextStyle(fontSize: 16.0,color: Colors.black,),
              keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        metro.Convert();
        print(millimetro.value.toString());
      }),
    );
  }
}