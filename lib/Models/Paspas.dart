import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Paspas {
  int id;
  int AracId;
  String Adi;
  String Aciklama;
  double Fiyat;
  String Resim;

  Paspas.withoutInfo(){}

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["aracId"] = AracId;
    map["paspasAdi"] = Adi;
    map["aciklama"] = Aciklama;
    map["resim"] = Resim;
    map["fiyat"] = Fiyat;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Paspas.fromObject(dynamic o) {
    this.id = int.tryParse(o["id"].toString());
    this.AracId = o["aracId"];
    this.Adi = o["paspasAdi"].toString().isNotEmpty ? o["paspasAdi"].toString() : "Değer girilmemiş";
    this.Aciklama = o["aciklama"].toString().isNotEmpty ? o["aciklama"].toString() : "Değer girilmemiş";
    this.Fiyat = double.tryParse(o["fiyat"].toString().isNotEmpty ? o["fiyat"].toString() : "0");
    this.Resim = o["resim"];
  }

}
