// To parse this JSON data, do
//
//     final viviendaModel = viviendaModelFromJson(jsonString);

import 'dart:convert';

ViviendaModel viviendaModelFromJson(String str) =>
    ViviendaModel.fromJson(json.decode(str));

String viviendaModelToJson(ViviendaModel data) => json.encode(data.toJson());

class ViviendaModel {
  String name;
  String emailAddress;
  String pasword;
  String address;

  ViviendaModel({
    required this.name,
    required this.emailAddress,
    required this.pasword,
    required this.address,
  });

  factory ViviendaModel.fromJson(Map<String, dynamic> json) => ViviendaModel(
        name: json["NAME"],
        emailAddress: json["EMAIL_ADDRESS"],
        pasword: json["PASWORD"],
        address: json["ADDRESS"],
      );

  Map<String, dynamic> toJson() => {
        "NAME": name,
        "EMAIL_ADDRESS": emailAddress,
        "PASWORD": pasword,
        "ADDRESS": address,
      };
}
