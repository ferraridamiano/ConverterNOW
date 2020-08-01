import 'package:converterpro/utils/Localization.dart';
import 'package:flutter/material.dart';
import 'package:converterpro/utils/Utils.dart';

int groupValue = 0;
String dataSize = "MB";
String dataSpeed = "MB/s";
String dataDuration = "s";
TextEditingController TEC1 = TextEditingController();
TextEditingController TEC2 = TextEditingController();
TextEditingController TEC3 = TextEditingController();


class ToolsManager extends StatefulWidget {
  final Function openDrawer;

  ToolsManager(this.openDrawer);

  @override
  _ToolsManager createState() => _ToolsManager();
}

class _ToolsManager extends State<ToolsManager> {

  List<Widget> firstCard = new List(3);

  @override
  Widget build(BuildContext context) {

    firstCard[0]=(RadioListTile<int>(
                    key: ValueKey(0),
                    value: 0,
                    groupValue: groupValue,
                    title: TextFormField(
                      controller: TEC1,
                      enabled: groupValue != 0,
                      decoration: InputDecoration(labelText: "Data size"),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                      onChanged: (String text){
                        if(text!="" && TEC2.text!=""){
                          setState(() {
                            TEC3.text = (double.parse(text)/double.parse(TEC2.text)).toString();
                          });
                        }
                      },
                    ),
                    secondary: Container(
                      width: 70,
                      alignment: Alignment.centerRight,
                      child: DropdownButton<String>(
                        value: dataSize,
                        underline: SizedBox(),
                        items: <String>['GB','MB', 'kB', 'B'].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (String val){
                          setState(() {
                            dataSize = val;
                          });
                        },
                      ),
                    ),
                    onChanged: (int val) {
                      setState(() {
                        groupValue = val;
                      });
                    },
                  ));
    firstCard[1]=(RadioListTile<int>(
                    key: ValueKey(1),
                    value: 1,
                    groupValue: groupValue,
                    title: TextFormField(
                      controller: TEC2,
                      enabled: groupValue != 1,
                      decoration: InputDecoration(labelText: "Transmission speed"),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                      onChanged: (String text){
                        if(text!="" && TEC1.text!=""){
                          setState(() {
                            TEC3.text = (double.parse(TEC1.text)/double.parse(text)).toString();
                          });
                        }
                      },
                    ),
                    secondary: Container(
                      width: 70,
                      alignment: Alignment.centerRight,
                      child: DropdownButton<String>(
                        value: dataSpeed,
                        underline: SizedBox(),
                        items: <String>['GB/s','MB/s', 'kB/s', 'B/s'].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (String val){
                          setState(() {
                            dataSpeed = val;
                          });
                        },
                      ),
                    ),
                    onChanged: (int val) {
                      setState(() {
                        groupValue = val;
                      });
                    },
                  ));
    firstCard[2]=(RadioListTile<int>(
                    key: ValueKey(2),
                    value: 2,
                    groupValue: groupValue,
                    title: TextFormField(
                      controller: TEC3,
                      enabled: groupValue != 2,
                      decoration:InputDecoration(labelText: "Data transfer duration"),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                    ),
                    secondary: Container(
                      width: 70,
                      alignment: Alignment.centerRight,
                      child: DropdownButton<String>(
                        value: dataDuration,
                        underline: SizedBox(),
                        items: <String>['s','min', 'h', 'd'].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (String val){
                          setState(() {
                            dataDuration = val;
                          });
                        },
                      ),
                    ),
                    onChanged: (int val) {
                      setState(() {
                        groupValue = val;
                      });
                    },
                  ));

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Image.asset(
              "resources/images/calculator.png",
              width: 30.0,
            )),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Builder(builder: (context) {
                return IconButton(
                    tooltip: MyLocalizations.of(context).trans('menu'),
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      widget.openDrawer();
                    });
              }),
              Row(
                children: <Widget>[
                  IconButton(
                    tooltip: MyLocalizations.of(context).trans('elimina_tutto'),
                    icon: Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        TEC1.text=TEC2.text=TEC3.text="";
                      });
                    },
                  ),
                  IconButton(
                    tooltip: MyLocalizations.of(context).trans('cerca'),
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    /*onPressed: () async {
                  final int paginaReindirizzamento=await showSearch(context: context,delegate: _searchDelegate);
                  if(paginaReindirizzamento!=null)
                    _onSelectItem(paginaReindirizzamento);
                },*/
                  ),
                ],
              )
            ],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: [
            BigTitle(
              text: "Data transfer",
              subtitle: "",
            ),
            GenericCard(
              title: "Data size - Speed - Data transfer duration",
              body: Column(
                children: [
                  AnimatedSwitcher(
                      child: getfirstTwoTiles(firstCard, groupValue)[0],
                      duration: Duration(milliseconds: 600,),
                      transitionBuilder: (child, animation) {
                        final  offsetAnimation =
                          Tween<Offset>(begin: Offset(0.0, 1), end: Offset(0.0, 0.0)).animate(animation);
                        return ClipRect(
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  AnimatedSwitcher(
                      child: getfirstTwoTiles(firstCard, groupValue)[1],
                      duration: Duration(milliseconds: 600,),
                      transitionBuilder: (child, animation) {
                        final  offsetAnimation =
                          Tween<Offset>(begin: Offset(0.0, 1), end: Offset(0.0, 0.0)).animate(animation);
                        return ClipRect(
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  Divider(thickness: 1,),
                  Container(
                    height: 70.0,
                    child: AnimatedSwitcher(
                      child: firstCard[groupValue],
                      duration: Duration(milliseconds: 600,),
                      transitionBuilder: (child, animation) {
                        final  offsetAnimation =
                          Tween<Offset>(begin: Offset(0.0, -1), end: Offset(0.0, 0.0)).animate(animation);
                        return ClipRect(
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

List getfirstTwoTiles(List tiles, selectedTile){

  List returnTiles = new List();

  for(int i=0; i<tiles.length;i++){
    if (i!=selectedTile)
      returnTiles.add(tiles[i]);
  }
  return returnTiles;

}

Widget mySlideTransition(Widget child, Animation<double> animation) {
    final  offsetAnimation =
    Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, -1.0)).animate(animation);
    return SlideTransition(
        position: offsetAnimation,
        child: child,
    );
}

class myRadioListTile extends StatelessWidget {
  final Function onChanged;
  final int value;
  final int groupValue;
  final Widget title;

  myRadioListTile({this.onChanged, this.value, this.groupValue, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Radio(onChanged: onChanged, value: value, groupValue: groupValue),
      title
    ]);
  }
}
