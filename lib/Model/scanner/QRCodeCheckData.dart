import 'dart:convert';

class QrCodeCheckData {
  bool? success;
  List<Datum>? data;
  String? message;

  QrCodeCheckData({
    this.success,
    this.data,
    this.message,
  });

  factory QrCodeCheckData.fromRawJson(String str) => QrCodeCheckData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QrCodeCheckData.fromJson(Map<String, dynamic> json) => QrCodeCheckData(
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
  String? specialty;
  String? point;
  DateTime? expireAt;
  String? posterImage;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.name,
    this.specialty,
    this.point,
    this.expireAt,
    this.posterImage,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    specialty: json["specialty"],
    point: json["point"],
    expireAt: DateTime.parse(json["expire_at"]),
    posterImage: json["poster_image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "specialty": specialty,
    "point": point,
    "expire_at": expireAt!.toIso8601String(),
    "poster_image": posterImage,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}

// To parse this JSON data, do
//
//     final qrCodeMatchError = qrCodeMatchErrorFromJson(jsonString);
class QrCodeMatchError {
  bool? success;
  String? message;

  QrCodeMatchError({
    this.success,
    this.message,
  });

  factory QrCodeMatchError.fromRawJson(String str) => QrCodeMatchError.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QrCodeMatchError.fromJson(Map<String, dynamic> json) => QrCodeMatchError(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
