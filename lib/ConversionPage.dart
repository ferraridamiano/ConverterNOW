import 'package:converter_pro/Utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String app_id= "ca-app-pub-8125901756552853~1510088371";

class ConversionPage extends StatefulWidget {

  Node fatherNode;
  ConversionPage(this.fatherNode);

  @override
  _ConversionPage createState() => new _ConversionPage();
}

class _ConversionPage extends State<ConversionPage> {
  List<Node> listaNodi;
  List<TextEditingController> listaController = new List();
  List<FocusNode> listaFocus = new List();
  Node selectedNode;


  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: app_id != null ? <String>[app_id] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    birthday: DateTime.now(),
    childDirected: true,
    gender: MobileAdGender.male,
    nonPersonalizedAds: true,
  );

  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: "ca-app-pub-8125901756552853/6183830557",//BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }














  @override
  void didUpdateWidget(ConversionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialize();
  }

@override
  void initState() {
    super.initState();
    initialize();





    FirebaseAdMob.instance.initialize(appId:FirebaseAdMob.testAppId );
    _bannerAd = createBannerAd()..load();
    _bannerAd ??= createBannerAd();
    _bannerAd
      ..load()
      ..show();
  }

  void initialize(){
    listaNodi = widget.fatherNode.getNodiFiglio();
    listaController.clear();
    listaFocus.clear();
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






    _bannerAd?.dispose();
    super.dispose();
  }

  List<UnitCard> createList() {
    List<UnitCard> listaCard = new List();
    listaNodi = widget.fatherNode.getNodiFiglio();
    for (int i = 0; i < listaNodi.length; i++) {
      Node nodo = listaNodi[i];
      TextEditingController controller;
      controller = listaController[i];

      if (nodo.value != null && !nodo.selectedNode)
        controller.text = nodo.value.toString();
      else if (nodo.value == null && !nodo.selectedNode) controller.text = "";

      listaCard.add(new UnitCard(
          node: nodo,
          textField: TextField(
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            keyboardType:
                TextInputType.numberWithOptions(decimal: true, signed: false),
            controller: controller,
            focusNode: listaFocus[i],
            onChanged: (String txt) {
              nodo.value = txt == "" ? null : double.parse(txt);
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
    //List<UnitCard> listCard = _createList();

    return ListView(
        padding: new EdgeInsets.only(bottom: 50.0,top:10.0,left: 10.0,right: 10.0),
        children: createList(),//listCard
    );
  }
}
