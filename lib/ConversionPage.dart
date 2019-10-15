import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'UtilsConversion.dart';

class ConversionPage extends StatefulWidget {

  final Node fatherNode;
  final String title;
  final String subtitle;
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
    initialize();
    super.didUpdateWidget(oldWidget);
  }

@override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize(){
    widget.fatherNode.clearSelectedNode();
    
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
    TextEditingController tec;
    for (int i = 0; i < listaFocus.length; i++) {
      focus = listaFocus[i];
      focus.removeListener(() {});
      focus.dispose();
      tec = listaController[i];
      tec.dispose();
    }
    super.dispose();
  }

  List<ListItem> createList() {
    List<ListItem> listaCard = new List();
    listaCard.add(BigHeader(title:widget.title, subTitle: widget.subtitle));
    for (int i = 0; i < listaNodi.length; i++) {
      Node nodo = listaNodi[i];
      TextEditingController controller;
      controller = listaController[i];

      if ((nodo.value != null || nodo.valueString!=null) && !nodo.selectedNode){
        if(nodo.keyboardType==KEYBOARD_NUMBER_DECIMAL)
          controller.text = nodo.mantissaCorrection();
        else if (nodo.keyboardType==KEYBOARD_COMPLETE || nodo.keyboardType==KEYBOARD_NUMBER_INTEGER)
          controller.text = nodo.valueString;
      }
      else if(!nodo.selectedNode && 
      ((nodo.keyboardType==KEYBOARD_NUMBER_DECIMAL && nodo.value == null) || 
       ((nodo.keyboardType==KEYBOARD_COMPLETE || nodo.keyboardType==KEYBOARD_NUMBER_INTEGER) && nodo.valueString == null))){
         controller.text="";
       }

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

      listaCard.add(MyCard(
          node: nodo,
          textField: TextFormField(
            style: TextStyle(
              fontSize: 16.0,
              color: MediaQuery.of(context).platformBrightness==Brightness.dark ? Colors.white : Colors.black,
            ),
            keyboardType: keyboardType,
            controller: controller,
            focusNode: listaFocus[i],
            decoration: InputDecoration(labelText: nodo.name),
            onChanged: (String txt) {
              if(nodo.keyboardType==KEYBOARD_NUMBER_DECIMAL){
                nodo.value = txt == "" ? null : double.parse(txt);
              }
              else if(nodo.keyboardType==KEYBOARD_NUMBER_INTEGER || nodo.keyboardType==KEYBOARD_COMPLETE){
                nodo.valueString = txt == "" ? null : txt;
              }

              setState(() {
                widget.fatherNode.resetConvertedNode();
                widget.fatherNode.convert();
              });
            },
          )          
      ));
    }
    return listaCard;
  }

  @override
  Widget build(BuildContext context) {
    List itemList=createList();
    return Scrollbar(
      child:ListView.builder(
        shrinkWrap: true,
        padding: new EdgeInsets.only(left: 10.0,right:10.0,bottom: 25.0),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          final item = itemList[index];
          if (item is MyCard) {
            return UnitCard(node: item.node,textField: item.textField,);
          }
          else  { //(item is BigHeader)
            return BigTitle(item.title, item.subTitle);
          }
        }
      )
    );
  }
}
