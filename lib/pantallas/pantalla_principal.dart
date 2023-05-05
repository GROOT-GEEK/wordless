import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/obtener_palabras.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({Key? key}) : super(key: key);

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();

}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  double _valorDificultad =0 ; //Cargar de archivo de configuracion
  double _valorLongitud=0 ; //Cargar de archivo de configuracion
  final double dificultadMinima = 4.0;
  final double dificultadMaxima = 8.0;
  final double longitudMinima = 4.0;
  final double longitudMaxima = 6.0;
  final String claveLongitud = 'longitud';
  final String claveDificultad = 'dificultad';

  @override
  void initState(){
    super.initState();
    cargarPreferencias();

  }

  Future<void> guardarPreferencias( ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(claveDificultad, _valorDificultad);
    prefs.setDouble(claveLongitud, _valorLongitud);
  }

  Future<void> cargarPreferencias( ) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _valorDificultad = prefs.getDouble(claveDificultad) ?? 4.0;
      _valorLongitud = prefs.getDouble(claveLongitud) ?? 4.0;
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
                    print(await ObtenerPalabras ().obtenerPalabra(Filenum.cinco));
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
