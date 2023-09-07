import 'package:flutter/material.dart';

class HistorialModel {
  String marcaTemporal;
  String sistema;
  String accion;

  HistorialModel(
      {required this.marcaTemporal,
      required this.accion,
      required this.sistema});

  factory HistorialModel.fromJson(dynamic json) {
    return HistorialModel(
      marcaTemporal: "${json['marca_temporal']}",
      sistema: "${json['sistema']}",
      accion: "${json['accion']}",
    );
  }

  Map toJson() =>
      {"marca_temporal": marcaTemporal, "sistema": sistema, "accion": accion};
}
