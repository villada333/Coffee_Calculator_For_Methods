// custom_actions.dart
Future<int> calcularMililitros(String tazasStr) async {
  double tazas = double.tryParse(tazasStr) ?? 0;
  return (tazas * 240).toInt();
}

Future<String> calcularGramos(
    String tazasStr, String intensidadRatioStr, String metodo) async {
  double tazas = double.tryParse(tazasStr) ?? 0;
  double ratio = double.tryParse(intensidadRatioStr) ?? 14;
  if (ratio == 0) ratio = 14;
  double gramos = (tazas * 240) / ratio;
  return gramos.toStringAsFixed(1); 
}

Future<String> calcularPreinfusion(
    String tazasStr, String intensidadRatioStr) async {
  double tazas = double.tryParse(tazasStr) ?? 0;
  double ratio = double.tryParse(intensidadRatioStr) ?? 14;
  if (ratio == 0) ratio = 14;
  double gramosCafe = (tazas * 240) / ratio;
  double preinfusionMl = gramosCafe * 2;
  return preinfusionMl.toStringAsFixed(1);
}

// Funciones Pro Mode
Future<int> calcularMililitrosPro(String tazasStr, String mlPorTazaStr) async {
  double tazas = double.tryParse(tazasStr) ?? 0;
  double mlPorTaza = double.tryParse(mlPorTazaStr) ?? 0;
  return (tazas * mlPorTaza).round();
}

Future<String> calcularGramosPro(String tazasStr, String ratioStr, String mlPorTazaStr) async {
  double tazas = double.tryParse(tazasStr) ?? 0;
  double ratio = double.tryParse(ratioStr) ?? 14; 
  double mlPorTaza = double.tryParse(mlPorTazaStr) ?? 0;

  if (ratio <= 0) ratio = 14; 

  double aguaTotalMl = tazas * mlPorTaza;
  double gramosCafe = aguaTotalMl / ratio;
  return gramosCafe.toStringAsFixed(1); 
}