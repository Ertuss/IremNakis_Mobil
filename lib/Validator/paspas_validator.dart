class PaspasValidatorMixin{

  String ValidateMarkaAdi(String value)
  {
    if (value.length < 2 || value.length > 25){
      return "Marka adı en az 2 karakter olabilir.";
    }
  }

  String ValidateModelAdi(String value)
  {
    if (value.length < 2 || value.length > 25){
      return "Model adı en az 2 karakter olabilir.";
    }
  }

  String ValidateAdetFiyati(String value)
  {
    var fiyat = double.parse(value);
    if (fiyat < 0 || fiyat > 100){
      return "Adet fiyatı değer aralığının dışında.";
    }
  }

}