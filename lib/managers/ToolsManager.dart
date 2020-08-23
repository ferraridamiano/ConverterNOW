import 'package:converterpro/utils/Localization.dart';
import 'package:flutter/material.dart';
import 'package:converterpro/utils/Utils.dart';

const int ANIMATION_DURATION = 300; //milliseconds
const int ANIMATIONS_OVERLAY = 10; //percentage (0-100)
List<int> positions = [0, 1, 2];
String dataSize = "MB";
String dataSpeed = "MB/s";
String dataDuration = "s";
List<TextEditingController> tecList = [TextEditingController(), TextEditingController(), TextEditingController()];

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
    firstCard[0] = MyListTile(
      key: ValueKey(0),
      selected: positions[2] == 0,
      selectedLeading: Image.asset("resources/images/x.png",
          width: 40, color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54),
      unselectedLeading:
          Icon(Icons.expand_more, size: 40, color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54),
      title: TextFormField(
        controller: tecList[0],
        enabled: positions[2] != 0,
        decoration: InputDecoration(labelText: "Data size"),
        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
        onChanged: (String text) {
          if (tecList[positions[0]].text != "" && tecList[positions[1]].text != "") {
            setState(() {
              tecList[positions[2]].text = getResults(positions[2],
                      dataSize: double.tryParse(tecList[0].text),
                      transmissionSpeed: double.tryParse(tecList[1].text),
                      transferDuration: double.tryParse(tecList[2].text))
                  .toString();
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
        if (positions[2] != 0) {
          setState(() {
            swapTwoElementsList(positions, positions.indexWhere((element) => element == 0), 2);
          });
        }
      },
    );

    firstCard[1] = MyListTile(
      key: ValueKey(1),
      selected: positions[2] == 1,
      selectedLeading: Image.asset("resources/images/x.png",
          width: 40, color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54),
      unselectedLeading:
          Icon(Icons.expand_more, size: 40, color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54),
      title: TextFormField(
        controller: tecList[1],
        enabled: positions[2] != 1,
        decoration: InputDecoration(labelText: "Transmission speed"),
        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
        onChanged: (String text) {
          if (tecList[positions[0]].text != "" && tecList[positions[1]].text != "") {
            setState(() {
              tecList[positions[2]].text = getResults(positions[2],
                      dataSize: double.tryParse(tecList[0].text),
                      transmissionSpeed: double.tryParse(tecList[1].text),
                      transferDuration: double.tryParse(tecList[2].text))
                  .toString();
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
        if (positions[2] != 1) {
          setState(() {
            swapTwoElementsList(positions, positions.indexWhere((element) => element == 1), 2);
          });
        }
      },
    );

    firstCard[2] = MyListTile(
      key: ValueKey(2),
      selected: positions[2] == 2,
      selectedLeading: Image.asset("resources/images/x.png",
          width: 40, color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54),
      unselectedLeading:
          Icon(Icons.expand_more, size: 40, color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFFCCCCCC) : Colors.black54),
      title: TextFormField(
        controller: tecList[2],
        enabled: positions[2] != 2,
        decoration: InputDecoration(labelText: "Data transfer duration"),
        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
        onChanged: (String text) {
          if (tecList[positions[0]].text != "" && tecList[positions[1]].text != "") {
            setState(() {
              tecList[positions[2]].text = getResults(positions[2],
                      dataSize: double.tryParse(tecList[0].text),
                      transmissionSpeed: double.tryParse(tecList[1].text),
                      transferDuration: double.tryParse(tecList[2].text))
                  .toString();
            });
          }
        },
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
        if (positions[2] != 2) {
          setState(() {
            swapTwoElementsList(positions, positions.indexWhere((element) => element == 2), 2);
          });
        }
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
                        tecList[0].text = tecList[1].text = tecList[2].text = "";
                      });
                    },
                  ),
                  IconButton(
                    tooltip: MyLocalizations.of(context).trans('cerca'),
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {},
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
                  MyAnimatedSwitcher(
                    child: firstCard[positions[0]],
                    tilePosition: positions[0],
                    duration: ANIMATION_DURATION,
                    animationsOverlay: ANIMATIONS_OVERLAY,
                    selected: false,
                  ),
                  MyAnimatedSwitcher(
                    child: firstCard[positions[1]],
                    tilePosition: positions[1],
                    duration: ANIMATION_DURATION,
                    animationsOverlay: ANIMATIONS_OVERLAY,
                    selected: false,
                  ),
                  Divider(thickness: 1),
                  MyAnimatedSwitcher(
                    child: firstCard[positions[2]],
                    tilePosition: positions[2],
                    duration: ANIMATION_DURATION,
                    animationsOverlay: ANIMATIONS_OVERLAY,
                    selected: true,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

double getResults(int selection, {double transmissionSpeed, double transferDuration, double dataSize}) {
  switch (selection) {
    case 0:
      return (transmissionSpeed * transferDuration);
    case 1:
      return (dataSize / transferDuration);
    case 2:
      return (dataSize / transmissionSpeed);
  }
  return null;
}

class MyAnimatedSwitcher extends StatelessWidget {
  final int duration;
  final int animationsOverlay;
  final Widget child;
  final bool selected;
  final int tilePosition;

  MyAnimatedSwitcher({this.duration, this.animationsOverlay, this.child, this.selected, this.tilePosition});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: Duration(milliseconds: selected ? (duration * 200 / (animationsOverlay + 100)).round() : duration),
        switchInCurve: selected ? Interval((100 - ANIMATIONS_OVERLAY) / 200, 1, curve: Curves.linear) : Curves.linear,
        switchOutCurve: selected ? Interval(0, (ANIMATIONS_OVERLAY + 100) / 200, curve: Curves.linear) : Curves.linear,
        child: child,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final outAnimation = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(animation);
          final inAnimation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)).animate(animation);

          if (child.key == ValueKey(tilePosition)) {
            return ClipRect(
              child: SlideTransition(
                position: inAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: child,
                ),
              ),
            );
          }
          return ClipRect(
            child: SlideTransition(
              position: outAnimation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              ),
            ),
          );
        });
  }
}

class MyListTile extends StatelessWidget {
  final Key key;
  final Function onTap;
  final Widget title;
  final Widget selectedLeading;
  final Widget unselectedLeading;
  final Widget trailing;
  final bool selected;

  MyListTile({this.key, this.onTap, this.title, this.unselectedLeading, this.selectedLeading, this.selected, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
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
