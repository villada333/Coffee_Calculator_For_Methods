// lib/pro_mode_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'dart:ui'; // Para Opacity

import 'my_theme.dart';
import 'app_state.dart';
import 'custom_actions.dart' as actions;
import 'home_page.dart'; // Para la navegación al HomePage

class PROModePage extends StatefulWidget {
  const PROModePage({super.key});

  static const String routeName = '/proMode'; 

  @override
  State<PROModePage> createState() => _PROModePageState();
}

class _PROModePageState extends State<PROModePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Estado local (antes en PROModeModel)
  double sliderMLValue = 130.0;      // Default: 130ml por taza
  double sliderTazasValue = 1.0;     // Default: 1 taza
  double sliderRatioValue = 10.0;    // Default: Ratio 1:10

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

  Future<void> _calculatePro() async {
    final mm = await actions.calcularMililitrosPro(
      sliderTazasValue.toStringAsFixed(0),
      sliderMLValue.toStringAsFixed(0),
    );
    final gramos = await actions.calcularGramosPro(
      sliderTazasValue.toStringAsFixed(0),
      sliderRatioValue.toStringAsFixed(0),
      sliderMLValue.toStringAsFixed(0),
    );

    // Para replicar el comportamiento de FlutterFlow, usamos la función `calcularPreinfusion` existente.
    // Ver la NOTA en custom_actions.dart sobre la posible inconsistencia de este cálculo
    // si se desea que la preinfusión en Modo PRO dependa del `sliderMLValue`.
    final preinfusion = await actions.calcularPreinfusion(
      sliderTazasValue.toStringAsFixed(0),
      sliderRatioValue.toStringAsFixed(0),
    );
    // Si decidiste usar una `calcularPreinfusionPro` que toma los gramos directamente:
    // final preinfusion = await actions.calcularPreinfusionPro(gramos);
    // O si `calcularPreinfusionPro` toma todos los sliders:
    // final preinfusion = await actions.calcularPreinfusionPro(
    //   sliderTazasValue.toStringAsFixed(0),
    //   sliderRatioValue.toStringAsFixed(0),
    //   sliderMLValue.toStringAsFixed(0),
    // );


    setState(() {
      resultMM = mm;
      resultGramos = gramos;
      resultPreinfusion = preinfusion;
    });
    // ignore: use_build_context_synchronously
    Provider.of<AppState>(context, listen: false).lookResult = true;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final Color ffAlternateColor = theme.brightness == Brightness.light
        ? MyTheme.lightAlternate
        : MyTheme.darkAlternate;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: PreferredSize( // AppBar idéntico al de HomePage
          preferredSize:
              Size.fromHeight(MediaQuery.sizeOf(context).height * 0.08),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Align(
              alignment: AlignmentDirectional.center,
              child: GradientText(
                'Café y Barismo',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium!.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 40,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
                colors: [
                  theme.brightness == Brightness.light ? MyTheme.lightSecondaryBackground : MyTheme.darkSecondaryBackground,
                  theme.brightness == Brightness.light ? MyTheme.lightAccent2 : MyTheme.darkAccent2,
                ],
                gradientType: GradientType.radial,
                radius: 5,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Opacity(
                opacity: 0.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    'assets/images/BackGroundjpg.webp',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding( // Botón Modo Asistido
                      padding: EdgeInsetsDirectional.fromSTEB(5, 15, 5, 15),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height * 0.05,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navega de vuelta a HomePage
                            Navigator.pushReplacementNamed(context, HomePage.routeName);
                            // O usa Navigator.pop(context); si PROMode se abrió con pushNamed
                          },
                          child: Text('Modo Asistido'),
                        ),
                      ),
                    ),

                    // Slider: Cantidad de Agua por Taza (ml)
                    _buildSectionContainer(
                      context,
                      theme: theme,
                      title: 'Cantidad de Agua por Taza (ml)',
                      children: [
                        Text(
                          sliderMLValue.toStringAsFixed(0),
                          style: textTheme.bodyMedium!.copyWith(fontSize: 22, color: ffAlternateColor),
                        ),
                        Slider(
                          min: 90, max: 170, value: sliderMLValue,
                          label: sliderMLValue.toStringAsFixed(0), divisions: 80,
                          onChanged: (newValue) => setState(() => sliderMLValue = newValue.roundToDouble()),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Slider: Número de Tazas
                    _buildSectionContainer(
                      context,
                      theme: theme,
                      title: 'Número de Tazas',
                      children: [
                        Text(
                          sliderTazasValue.toStringAsFixed(0),
                          style: textTheme.bodyMedium!.copyWith(fontSize: 22, color: ffAlternateColor),
                        ),
                        Slider(
                          min: 1, max: 12, value: sliderTazasValue,
                          label: sliderTazasValue.toStringAsFixed(0), divisions: 11,
                          onChanged: (newValue) => setState(() => sliderTazasValue = newValue.roundToDouble()),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Slider: Ratio Cafe Agua
                    _buildSectionContainer(
                      context,
                      theme: theme,
                      title: 'Ratio Cafe Agua',
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text('1:', style: textTheme.bodyMedium!.copyWith(fontSize: 22, color: ffAlternateColor)),
                             Text(sliderRatioValue.toStringAsFixed(0), style: textTheme.bodyMedium!.copyWith(fontSize: 22, color: ffAlternateColor)),
                          ],
                        ),
                        Slider(
                          min: 8, max: 16, value: sliderRatioValue,
                          label: sliderRatioValue.toStringAsFixed(0), divisions: 8, // (16-8) = 8
                          onChanged: (newValue) => setState(() => sliderRatioValue = newValue.roundToDouble()),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),

                    // Botón CALCULAR
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height * 0.07,
                      child: ElevatedButton(
                        onPressed: _calculatePro,
                        style: theme.elevatedButtonTheme.style?.copyWith(
                           textStyle: MaterialStateProperty.all(
                            textTheme.titleSmall!.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontSize: 28,
                            ),
                          ),
                        ),
                        child: Text('CALCULAR'),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Sección de Resultados (idéntica a HomePage)
                    Visibility(
                      visible: appState.lookResult,
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
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

  // --- Helper Widgets (Reutilizados/Adaptados de HomePage) ---
  Widget _buildSectionContainer(BuildContext context, {required ThemeData theme, required String title, required List<Widget> children}) {
    final Color ffAlternateColor = theme.brightness == Brightness.light
        ? MyTheme.lightAlternate
        : MyTheme.darkAlternate;
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium!.copyWith(fontSize: 24, color: ffAlternateColor),
          ),
          ...children, // El SizedBox entre el título y el contenido se añade dentro de `children` si es necesario
        ],
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, ThemeData theme, String label, String value, String unit) {
    final Color ffAlternateColor = theme.brightness == Brightness.light
        ? MyTheme.lightAlternate
        : MyTheme.darkAlternate;
    return Padding( // Añadido Padding para mejor espaciado en pantallas pequeñas
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.headlineMedium!.copyWith(fontSize: 22, color: ffAlternateColor), // Tamaño ajustado
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.headlineMedium!.copyWith(fontSize: 26, color: ffAlternateColor), // Tamaño ajustado
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 4),
          Text(
            unit,
            style: theme.textTheme.headlineMedium!.copyWith(fontSize: 22, color: ffAlternateColor), // Tamaño ajustado
          ),
        ],
      ),
    );
  }
}