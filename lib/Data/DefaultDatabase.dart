import 'package:flutter_firstapp/Models/Arac.dart';

class DefaultDatabase{

  static List<Arac> DefaultAraclariOlustur()
  {

    List<Arac> defaultAraclar = new List<Arac>();

    Arac egea = new Arac.withoutId("Fiat", "Egea");
    Arac cross = new Arac.withoutId("Fiat", "Cross");
    Arac doblo = new Arac.withoutId("Fiat", "Doblo");
    Arac ducato = new Arac.withoutId("Fiat", "Ducato");

    Arac p208 = new Arac.withoutId("Peugeout", "208");
    Arac p2008 = new Arac.withoutId("Peugeout", "2008");
    Arac corsa = new Arac.withoutId("Opel", "Corsa");
    Arac mokke = new Arac.withoutId("Opel", "Mokka");

    Arac performanceLine = new Arac.withoutId("DS", "Performance Line");

    defaultAraclar.add(egea);
    defaultAraclar.add(cross);
    defaultAraclar.add(doblo);
    defaultAraclar.add(ducato);
    defaultAraclar.add(p208);
    defaultAraclar.add(p2008);
    defaultAraclar.add(corsa);
    defaultAraclar.add(mokke);
    defaultAraclar.add(performanceLine);

    return  defaultAraclar;

  }



}