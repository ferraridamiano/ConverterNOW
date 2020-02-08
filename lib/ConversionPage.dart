import 'package:converternow/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'UtilsConversion.dart';
import 'helpers/responsive_helper.dart';

class ConversionPage extends StatefulWidget {

  final Node fatherNode;
  final String title;
  final String subtitle;
  MediaQueryData mediaQuery;
  ConversionPage(this.fatherNode, this.title, this.subtitle, this.mediaQuery);

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

    for(int i=0; i<100; i++){
      listaFocus.add(FocusNode());
    }
    
    initialize();
    super.initState();
  }

  void initialize(){
    widget.fatherNode.clearSelectedNode();
    
    listaController.clear();
    //listaFocus.clear();
    listaNodi=widget.fatherNode.getOrderedNodiFiglio();
    for(int i=0; i<100; i++){ //(Node node in listaNodi) {
      listaController.add(new TextEditingController());
      listaFocus[i].addListener(() {
        if (listaFocus[i].hasFocus) {
          if (selectedNode != null) {
            selectedNode.selectedNode = false;
          }
          listaNodi[i].selectedNode = true;
          listaNodi[i].convertedNode = true;
          selectedNode = listaNodi[i];
        }
      });
      listaFocus.add(listaFocus[i]);
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

      if ((listaNodi[i].value != null || listaNodi[i].valueString!=null) && !listaNodi[i].selectedNode){
        if(listaNodi[i].keyboardType==KEYBOARD_NUMBER_DECIMAL)
          listaController[i].text = listaNodi[i].mantissaCorrection();
        else if (listaNodi[i].keyboardType==KEYBOARD_COMPLETE || listaNodi[i].keyboardType==KEYBOARD_NUMBER_INTEGER)
          listaController[i].text = listaNodi[i].valueString;
      }
      else if(!listaNodi[i].selectedNode && 
      ((listaNodi[i].keyboardType==KEYBOARD_NUMBER_DECIMAL && listaNodi[i].value == null) || 
       ((listaNodi[i].keyboardType==KEYBOARD_COMPLETE || listaNodi[i].keyboardType==KEYBOARD_NUMBER_INTEGER) && listaNodi[i].valueString == null))){
         listaController[i].text="";
       }

      TextInputType keyboardType;
      switch(listaNodi[i].keyboardType){
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
          node: listaNodi[i],
          textField: TextFormField(
            style: TextStyle(
              fontSize: 16.0,
              color: MediaQuery.of(context).platformBrightness==Brightness.dark ? Colors.white : Colors.black,
            ),
            keyboardType: keyboardType,
            controller: listaController[i],
            focusNode: listaFocus[i],
            decoration: InputDecoration(labelText: listaNodi[i].name),
            onChanged: (String txt) {
              if(listaNodi[i].keyboardType==KEYBOARD_NUMBER_DECIMAL){
                listaNodi[i].value = txt == "" ? null : double.parse(txt);
              }
              else if(listaNodi[i].keyboardType==KEYBOARD_NUMBER_INTEGER || listaNodi[i].keyboardType==KEYBOARD_COMPLETE){
                listaNodi[i].valueString = txt == "" ? null : txt;
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

  Widget _buildConversionGrid(MediaQueryData mediaQuery) {
    
    List itemList=createList();
    //List<GridTile> tiles = [];
    
    List gridTiles = new List();
    for(ListItem item in itemList){
      if (item is MyCard) {
        gridTiles.add(UnitCard(node: item.node, textField: item.textField,));
      }
      else if(item is BigHeader) { //(item is BigHeader)
        gridTiles.add(BigTitle(text: item.title, subtitle: item.subTitle,));
      }
    }

    return Padding(
      padding: responsivePadding(mediaQuery),
      child: GridView.count(
        crossAxisCount: responsiveNumGridTiles(mediaQuery),
        mainAxisSpacing: 30.0,
        crossAxisSpacing: 30.0,
        shrinkWrap: true,
        //physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    List itemList=createList();
    List<Widget> gridTiles = new List();

    for(ListItem item in itemList){
      if (item is MyCard) {
        gridTiles.add(UnitCard(node: item.node, textField: item.textField,));
      }
      else if(item is BigHeader) { //(item is BigHeader)
        gridTiles.add(BigTitle(text: item.title, subtitle: item.subTitle,));
      }
    }
    return Scrollbar(
      child: Padding(
        padding: responsivePadding(widget.mediaQuery),
        child: GridView.count(
          childAspectRatio: responsiveChildAspectRatio(widget.mediaQuery),
          crossAxisCount: responsiveNumGridTiles(widget.mediaQuery),
          shrinkWrap: true,
          crossAxisSpacing: 15.0,
          children: gridTiles,
        ),
      ),
    );

  }
}
