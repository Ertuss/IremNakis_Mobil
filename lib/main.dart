import 'dart:async';
import 'dart:ui';
import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_firstapp/Data/DbHelper.dart';
import 'package:flutter_firstapp/Screens/model_ekle.dart';
import 'package:flutter_firstapp/Screens/paspas_guncelle.dart';

import 'Models/Arac.dart';
import 'Screens/paspas_detay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MyHomePage(
        title: "İrem Nakış Mobil Uygulama",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Widget> normalList = [];
List<String> strList = [];

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  List<Arac> dbAraclar = new List<Arac>();

  _MyHomePageState() {
    super.initState();
    //dbHelper.destroyDb();
    araclariGetir();
  }

  Arac seciliArac = null;
  var dbHelper = new DbHelper();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),
      ),
      body: BuildAracList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Route<bool> route =
          MaterialPageRoute(builder: (context) => ModelEkle());
          bool result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => ModelEkle()));
          if (result != null) {
            araclariGetir();
          }
        },
        tooltip: "Yeni ürün ekle",
        child: Icon(Icons.add),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ModelEkle(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 0.5);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return child;
      },
    );
  }

  Future<bool> _showMyDialog(int id, String marka, String model) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: CupertinoAlertDialog(
            title: Text(marka + " " + model),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Silinmesini onaylıyor musunuz?"),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Hayır'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              FlatButton(
                child: Text('Evet'),
                onPressed: () async {
                  int result = await dbHelper.silArac(id);
                  if (result == 1) {
                    print("Silindi : " +
                        marka +
                        " " +
                        model +
                        " sonuc : " +
                        result.toString());
                  }
                  araclariGetir();
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String InfoVer(Arac seciliArac) {
    if (seciliArac != null) {
      return "Seçili Paspas : " +
          seciliArac.Marka +
          " " +
          seciliArac.Model +
          "\n";
    } else {
      return "";
    }
  }

  BuildAracList() {
    return Container(
      child: AlphabetListScrollView(
        strList: strList,
        highlightTextStyle: TextStyle(
          color: Colors.orange,
        ),
        showPreview: true,
        itemBuilder: (context, index) {
          return normalList[index];
        },
        indexedHeight: (i) {
          return 80;
        },
        keyboardUsage: true,
        headerWidgetList: <AlphabetScrollListHeader>[
          AlphabetScrollListHeader(widgetList: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffix: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  labelText: "Search",
                ),
              ),
            )
          ], icon: Icon(Icons.search), indexedHeaderHeight: (index) => 80),
          /*AlphabetScrollListHeader(
            widgetList: normalList,       FAVORİ MUHABBETİ İÇİN AÇILABİLİR.
            icon: Icon(Icons.star),
            indexedHeaderHeight: (index) {
              return 80;
            }),*/
        ],
      ),
    );
  }

  araclariGetir() async {
    var araclarFuture = dbHelper.getAraclar();

    araclarFuture.then((value) {
      dbAraclar = value;
      print("veri sayisi : " + value.length.toString());

      dbAraclar.sort(
          (a, b) => a.Marka.toLowerCase().compareTo(b.Marka.toLowerCase()));

      filterList();
      searchController.addListener(() {
        filterList();
      });
    });
  }

  void paspasDetay(Arac arac) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => PaspasDetay(arac)));
    if (result != null) {
      if (result) {
        araclariGetir();
      }
    }
  }

  filterList() {
    List<Arac> tempList = [];
    tempList.addAll(dbAraclar);
    normalList = [];
    strList = [];

    if (searchController.text.isNotEmpty) {
      print(searchController.text);
      tempList.retainWhere((p) =>
          (p.Marka.toLowerCase() + " " + p.Model.toLowerCase())
              .contains(searchController.text.toLowerCase()));
    }

    if (dbAraclar.isNotEmpty) {
      tempList.forEach((p) {
        normalList.add(
          Card(
            child: Dismissible(
              background: dismissibleBg("sag"),
              secondaryBackground: dismissibleBg("sol"),
              child: ListTile(
                tileColor: Color.fromARGB(15, 12, 12, 12),
                contentPadding: EdgeInsets.all(10),
                leading: Container(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: MarkaIkonResmiSec(p.Marka),
                  ),
                ),
                title: Text(
                  p.Marka + " " + p.Model,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PaspasDetay(p)));
                },
              ),
              key: Key(p.id.toString()),
              onDismissed: (direction) async {},
              confirmDismiss: (DismissDirection direction) async {
                return await _showMyDialog(p.id, p.Marka, p.Model);
              },
            ),
          ),
        );
        strList.add(p.Marka);
      });

      setState(() {
        strList;
        normalList;
        strList;
      });

      print(strList.length);
    }
  }

  MarkaIkonResmiSec(String marka) {
    marka = marka.toLowerCase();

    String dosyaAdi = "assets/images/ferrari-4-202771.png";

    if (marka == "fiat") {
      dosyaAdi = "assets/images/fiat-1-202773.png";
    } else if (marka == "honda") {
      dosyaAdi = "assets/images/honda-16-202798.png";
    } else if (marka == "opel") {
      dosyaAdi = "assets/images/opel-2-202862.png";
    } else if (marka == "ferrari") {
      dosyaAdi = "assets/images/ferrari-4-202771.png";
    } else if (marka == "ford") {
      dosyaAdi = "assets/images/ford-1-202767.png";
    } else if (marka == "wolksvagen") {
      dosyaAdi = "assets/images/volkswagen-51-202922.png";
    } else if (marka == "bmw") {
      dosyaAdi = "assets/images/bmw-4-202746.png";
    } else if (marka == "alfa romeo") {
      dosyaAdi = "assets/images/alfa-1-202941.png";
    } else if (marka == "ds") {
      dosyaAdi = "assets/images/dsLogo.png";
    } else if (marka == "peugeout") {
      dosyaAdi = "assets/images/peugeoutLogo.png";
    }

    var resim = Image(
      image: AssetImage(dosyaAdi),
    );

    return resim;
  }

  Container dismissibleBg(String yon) {
    return Container(
      padding: EdgeInsets.all(25.0),
      alignment: yon == "sag" ? Alignment.centerLeft : Alignment.centerRight,
      child: Icon(Icons.delete),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
