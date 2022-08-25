// To parse this JSON data, do
//
//     final specialityData = specialityDataFromJson(jsonString);

import 'dart:convert';

class SpecialityData {
  bool? success;
  List<Datum>? data;
  String? message;

  SpecialityData({
    this.success,
    this.data,
    this.message,
  });

  factory SpecialityData.fromRawJson(String str) => SpecialityData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SpecialityData.fromJson(Map<String, dynamic> json) => SpecialityData(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int? id;
  String? name;
  String? cmListId;

  Datum({
    this.id,
    this.name,
    this.cmListId,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    cmListId: json["cm_list_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "cm_list_id": cmListId,
  };
}
