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

class ObtenerPalabras {

  static Future<String> obtenerPalabra(int  length) async{
    Random random = Random();
    String palabras = await _cargaFichero(length);
    var lista = palabras.split('\r\n');
    int randomNumber = random.nextInt(lista.length);
    return _quitarTildes(lista[randomNumber]);
  }

  static String _quitarTildes(String src){
    src = src.replaceAll(RegExp(r'á'), 'a');
    src = src.replaceAll(RegExp(r'é'), 'e');
    src = src.replaceAll(RegExp(r'í'), 'i');
    src = src.replaceAll(RegExp(r'ó'), 'o');
    src = src.replaceAll(RegExp(r'ú'), 'u');
    return src;
  }

  static Future<String> _cargaFichero(int  length) async {
    Filenum p;
    if(length == 4){
      p=Filenum.cuatro;
    }else if (length == 5){
      p=Filenum.cinco;
    }else{
      p=Filenum.seis;
    }
    return await rootBundle.loadString('assets/${p.path}');
  }
}