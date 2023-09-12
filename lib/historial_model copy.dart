//import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

class SistemasModel {
  int Acceso;
  int ActivacionAlarma;
  int BotonPanico;
  int Despertador;
  int DisparoAlarma;
  int Incendio;
  int Perimetro;
  int PresenciaPuerta;
  int RuidoAlto;
  int TelefonoFijo;
  int Timbre;

  SistemasModel(
      {required this.Acceso,
      required this.ActivacionAlarma,
      required this.BotonPanico,
      required this.Despertador,
      required this.DisparoAlarma,
      required this.Incendio,
      required this.Perimetro,
      required this.PresenciaPuerta,
      required this.RuidoAlto,
      required this.TelefonoFijo,
      required this.Timbre});

  factory SistemasModel.fromJson(dynamic json) {
    return SistemasModel(
        Acceso: json['Acceso'],
        ActivacionAlarma: json['ActivacionAlarma'],
        BotonPanico: json['BotonPanico'],
        Despertador: json['Despertador'],
        DisparoAlarma: json['DisparoAlarma'],
        Incendio: json['Incendio'],
        Perimetro: json['Perimetro'],
        PresenciaPuerta: json['PresenciaPuerta'],
        RuidoAlto: json['RuidoAlto'],
        TelefonoFijo: json['TelefonoFijo'],
        Timbre: json['Timbre']);
  }

  Map toJson() => {
        "Acceso": Acceso,
        "ActivacionAlarma": ActivacionAlarma,
        "BotonPanico": BotonPanico,
        "Despertador": Despertador,
        "DisparoAlarma": DisparoAlarma,
        "Incendio": Incendio,
        "Perimetro": Perimetro,
        "PresenciaPuerta": PresenciaPuerta,
        "RuidoAlto": RuidoAlto,
        "TelefonoFijo": TelefonoFijo,
        "Timbre": Timbre,
      };
}
