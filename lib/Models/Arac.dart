import 'Paspas.dart';

class Arac {
  int id;
  String Marka;
  String Model;

  Arac(String marka, String model, List<Paspas> Paspaslar) {
    this.Marka = marka;
    this.Model = model;
  }

  Arac.withoutInfo();

  Arac.withId(this.id, this.Marka, this.Model);
  Arac.withoutId(this.Marka, this.Model);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["marka"] = Marka;
    map["model"] = Model;
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  Arac.fromObject(dynamic o) {
    this.id = int.tryParse(o["id"].toString());
    this.Marka = o["marka"];
    this.Model = o["model"];
  }
}