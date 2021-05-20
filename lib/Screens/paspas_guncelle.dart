import 'package:flutter/material.dart';
import 'package:flutter_firstapp/Models/Arac.dart';
import 'package:flutter_firstapp/Validator/paspas_validator.dart';

class PaspasGuncelle extends StatefulWidget {

  Arac guncellenecekPaspas;
  PaspasGuncelle(Arac guncellenecekPaspas)
  {
    this.guncellenecekPaspas = guncellenecekPaspas;
  }
  @override
  State<StatefulWidget> createState() {
    return _PaspasGuncelleState(guncellenecekPaspas);
  }
}

class _PaspasGuncelleState extends State with PaspasValidatorMixin {

  Arac guncellenecekArac;
  _PaspasGuncelleState(Arac guncellenecekPaspas)
  {
    this.guncellenecekArac = guncellenecekPaspas;
  }

  var paspas = new Arac.withoutInfo();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paspas Güncelle"),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              buildMarkaAdiField(),
              buildModelAdiField(),
              buildSubmitButtonField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMarkaAdiField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Marka"),
      initialValue: guncellenecekArac.Marka,
      validator: ValidateMarkaAdi,
      onSaved: (String value) {
        guncellenecekArac.Marka = value;
      },
    );
  }

  Widget buildModelAdiField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Model"),
      initialValue: guncellenecekArac.Model,
      validator: ValidateModelAdi,
      onSaved: (String value) {
        guncellenecekArac.Model = value;
      },
    );
  }

  Widget buildSubmitButtonField() {
    return RaisedButton(
      child: Text("Modeli Guncelle"),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          Navigator.pop(context);
        }
      },
    );
  }
}
