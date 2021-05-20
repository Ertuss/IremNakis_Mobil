import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firstapp/Data/DbHelper.dart';
import 'package:flutter_firstapp/Models/Paspas.dart';
import 'package:image_picker/image_picker.dart';

class PaspasEkle extends StatefulWidget {
  int aracId;

  PaspasEkle(int aracId)
  {
    this.aracId = aracId;
  }

  @override
  State<StatefulWidget> createState() {
    return _PaspasEkleState(aracId);
  }
}

class _PaspasEkleState extends State {

  File _image;
  String paspasAdi;
  String paspasAciklama;
  Paspas p = new Paspas.withoutInfo();

  var dbHelper = new DbHelper();
  var txtAdi = new TextEditingController();
  var txtAciklama = new TextEditingController();
  var txtFiyat = new TextEditingController();
  var formKey = GlobalKey<FormState>();

  _PaspasEkleState(int aracId)
  {
    p.AracId = aracId;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        shrinkWrap: true,
        key: formKey,
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],),
                      height: 400,
                      width: 300,
                      child: _image != null
                          ? Card(
                              child: Column(
                                children: [
                                  Image.file(
                                    _image,
                                    fit: BoxFit.fitHeight,

                                  ),
                                ],
                              ),
                            )
                          : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                ],
              ),
            ),
          ),
          buildAdiField(),
          buildAciklamaField(),
          buildFiyatField(),
          buildSubmitButtonField(),
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () async {
                        await _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Widget buildAdiField() {
    return Container(
      constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: "Paspas Adı"),
        onChanged: (String value) {
          p.Adi = value;
        },
        controller: txtAdi,
      ),
    );
  }

  Widget buildAciklamaField() {
    return Container(
      constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: "Açıklama"),
        onChanged: (String value) {
          p.Aciklama = value;
        },
        controller: txtAciklama,
      ),
    );
  }

  Widget buildFiyatField() {
    return Container(
      constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: "Fiyat"),
        onChanged: (String val) {
          p.Fiyat = double.tryParse(val);
        },
        controller: txtFiyat,
      ),
    );
  }

  Widget buildSubmitButtonField() {
    return Container(
      margin: EdgeInsets.fromLTRB(0,20,0,30),
      constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
      child: RaisedButton(
        onPressed: () async {
          if (_image != null)
            {
              List<int> imgInts = await _image.readAsBytes();
              String img = base64Encode(imgInts);
              p.Resim = img;
              await dbHelper.eklePaspas(p);
              print(p.AracId);
              print(p.Adi);
              print(p.Aciklama);
              print(p.Fiyat);
              print(p.Resim);
              Navigator.pop(context, true);
            }
        },
        color: Theme.of(context).accentColor,
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Paspası Ekle',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
