import 'package:converterpro/utils/Localization.dart';
import 'package:flutter/material.dart';
import 'package:converterpro/utils/Utils.dart';

const int ANIMATION_DURATION = 3000; //milliseconds
const int ANIMATIONS_OVERLAY = 10;  //percentage (0-100)
int currentSelection = 0;
List<int> positions = [0, 1];
int ciao = 2;
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
    firstCard[0] = myListTile(
      key: ValueKey(0),
      selected: currentSelection == 0,
      selectedLeading: Image.asset("resources/images/x.png",
          width: 40,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFFCCCCCC)
              : Colors.black54),
      unselectedLeading: Icon(Icons.expand_more,
          size: 40,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFFCCCCCC)
              : Colors.black54),
      title: TextFormField(
        controller: TEC1,
        enabled: currentSelection != 0,
        decoration: InputDecoration(labelText: "Data size"),
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        onChanged: (String text) {
          if (text != "" && TEC2.text != "") {
            setState(() {
              TEC3.text =
                  (double.parse(text) / double.parse(TEC2.text)).toString();
            });
          }
        },
      ),
      trailing: Container(
        width: 70,
        alignment: Alignment.centerRight,
        child: DropdownButton<String>(
          value: dataSize,
          underline: SizedBox(),
          items: <String>['GB', 'MB', 'kB', 'B'].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (String val) {
            setState(() {
              dataSize = val;
            });
          },
        ),
      ),
      onTap: () {
        setState(() {
          currentSelection = 0;
        });
      },
    );

    firstCard[1] = myListTile(
      key: ValueKey(1),
      selected: currentSelection == 1,
      selectedLeading: Image.asset("resources/images/x.png",
          width: 40,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFFCCCCCC)
              : Colors.black54),
      unselectedLeading: Icon(Icons.expand_more,
          size: 40,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFFCCCCCC)
              : Colors.black54),
      title: TextFormField(
        controller: TEC2,
        enabled: currentSelection != 1,
        decoration: InputDecoration(labelText: "Transmission speed"),
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        onChanged: (String text) {
          if (text != "" && TEC1.text != "") {
            setState(() {
              TEC3.text =
                  (double.parse(TEC1.text) / double.parse(text)).toString();
            });
          }
        },
      ),
      trailing: Container(
        width: 70,
        alignment: Alignment.centerRight,
        child: DropdownButton<String>(
          value: dataSpeed,
          underline: SizedBox(),
          items: <String>['GB/s', 'MB/s', 'kB/s', 'B/s'].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (String val) {
            setState(() {
              dataSpeed = val;
            });
          },
        ),
      ),
      onTap: () {
        setState(() {
          currentSelection = 1;
        });
      },
    );

    firstCard[2] = myListTile(
      key: ValueKey(2),
      selected: currentSelection == 2,
      selectedLeading: Image.asset("resources/images/x.png",
          width: 40,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFFCCCCCC)
              : Colors.black54),
      unselectedLeading: Icon(Icons.expand_more,
          size: 40,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFFCCCCCC)
              : Colors.black54),
      title: TextFormField(
        controller: TEC3,
        enabled: currentSelection != 2,
        decoration: InputDecoration(labelText: "Data transfer duration"),
        keyboardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
      ),
      trailing: Container(
        width: 70,
        alignment: Alignment.centerRight,
        child: DropdownButton<String>(
          value: dataDuration,
          underline: SizedBox(),
          items: <String>['s', 'min', 'h', 'd'].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (String val) {
            setState(() {
              dataDuration = val;
            });
          },
        ),
      ),
      onTap: () {
        setState(() {
          currentSelection = 2;
        });
      },
    );

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
                        TEC1.text = TEC2.text = TEC3.text = "";
                      });
                    },
                  ),
                  IconButton(
                    tooltip: MyLocalizations.of(context).trans('cerca'),
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
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
                    child: getfirstTwoTiles(firstCard, currentSelection)[0],
                    duration: Duration(
                      milliseconds: ANIMATION_DURATION,
                    ),
                    switchInCurve: Curves.linear,
                    switchOutCurve: Curves.linear,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final outAnimation = Tween<Offset>(
                              begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                          .animate(animation);
                      final inAnimation = Tween<Offset>(
                              begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                          .animate(animation);

                      if (child.key == ValueKey(positions[0])) {
                        return ClipRect(
                          child: SlideTransition(
                            position: inAnimation,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: child,
                            ),
                          ),
                        );
                      } else {
                        return ClipRect(
                          child: SlideTransition(
                            position: outAnimation,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: child,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  AnimatedSwitcher(
                    child: getfirstTwoTiles(firstCard, currentSelection)[1],
                    duration: Duration(
                      milliseconds: ANIMATION_DURATION,
                    ),
                    switchInCurve: Curves.linear,
                    switchOutCurve: Curves.linear,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      final outAnimation = Tween<Offset>(
                              begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                          .animate(animation);
                      final inAnimation = Tween<Offset>(
                              begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                          .animate(animation);

                      if (child.key == ValueKey(positions[1])) {
                        return ClipRect(
                          child: SlideTransition(
                            position: inAnimation,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: child,
                            ),
                          ),
                        );
                      } else {
                        return ClipRect(
                          child: SlideTransition(
                            position: outAnimation,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: child,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Container(
                    height: 70.0,
                    child: AnimatedSwitcher(
                      child: firstCard[currentSelection],
                      duration: Duration(
                        milliseconds: (ANIMATION_DURATION*200 / (ANIMATIONS_OVERLAY+100)).round(),
                      ),
                      switchInCurve: Interval((100-ANIMATIONS_OVERLAY)/200, 1,
                          curve: Curves.linear), //Curves.elasticIn,
                      switchOutCurve: Interval(0, (ANIMATIONS_OVERLAY+100)/200,
                          curve: Curves.linear), //Curves.elasticOut,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final outAnimation = Tween<Offset>(
                                begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                            .animate(animation);
                        final inAnimation = Tween<Offset>(
                                begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                            .animate(animation);

                        if (child.key == ValueKey(currentSelection)) {
                          return ClipRect(
                            child: SlideTransition(
                              position: inAnimation,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: child,
                              ),
                            ),
                          );
                        } else {
                          return ClipRect(
                            child: SlideTransition(
                              position: outAnimation,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: child,
                              ),
                            ),
                          );
                        }
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

List getfirstTwoTiles(List tiles, selectedTile) {
  List returnTiles = new List();
  int position = 0;
  for (int i = 0; i < tiles.length; i++) {
    if (i != selectedTile) {
      returnTiles.add(tiles[i]);
      positions[position] = i;
      position++;
    }
  }
  return returnTiles;
}

class myListTile extends StatelessWidget {
  final Key key;
  final Function onTap;
  final Widget title;
  final Widget selectedLeading;
  final Widget unselectedLeading;
  final Widget trailing;
  final bool selected;

  myListTile(
      {this.key,
      this.onTap,
      this.title,
      this.unselectedLeading,
      this.selectedLeading,
      this.selected,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, highlightColor: Colors.transparent),
      child: ListTile(
        key: key,
        leading: selected ? selectedLeading : unselectedLeading,
        trailing: trailing,
        title: title,
        onTap: onTap,
      ),
    );
  }
}
