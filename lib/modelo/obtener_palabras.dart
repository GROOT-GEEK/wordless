import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

enum Filenum {
  cuatro('cuatro.txt', 4),
  cinco('cinco.txt', 5),
  seis('seis.txt', 6);

  const Filenum(this.path, this.value);
  final String path;
  final num value;
}
Future<String> cargaFichero(Filenum p) async {
  return await rootBundle.loadString('assets/${p.path}');
}
class ObtenerPalabras {


  Future<String> obtenerPalabra(Filenum p) async{
    Random random = Random();
    String palabras = await cargaFichero(p);
    var lista = palabras.split('\r\n');
    int randomNumber = random.nextInt(lista.length);
    return quitarTildes(lista[randomNumber]);
  }

  String quitarTildes(String src){
    src = src.replaceAll(RegExp(r'á'), 'a');
    src = src.replaceAll(RegExp(r'é'), 'e');
    src = src.replaceAll(RegExp(r'í'), 'i');
    src = src.replaceAll(RegExp(r'ó'), 'o');
    src = src.replaceAll(RegExp(r'ú'), 'u');
    return src;
  }
}