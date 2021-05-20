import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firstapp/Data/DefaultDatabase.dart';
import 'package:flutter_firstapp/Models/Arac.dart';
import 'package:flutter_firstapp/Models/Paspas.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper
{
  Database _db;

  Future<Database> get db async{
    if(_db == null)
      {
        _db = await initializeDb();
      }
    return _db;
  }

  void destroyDb() async {
    String dbPath =  join(await getDatabasesPath(), "IremNakis.db");
    deleteDatabase(dbPath);
  }

  Future<Database> initializeDb() async {
    String dbPath =  join(await getDatabasesPath(), "IremNakis.db");
    var IremNakisDb = openDatabase(dbPath, version: 4, onCreate: createDb);
    return IremNakisDb;
  }

  void createDb(Database db, int version) async {
    await db.execute("CREATE TABLE ARACLAR(id integer primary key, marka text, model text)");
    await db.execute("CREATE TABLE PASPASLAR(id integer primary key, aracId integer, paspasAdi text, aciklama text, fiyat real, resim text, foreign key(aracId) REFERENCES ARACLAR(id))");

    var defaultAracList = DefaultDatabase.DefaultAraclariOlustur();

    defaultAracList.forEach((arac) async {
      int sonuc = await db.insert("ARACLAR", arac.toMap());
      print(sonuc);
    });

  }


  Future<List<Arac>> getAraclar() async{
    Database db = await this.db;
    var sonuc = await db.query("ARACLAR");

    return List.generate(sonuc.length, (index) {
      return Arac.fromObject(sonuc[index]);
    });
  }

  Future<List<Paspas>> getPaspaslar(int aracId) async{
    Database db = await this.db;
    var sonuc = await db.rawQuery("SELECT * FROM PASPASLAR WHERE aracId = $aracId");

    return List.generate(sonuc.length, (index) {
      return Paspas.fromObject(sonuc[index]);
    });
  }

  Future<int> ekleArac(Arac arac) async{
    Database db = await this.db;

    var sonuc = await db.insert("ARACLAR", arac.toMap());
    return sonuc;
  }

  Future<int> eklePaspas(Paspas paspas) async{
    Database db = await this.db;

    var sonuc = await db.insert("PASPASLAR", paspas.toMap());
    return sonuc;
  }

  Future<int> silArac(int id) async {
    Database db = await this.db;
    var sonuc = await db.rawDelete("DELETE FROM ARACLAR WHERE id = $id");
    return sonuc;
  }

  Future<int> silTumPaspaslari() async{
    Database db = await this.db;
    var sonuc = await db.rawDelete("DELETE FROM PASPASLAR");
    return sonuc;
  }

  Future<int> silTumAraclari() async{
    Database db = await this.db;
    var sonuc = await db.rawDelete("DELETE FROM ARACLAR");
    return sonuc;
  }

  Future<int> guncellePaspas(Arac paspas) async{
    Database db = await this.db;
    var sonuc = await db.update("ARACLAR", paspas.toMap(), where: "id=?", whereArgs: [paspas.id]);
    return sonuc;
  }
}