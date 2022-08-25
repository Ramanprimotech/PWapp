// To parse this JSON data, do
//
//     final moneyData = moneyDataFromJson(jsonString);

import 'dart:convert';

class MoneyData {
  bool? success;
  Data? data;
  String? message;

  MoneyData({
    this.success,
    this.data,
    this.message,
  });

  factory MoneyData.fromRawJson(String str) => MoneyData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MoneyData.fromJson(Map<String, dynamic> json) => MoneyData(
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
  String? money;

  Data({
    this.money,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    money: json["money"],
  );

  Map<String, dynamic> toJson() => {
    "money": money,
  };
}
