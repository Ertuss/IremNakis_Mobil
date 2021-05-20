import 'package:flutter/material.dart';
import 'package:flutter_firstapp/Data/DbHelper.dart';
import 'package:flutter_firstapp/Models/Arac.dart';
import 'package:flutter_firstapp/Models/Paspas.dart';
import 'package:flutter_firstapp/Validator/paspas_validator.dart';

class ModelEkle extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ModelEkleState();
  }

}

class _ModelEkleState extends State with PaspasValidatorMixin {

  var dbHelper = new DbHelper();
  var txtMarka = new TextEditingController();
  var txtModel = new TextEditingController();
  var txtAdetFiyat = new TextEditingController();

  var arac = new Arac.withoutInfo();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Model Ekle"),
        backgroundColor: Colors.deepOrange,
        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(5),
          ),
        ),
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
      validator: ValidateMarkaAdi,
      onSaved: (String value) {
        arac.Marka = value;
      },
      controller: txtMarka,
    );
  }

  Widget buildModelAdiField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Model"),
      validator: ValidateModelAdi,
      onSaved: (String value) {
        arac.Model = value;
      },
      controller: txtModel,
    );
  }

  Widget buildSubmitButtonField() {
    return RaisedButton(
      child: Text("Modeli Ekle"),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          savePaspas();
        }
      },
    );
  }

  void savePaspas() async {
    //print(paspas.Marka + " " + paspas.Model + " " + paspas.AdetFiyat.toString());
    await dbHelper.ekleArac(Arac(txtMarka.text, txtModel.text, new List<Paspas>()));
    Navigator.pop(context, true);
  }
}
