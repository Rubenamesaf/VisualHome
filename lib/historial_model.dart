//import 'package:flutter/material.dart';

class HistorialModel {
  String marcaTemporal;
  String sistema;
  String accion;
  String vivienda;

  HistorialModel(
      {required this.marcaTemporal,
      required this.accion,
      required this.sistema,
      required this.vivienda});

  factory HistorialModel.fromJson(dynamic json) {
    return HistorialModel(
        marcaTemporal: "${json['marca_temporal']}",
        sistema: "${json['sistema']}",
        accion: "${json['accion']}",
        vivienda: "${json['vivienda']}");
  }

  Map toJson() => {
        "marca_temporal": marcaTemporal,
        "sistema": sistema,
        "accion": accion,
        "vivienda": vivienda
      };
}
