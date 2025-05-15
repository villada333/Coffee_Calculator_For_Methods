// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'my_theme.dart';
import 'home_page.dart';
import 'pro_mode_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp(
      title: 'Café y Barismo',
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightThemeData,
      darkTheme: MyTheme.darkThemeData,
      themeMode: appState.themeMode,
      initialRoute: HomePage.routeName, // O PROModePage.routeName si quieres que inicie ahí
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        PROModePage.routeName: (context) => const PROModePage(), // Ruta añadida
      },
    );
  }
}