import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../componentes/home.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({Key? key}) : super(key: key);

  static const String claveLongitud = 'longitud';
  static const String claveDificultad = 'dificultad';

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();

}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  double _valorDificultad =0 ; //Cargar de archivo de configuracion
  double _valorLongitud=0 ; //Cargar de archivo de configuracion
  final double dificultadMinima = 5.0;
  final double dificultadMaxima = 8.0;
  final double longitudMinima = 4.0;
  final double longitudMaxima = 6.0;


  @override
  void initState(){
    super.initState();
    cargarPreferencias();
  }

  Future<void> guardarPreferencias( ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(PantallaPrincipal.claveDificultad, _valorDificultad);
    prefs.setDouble(PantallaPrincipal.claveLongitud, _valorLongitud);
  }

  Future<void> cargarPreferencias( ) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _valorDificultad = prefs.getDouble(PantallaPrincipal.claveDificultad) ?? 4.0;
      _valorLongitud = prefs.getDouble(PantallaPrincipal.claveLongitud) ?? 4.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('WORDLE',
                textScaleFactor: 4.0,
                style: GoogleFonts.lilitaOne(
                    textStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              const Text('Dificultad (Número de intentos)'),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if(_valorDificultad > dificultadMinima) {
                            _valorDificultad--;
                          }
                        });
                      },
                      child: const Icon( Icons.arrow_left_outlined, ),
                    ),

                    Text(_valorDificultad.toInt().toString()),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if(_valorDificultad < dificultadMaxima) {
                            _valorDificultad++;
                          }
                        });
                      },
                      child: const Icon( Icons.arrow_right_outlined, ),
                    ),
                  ]
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text('Longitud de palabra'),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if(_valorLongitud > longitudMinima) {
                            _valorLongitud--;
                          }
                        });
                      },
                      child: const Icon( Icons.arrow_left_outlined, ),
                    ),

                    Text(_valorLongitud.toInt().toString()),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if(_valorLongitud < longitudMaxima) {
                            _valorLongitud++;
                          }
                        });
                      },
                      child: const Icon( Icons.arrow_right_outlined, ),
                    ),
                  ]
              ),

              const SizedBox(
                height: 50.0,
              ),
              SizedBox(
                width: double.infinity,
                child: IconButton(
                  icon: const Icon(Icons.play_circle_outline),
                  iconSize: 80,
                  onPressed: () async {
                    guardarPreferencias();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const MyHomePage(title: 'WORDLE',)));
                  }, // pasar de pantalla
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}