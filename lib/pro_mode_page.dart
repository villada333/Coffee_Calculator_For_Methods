// lib/pro_mode_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'dart:ui'; 

import 'my_theme.dart';
import 'app_state.dart';
import 'custom_actions.dart' as actions;
import 'home_page.dart'; 

class PROModePage extends StatefulWidget {
  const PROModePage({super.key});

  static const String routeName = '/proMode'; 

  @override
  State<PROModePage> createState() => _PROModePageState();
}

class _PROModePageState extends State<PROModePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double sliderMLValue = 130.0;    
  double sliderTazasValue = 1.0;    
  double sliderRatioValue = 10.0;  

  int? resultMM;
  String? resultGramos;
  String? resultPreinfusion;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false)
          .setDarkModeSetting(context, ThemeMode.light); 
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

    final preinfusion = await actions.calcularPreinfusion(
      sliderTazasValue.toStringAsFixed(0),
      sliderRatioValue.toStringAsFixed(0),
    );

    setState(() {
      resultMM = mm;
      resultGramos = gramos;
      resultPreinfusion = preinfusion;
    });
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
        appBar: PreferredSize( 
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
                    Padding( 
                      padding: EdgeInsetsDirectional.fromSTEB(5, 15, 5, 15),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height * 0.05,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, HomePage.routeName);
                          },
                          child: Text('Modo Asistido'),
                        ),
                      ),
                    ),
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
                          label: sliderRatioValue.toStringAsFixed(0), divisions: 8, 
                          onChanged: (newValue) => setState(() => sliderRatioValue = newValue.roundToDouble()),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
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
          ...children, 
        ],
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, ThemeData theme, String label, String value, String unit) {
    final Color ffAlternateColor = theme.brightness == Brightness.light
        ? MyTheme.lightAlternate
        : MyTheme.darkAlternate;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.headlineMedium!.copyWith(fontSize: 22, color: ffAlternateColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.headlineMedium!.copyWith(fontSize: 26, color: ffAlternateColor), 
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 4),
          Text(
            unit,
            style: theme.textTheme.headlineMedium!.copyWith(fontSize: 22, color: ffAlternateColor), 
          ),
        ],
      ),
    );
  }
}