import 'package:flutter/material.dart';
import 'package:wordless/pantallas/pantalla_principal.dart';

class WordleApp extends StatelessWidget {
  const WordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PantallaPrincipal(),

    );
  }
}