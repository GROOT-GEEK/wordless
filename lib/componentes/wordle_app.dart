import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordless/pantallas/pantalla_principal.dart';

import '../modelos/estadosJuego.dart';

class WordleApp extends StatelessWidget {
  const WordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider<GameState>(create: (_) => GameState())],
      child: const MaterialApp(
        home: PantallaPrincipal(),
    ));

  }
}