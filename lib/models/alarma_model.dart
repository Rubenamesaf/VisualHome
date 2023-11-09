import 'dart:convert';

AlarmaModel alarmaModelFromJson(String str) =>
    AlarmaModel.fromJson(json.decode(str));

String alarmaModelToJson(AlarmaModel data) => json.encode(data.toJson());

class AlarmaModel {
  String id;
  bool active;
  int hours;
  int minutes;
  String time;

  AlarmaModel({
    required this.id,
    required this.active,
    required this.hours,
    required this.minutes,
    required this.time,
  });

  factory AlarmaModel.fromJson(Map<String, dynamic> json) => AlarmaModel(
        id: json["ID"],
        active: json["ACTIVE"],
        hours: json["HOURS"],
        minutes: json["MINUTES"],
        time: json["TIME"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "ACTIVE": active,
        "HOURS": hours,
        "MINUTES": minutes,
        "TIME": time,
      };
}
