// lib/home_page.dart
import 'package:cafe_y_barismo/pro_mode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'dart:ui'; // Para Opacity

import 'my_theme.dart'; // Tu tema personalizado
import 'app_state.dart'; // Tu estado de aplicación
import 'custom_actions.dart' as actions; // Tus acciones personalizadas

// Si PROModeWidget está en otro archivo:
// import 'pro_mode_page.dart'; // Asegúrate de tener esta página y su routeName
// class PROModeWidget extends StatelessWidget {
// static const String routeName = '/proMode';
// // ... resto de tu widget PROModeWidget
// }


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/homePage'; // Para la navegación

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Estado local
  String? dropDownMetodoValue;
  double sliderTazasValue = 1.0; // Valor inicial
  String? dropDownIntensidadValue;

  // Resultados de acciones
  int? resultMM;
  String? resultGramos;
  String? resultPreinfusion;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false)
          .setDarkModeSetting(context, ThemeMode.light); // O el modo por defecto que prefieras
    });
  }

  Future<void> _calculate() async {
    if ((dropDownMetodoValue != null && dropDownMetodoValue!.isNotEmpty) &&
        (dropDownIntensidadValue != null &&
            dropDownIntensidadValue!.isNotEmpty)) {
      final mm = await actions.calcularMililitros(sliderTazasValue.toString());
      final gramos = await actions.calcularGramos(
        sliderTazasValue.toString(),
        dropDownIntensidadValue!,
        dropDownMetodoValue!,
      );
      final preinfusion = await actions.calcularPreinfusion(
        sliderTazasValue.toString(),
        dropDownIntensidadValue!,
      );

      setState(() {
        resultMM = mm;
        resultGramos = gramos;
        resultPreinfusion = preinfusion;
      });
      // ignore: use_build_context_synchronously
      Provider.of<AppState>(context, listen: false).lookResult = true;
    } else {
      // ignore: use_build_context_synchronously
      final currentTheme = Theme.of(context);
      showDialog(
        context: context,
        builder: (alertDialogContext) {
          return AlertDialog(
            title: Text('Error', style: currentTheme.dialogTheme.titleTextStyle),
            content: Text('Faltan Datos!', style: currentTheme.dialogTheme.contentTextStyle),
            backgroundColor: currentTheme.dialogTheme.backgroundColor,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(alertDialogContext),
                child: Text('Ok', style: TextStyle(color: currentTheme.colorScheme.primary)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context); // ThemeData actual (light o dark)
    final textTheme = theme.textTheme; // TextTheme actual

    // Determinar colores específicos de FlutterFlow si son necesarios y no están en ColorScheme
    final Color ffAlternateColor = theme.brightness == Brightness.light
        ? MyTheme.lightAlternate
        : MyTheme.darkAlternate;
    final Color ffSecondaryTextColor = theme.brightness == Brightness.light
        ? MyTheme.lightSecondaryText
        : MyTheme.darkSecondaryText;
    final Color ffSecondaryBackgroundColor = theme.brightness == Brightness.light
        ? MyTheme.lightSecondaryBackground
        : MyTheme.darkSecondaryBackground;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.sizeOf(context).height * 0.08),
          child: AppBar(
            // backgroundColor ya viene del theme.appBarTheme.backgroundColor
            automaticallyImplyLeading: false,
            title: Align(
              alignment: AlignmentDirectional.center,
              child: GradientText(
                'Café y Barismo',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium!.copyWith(
                  // El color del texto base para GradientText, el gradiente lo sobreescribe.
                  // Usamos onPrimary ya que el fondo del AppBar es primary.
                  color: theme.colorScheme.onPrimary,
                  fontSize: 40, // Según tu diseño original
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
                colors: [
                  // Colores del gradiente basados en tu tema de FlutterFlow
                  theme.brightness == Brightness.light ? MyTheme.lightSecondaryBackground : MyTheme.darkSecondaryBackground, // primaryBackground
                  theme.brightness == Brightness.light ? MyTheme.lightAccent2 : MyTheme.darkAccent2, // accent2
                ],
                gradientType: GradientType.radial,
                radius: 5,
              ),
            ),
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              background: Opacity(
                opacity: 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    'assets/images/BackGroundjpg.webp', // Asegúrate que esta imagen exista
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // centerTitle y elevation ya vienen de theme.appBarTheme
          ),
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional.topCenter, // Alineado arriba para SingleChildScrollView
            child: Padding(
              padding: EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Para que el Column no ocupe toda la altura innecesariamente
                  mainAxisAlignment: MainAxisAlignment.start, // Alinea los elementos al inicio
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 15, 5, 15), // Ajusta el padding si es necesario
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          child: ElevatedButton(
                            onPressed: () {
                              // --- ESTA ES LA LÍNEA CRUCIAL ---
                              Navigator.pushNamed(context, PROModePage.routeName);
                              // ---------------------------------
                            },
                            // El estilo del botón debería tomarse del elevatedButtonTheme en MyTheme
                            // Si necesitas un estilo muy específico aquí, puedes usar .copyWith()
                            // style: theme.elevatedButtonTheme.style?.copyWith(...),
                            child: Text('Modo Pro'), // El estilo del texto también viene del theme
                          ),
                        ),
                      ),
                    _buildDropdownContainer(
                      context,
                      theme: theme,
                      title: 'Método a Preparar',
                      child: DropdownButtonFormField<String>(
                        value: dropDownMetodoValue,
                        hint: Text('Seleccione un metodo', style: theme.inputDecorationTheme.hintStyle),
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: ffSecondaryTextColor,
                          size: 24,
                        ),
                        decoration: InputDecoration( // Usa el theme.inputDecorationTheme por defecto
                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        style: textTheme.labelLarge, // Estilo del texto del item seleccionado
                        dropdownColor: theme.brightness == Brightness.light ? MyTheme.lightPrimaryBackground : MyTheme.darkPrimaryBackground,
                        items: [
                          'Aeropress', 'Chemex', 'V60', 'Prensa Francesa', 'Sifón'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: textTheme.labelLarge), // Estilo de los items en la lista
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => dropDownMetodoValue = val),
                      ),
                    ),
                     SizedBox(height: 15),

                    _buildSectionContainer(
                      context,
                      theme: theme,
                      title: 'Número de Tazas',
                      children: [
                        Text(
                          sliderTazasValue.toStringAsFixed(0),
                          style: textTheme.bodyMedium!.copyWith(
                            fontSize: 22,
                            color: ffAlternateColor, // Color específico
                          ),
                        ),
                        Slider(
                          // activeColor, inactiveColor, thumbColor vienen de theme.sliderTheme
                          min: 1,
                          max: 12,
                          value: sliderTazasValue,
                          label: sliderTazasValue.toStringAsFixed(0),
                          divisions: 11,
                          onChanged: (newValue) {
                            setState(() => sliderTazasValue =
                                double.parse(newValue.toStringAsFixed(0)));
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    _buildDropdownContainer(
                      context,
                      theme: theme,
                      title: 'Intensidad de Preparación',
                      child: DropdownButtonFormField<String>(
                        value: dropDownIntensidadValue,
                        hint: Text('Seleccione intensidad', style: theme.inputDecorationTheme.hintStyle),
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: ffSecondaryTextColor,
                          size: 24,
                        ),
                        decoration: InputDecoration(
                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        style: textTheme.labelLarge,
                        dropdownColor: theme.brightness == Brightness.light ? MyTheme.lightPrimaryBackground : MyTheme.darkPrimaryBackground,
                        items: const [
                          MapEntry('18', 'Muy Suave (1:18)'), MapEntry('16', 'Suave (1:16)'),
                          MapEntry('14', 'Normal (1:14)'), MapEntry('12', 'Un Poco Fuerte (1:12)'),
                          MapEntry('10', 'Fuerte (1:10)'), MapEntry('8', 'Muy Fuerte (1:8)'),
                        ].map<DropdownMenuItem<String>>((entry) {
                           return DropdownMenuItem<String>(
                             value: entry.key,
                             child: Text(entry.value, style: textTheme.labelLarge),
                           );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => dropDownIntensidadValue = val),
                      ),
                    ),
                    SizedBox(height: 25),

                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * 0.07,
                      child: ElevatedButton(
                        onPressed: _calculate,
                        style: theme.elevatedButtonTheme.style?.copyWith(
                           textStyle: MaterialStateProperty.all(
                            textTheme.titleSmall!.copyWith(
                              color: theme.colorScheme.onPrimary, // Asegura contraste
                              fontSize: 28,
                            ),
                          ),
                        ),
                        child: Text('CALCULAR'),
                      ),
                    ),
                    SizedBox(height: 20),

                    Visibility(
                      visible: appState.lookResult,
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor, // O ffSecondaryBackgroundColor si es distinto
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildResultRow(context, theme, 'Gramos de Café: ', resultGramos ?? '0', 'gr'),
                            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                            _buildResultRow(context, theme, 'Mililitros de Agua: ', resultMM?.toString() ?? '0.0', 'ml'),
                             SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                            _buildResultRow(context, theme, 'Preinfusion: ', resultPreinfusion ?? '0.0', 'ml'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownContainer(BuildContext context, {required ThemeData theme, required String title, required Widget child}) {
    final Color ffAlternateColor = theme.brightness == Brightness.light
        ? MyTheme.lightAlternate
        : MyTheme.darkAlternate;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(vertical: 8), // Reducido un poco
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 24,
              color: ffAlternateColor, // Color específico de FlutterFlow
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 300,
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer(BuildContext context, {required ThemeData theme, required String title, required List<Widget> children}) {
    final Color ffAlternateColor = theme.brightness == Brightness.light
        ? MyTheme.lightAlternate
        : MyTheme.darkAlternate;
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(vertical: 8), // Reducido un poco
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 24,
              color: ffAlternateColor, // Color específico de FlutterFlow
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, ThemeData theme, String label, String value, String unit) {
    final Color ffAlternateColor = theme.brightness == Brightness.light
        ? MyTheme.lightAlternate
        : MyTheme.darkAlternate;

    return Row(
      mainAxisSize: MainAxisSize.min, // Para que no ocupe todo el ancho innecesariamente
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible( // Para que el texto se ajuste si es muy largo
          child: Text(
            label,
            style: theme.textTheme.headlineMedium!.copyWith(
              fontSize: 24,
              color: ffAlternateColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: theme.textTheme.headlineMedium!.copyWith(
              fontSize: 28,
              color: ffAlternateColor,
            ),
             overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 4),
        Text(
          unit,
          style: theme.textTheme.headlineMedium!.copyWith(
            fontSize: 24,
            color: ffAlternateColor,
          ),
        ),
      ],
    );
  }
}