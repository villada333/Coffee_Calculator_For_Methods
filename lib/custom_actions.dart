// lib/custom_actions.dart

// Asegúrate de que estas funciones coincidan con lo que tenías en FlutterFlow
// y que devuelvan los tipos correctos.
// Estas son implementaciones de ejemplo.
Future<int> calcularMililitros(String tazasStr) async {
  // Ejemplo: 1 taza = 240 ml
  double tazas = double.tryParse(tazasStr) ?? 0;
  return (tazas * 240).toInt();
}

Future<String> calcularGramos(
    String tazasStr, String intensidadRatioStr, String metodo) async {
  // Ejemplo: tazas * (240 / ratio)
  // metodo podría influir en el cálculo, aquí no lo usamos pero es un parámetro
  double tazas = double.tryParse(tazasStr) ?? 0;
  double ratio = double.tryParse(intensidadRatioStr) ?? 14; // Default a 1:14
  if (ratio == 0) ratio = 14; // Evitar división por cero
  double gramos = (tazas * 240) / ratio;
  return gramos.toStringAsFixed(1); // Un decimal de precisión
}

Future<String> calcularPreinfusion(
    String tazasStr, String intensidadRatioStr) async {
  // Ejemplo: gramos de café * 2 (para preinfusión 1:2)
  // Primero calculamos los gramos de café de forma similar a calcularGramos
  double tazas = double.tryParse(tazasStr) ?? 0;
  double ratio = double.tryParse(intensidadRatioStr) ?? 14;
  if (ratio == 0) ratio = 14;
  double gramosCafe = (tazas * 240) / ratio;
  double preinfusionMl = gramosCafe * 2;
  return preinfusionMl.toStringAsFixed(1);
}

// lib/custom_actions.dart

// ... (funciones existentes: calcularMililitros, calcularGramos, calcularPreinfusion) ...

// --- NUEVAS FUNCIONES PARA PRO MODE ---

Future<int> calcularMililitrosPro(String tazasStr, String mlPorTazaStr) async {
  double tazas = double.tryParse(tazasStr) ?? 0;
  double mlPorTaza = double.tryParse(mlPorTazaStr) ?? 0;
  return (tazas * mlPorTaza).round(); // Usar round() para un entero más preciso
}

Future<String> calcularGramosPro(String tazasStr, String ratioStr, String mlPorTazaStr) async {
  double tazas = double.tryParse(tazasStr) ?? 0;
  double ratio = double.tryParse(ratioStr) ?? 14; // Default a 1:14 si no se puede parsear
  double mlPorTaza = double.tryParse(mlPorTazaStr) ?? 0;

  if (ratio <= 0) ratio = 14; // Evitar división por cero o ratios inválidos

  double aguaTotalMl = tazas * mlPorTaza;
  double gramosCafe = aguaTotalMl / ratio;
  return gramosCafe.toStringAsFixed(1); // Un decimal de precisión
}

// NOTA SOBRE calcularPreinfusion:
// En tu código FlutterFlow para PROMode, la acción `calcularPreinfusion` se llama así:
// _model.resultPreinfusion = await actions.calcularPreinfusion(
//    _model.sliderTazasValue!.toString(),
//    _model.sliderRatioValue.toString(), // Este es el ratio directo (ej: "10", "12")
// );
// La función `calcularPreinfusion` que definimos previamente es:
// Future<String> calcularPreinfusion(String tazasStr, String intensidadRatioStr) async {
//   double tazas = double.tryParse(tazasStr) ?? 0;
//   double ratio = double.tryParse(intensidadRatioStr) ?? 14;
//   if (ratio <= 0) ratio = 14;
//   double aguaTotalMl = tazas * 240; // Asume 240ml por taza por defecto
//   double gramosCafe = aguaTotalMl / ratio;
//   double preinfusionMl = gramosCafe * 2; // Típica preinfusión 1:2 (agua:café)
//   return preinfusionMl.toStringAsFixed(1);
// }
// Esta función `calcularPreinfusion` original asume 240ml/taza para calcular los gramos base para la preinfusión.
// Si en Modo PRO deseas que la preinfusión se calcule basada en el `sliderMLValue` (ml por taza que el usuario define),
// entonces esta función `calcularPreinfusion` NO lo hará correctamente para el Modo PRO, ya que ignora `sliderMLValue`.
//
// Para replicar EXACTAMENTE el comportamiento de tu código FlutterFlow (incluso si hay una inconsistencia lógica):
// Se llamaría a la función `calcularPreinfusion` existente tal cual.
//
// Si deseas un cálculo MÁS CONSISTENTE para el Modo PRO donde la preinfusión use el `sliderMLValue`:
// Deberías:
//   Opción A: Modificar `calcularPreinfusion` para aceptar un `mlPorTazaStr` opcional.
//   Opción B: Crear una nueva función `calcularPreinfusionPro` que tome `tazasStr`, `ratioStr`, y `mlPorTazaStr`.
//             Ejemplo Opción B:
//             Future<String> calcularPreinfusionPro(String tazasStr, String ratioStr, String mlPorTazaStr) async {
//               double tazas = double.tryParse(tazasStr) ?? 0;
//               double ratio = double.tryParse(ratioStr) ?? 14;
//               double mlPorTaza = double.tryParse(mlPorTazaStr) ?? 0;
//               if (ratio <= 0) ratio = 14;
//               double aguaTotalMl = tazas * mlPorTaza;
//               double gramosCafe = aguaTotalMl / ratio;
//               double preinfusionMl = gramosCafe * 2;
//               return preinfusionMl.toStringAsFixed(1);
//             }
//             Y luego llamar a `actions.calcularPreinfusionPro(...)` en PROModePage.
//
// Por ahora, para mantener la migración lo más directa posible al código original, la página PROMode
// llamará a la función `calcularPreinfusion` existente. Si deseas cambiar esta lógica,
// puedes implementar la Opción B y cambiar la llamada en `_PROModePageState._calculatePro()`.