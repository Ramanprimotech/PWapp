// To parse this JSON data, do
//
//     final dashboardData = dashboardDataFromJson(jsonString);

import 'dart:convert';

class DashboardData {
  bool? success;
  Data? data;
  String? message;

  DashboardData({
    this.success,
    this.data,
    this.message,
  });

  factory DashboardData.fromRawJson(String str) => DashboardData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data!.toJson(),
    "message": message,
  };
}

class Data {
  String? points;
  String? money;

  Data({
    this.points,
    this.money,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    points: json["points"],
    money: json["money"],
  );

  Map<String, dynamic> toJson() => {
    "points": points,
    "money": money,
  };
}
