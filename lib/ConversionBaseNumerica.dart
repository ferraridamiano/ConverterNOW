import 'package:converter_pro/Utils.dart';
import 'package:converter_pro/main.dart';
import 'package:flutter/material.dart';

class ConversionBaseNumerica extends StatefulWidget{
  
  String title;
  ConversionBaseNumerica(this.title);

  @override
  _ConversionBaseNumerica createState() => new _ConversionBaseNumerica();
}

class _ConversionBaseNumerica extends State<ConversionBaseNumerica>{

  List<BaseNumerica> listaBasi=new List();
  List<TextEditingController> listaController = new List();
  List<FocusNode> listaFocus = new List();
  BaseNumerica selectedBase;
  

  @override
  void didUpdateWidget(ConversionBaseNumerica oldWidget) {
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
    BaseNumerica fatherBase=BaseNumerica(base: 10,value: "", nome: "base 10");
    selectedBase=fatherBase;
    listaBasi.add(fatherBase);
    listaBasi.add(BaseNumerica(base: 2,value: "",currentBase: selectedBase, nome: "base 2"));
    listaBasi.add(BaseNumerica(base: 8, value: "",currentBase: selectedBase, nome: "base 8"));
    listaBasi.add(BaseNumerica(base: 16, value: "",currentBase: selectedBase, nome: "base 16"));

    listaFocus.clear();
    for (BaseNumerica base in listaBasi) {
      listaController.add(new TextEditingController());
      FocusNode focus = new FocusNode();
      focus.addListener(() {
        if (focus.hasFocus) {
          if (selectedBase != null) {
            selectedBase.selectedBase = false;
          }
          base.selectedBase = true;
          //node.convertedNode = true;
          selectedBase = base;
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
    listaCard.add(bigHeader(title:widget.title));
    for (int i = 0; i < listaBasi.length; i++) {
      BaseNumerica base = listaBasi[i];
      TextEditingController controller;
      controller = listaController[i];

      if (base.value == null && !base.selectedBase)
        controller.text = "";

      listaCard.add(myCard(
          textField: TextField(
            style: TextStyle(
              fontSize: 16.0,
              color: darkTheme ? Colors.white : Colors.black,
            ),
            keyboardType:
                base.base >10 ? TextInputType.text  : TextInputType.numberWithOptions(decimal: false, signed: false, ),
            controller: controller,
            focusNode: listaFocus[i],
            onChanged: (String txt) {
              base.value = txt;
              base.selectedBase=true;
              selectedBase=base;
              setState(() {
                for(BaseNumerica baseNum in listaBasi){
                  baseNum.Convert();                      //c'è gia controllo di non conversione su base selezionata
                }
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
        padding: new EdgeInsets.only(top: 10.0,left: 10.0,right:10.0,bottom: 25.0),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          final item = itemList[index];

          if (item is bigHeader) {
            return bigTitle(item.title, item.subTitle);
          }
          else if (item is myCard) {
            return UnitCard(title: "prova",textField: item.textField,);
          }
        }
      )
    );
  }
}

class BaseNumerica{
  int base;
  String nome;
  String value;
  bool selectedBase=false;
  BaseNumerica currentBase;     //sarebbe la base selezionata
  //BaseNumerica fatherBase=null; //null punta a se stesso

  BaseNumerica({this.base,this.value, this.currentBase, this.nome});

  Convert(){
    if(!selectedBase){
      String base10Value;
      if(currentBase.base!=10)
        base10Value=basetoDec(currentBase.value, currentBase.base);
      else
        base10Value=currentBase.value;

      value=decToBase(base10Value, base);
    }
  }
}