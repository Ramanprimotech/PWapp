import 'dart:convert';

class PointsData {
  bool? success;
  Data? data;
  String? message;

  PointsData({
    this.success,
    this.data,
    this.message,
  });

  factory PointsData.fromRawJson(String str) => PointsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PointsData.fromJson(Map<String, dynamic> json) => PointsData(
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

  Data({
    this.points,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    points: json["points"],
  );

  Map<String, dynamic> toJson() => {
    "points": points,
  };
}
