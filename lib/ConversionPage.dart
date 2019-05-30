import 'package:converter_pro/Utils.dart';
import 'package:converter_pro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConversionPage extends StatefulWidget {

  Node fatherNode;
  String title;
  String subtitle;
  ConversionPage(this.fatherNode, this.title, this.subtitle);

  @override
  _ConversionPage createState() => new _ConversionPage();
}

class _ConversionPage extends State<ConversionPage> {
  List<TextEditingController> listaController = new List();
  List<FocusNode> listaFocus = new List();
  Node selectedNode;
  List listaNodi;

  @override
  void didUpdateWidget(ConversionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialize();
  }

@override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize(){
    listaController.clear();
    listaFocus.clear();
    listaNodi=widget.fatherNode.getOrderedNodiFiglio();
    for (Node node in listaNodi) {
      listaController.add(new TextEditingController());
      FocusNode focus = new FocusNode();
      focus.addListener(() {
        if (focus.hasFocus) {
          if (selectedNode != null) {
            selectedNode.selectedNode = false;
          }
          node.selectedNode = true;
          node.convertedNode = true;
          selectedNode = node;
        }
      });
      listaFocus.add(focus);
    }
  }

  @override
  void dispose() {
    FocusNode focus;
    TextEditingController TEC;
    for (int i = 0; i < listaFocus.length; i++) {
      focus = listaFocus[i];
      focus.removeListener(() {});
      focus.dispose();
      TEC = listaController[i];
      TEC.dispose();
    }
    super.dispose();
  }

  List<ListItem> createList() {
    List<ListItem> listaCard = new List();
    listaCard.add(bigHeader(title:widget.title, subTitle: widget.subtitle));
    for (int i = 0; i < listaNodi.length; i++) {
      Node nodo = listaNodi[i];
      TextEditingController controller;
      controller = listaController[i];



      if (nodo.value != null && !nodo.selectedNode){
        if(nodo.keyboardType==KEYBOARD_NUMBER_DECIMAL)
          controller.text = nodo.MantissaCorrection();
        else if (nodo.keyboardType==KEYBOARD_COMPLETE)
          controller.text = nodo.valueString;
        else if (nodo.keyboardType==KEYBOARD_NUMBER_INTEGER)
          controller.text = nodo.valueInt.toString();
      }
      else if (nodo.value == null && !nodo.selectedNode) controller.text = "";

      TextInputType keyboardType;
      switch(nodo.keyboardType){
        case KEYBOARD_NUMBER_DECIMAL:{
          keyboardType=TextInputType.numberWithOptions(decimal: true, signed: false);
          break;
        }
        case KEYBOARD_COMPLETE:{
          keyboardType=TextInputType.text;
          break;
        }
        case KEYBOARD_NUMBER_INTEGER:{
          keyboardType=TextInputType.numberWithOptions(decimal: false,signed: false);
          break;
        }
      }

      listaCard.add(myCard(
          node: nodo,
          textField: TextField(
            style: TextStyle(
              fontSize: 16.0,
              color: darkTheme ? Colors.white : Colors.black,
            ),
            keyboardType: keyboardType,
            controller: controller,
            focusNode: listaFocus[i],
            onChanged: (String txt) {
              switch(nodo.keyboardType){
                case KEYBOARD_NUMBER_DECIMAL:{
                  nodo.value = txt == "" ? null : double.parse(txt);
                  break;
                }
                case KEYBOARD_COMPLETE:{
                  nodo.valueString = txt == "" ? null : txt;
                  break;
                }
                case KEYBOARD_NUMBER_INTEGER:{
                  nodo.valueInt = txt == "" ? null : int.parse(txt);
                  break;
                }
              }
              setState(() {
                widget.fatherNode.ResetConvertedNode();
                widget.fatherNode.Convert();
              });
            },
          )));
    }
    return listaCard;
  }

  @override
  Widget build(BuildContext context) {
    List itemList=createList();
    return Scrollbar(
      child:ListView.builder(
        padding: new EdgeInsets.only(left: 10.0,right:10.0,bottom: 25.0),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          final item = itemList[index];

          if (item is bigHeader) {
            return bigTitle(item.title, item.subTitle);
          }
          else if (item is myCard) {
            return UnitCard(node: item.node,textField: item.textField,);
          }
        }
      )
    );
  }
}
