import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firstapp/Data/DbHelper.dart';
import 'package:flutter_firstapp/Models/Arac.dart';
import 'package:flutter_firstapp/Models/Paspas.dart';
import 'package:flutter_firstapp/Screens/paspas_ekle.dart';
import 'package:flutter_firstapp/Validator/paspas_validator.dart';

class PaspasDetay extends StatefulWidget {
  Arac arac;

  PaspasDetay(Arac arac) {
    this.arac = arac;
  }

  @override
  State<StatefulWidget> createState() {
    return _PaspasDetayState(arac);
  }
}

class _PaspasDetayState extends State {
  Arac arac;
  var dbHelper = new DbHelper();
  List<Paspas> paspaslar = new List<Paspas>();

  _PaspasDetayState(Arac arac) {
    this.arac = arac;
    paspaslariGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paspas : ${arac.Marka + " " + arac.Model}"),
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),
      ),
      body: buildPaspasDetay(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Route<bool> route =
              MaterialPageRoute(builder: (context) => PaspasEkle(arac.id));
          bool result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => PaspasEkle(arac.id)));
          if (result != null) {
            paspaslariGetir();
          }
        },
        tooltip: "Yeni ürün ekle",
        child: Icon(Icons.add),
      ),
    );
  }

  buildPaspasDetay() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: paspaslar.length,
              itemBuilder: (ctx, index) {
                return Card(
                  color: Colors.white24,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(paspaslar[index].Adi +
                            " " +
                            paspaslar[index].Aciklama),
                        subtitle: Text(paspaslar[index].Fiyat.toString()),
                      ),
                      Image.memory(
                        base64Decode(paspaslar[index].Resim),
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void paspaslariGetir() async {
    var list = await dbHelper.getPaspaslar(arac.id);
    print("paspas sayisi : " + list.length.toString());

    setState(() {
      this.paspaslar = list;
    });
  }
}
