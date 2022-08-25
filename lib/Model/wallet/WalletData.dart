// To parse this JSON data, do
//
//     final walletData = walletDataFromJson(jsonString);

import 'dart:convert';

class WalletData {
  bool? success;
  List<Datum>? data;
  String? message;

  WalletData({
    this.success,
    this.data,
    this.message,
  });

  factory WalletData.fromRawJson(String str) => WalletData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
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
  int? userId;
  int? qrCodeId;
  String? name;
  String? specialty;
  String? points;
  String? catgory;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? posterImage;
  String? fisrtname;
  String? lastname;
  String? email;
  String? amount;
  String? tcOrderId;
  String? redemptionLink;

  Datum({
    this.id,
    this.userId,
    this.qrCodeId,
    this.name,
    this.specialty,
    this.points,
    this.catgory,
    this.createdAt,
    this.updatedAt,
    this.posterImage,
    this.fisrtname,
    this.lastname,
    this.email,
    this.amount,
    this.tcOrderId,
    this.redemptionLink,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    qrCodeId: json["qr_code_id"] == null ? null : json["qr_code_id"],
    name: json["name"] == null ? null : json["name"],
    specialty: json["specialty"] == null ? null : json["specialty"],
    points: json["points"],
    catgory: json["catgory"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    posterImage: json["poster_image"] == null ? null : json["poster_image"],
    fisrtname: json["fisrtname"] == null ? null : json["fisrtname"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    email: json["email"] == null ? null : json["email"],
    amount: json["amount"] == null ? null : json["amount"],
    tcOrderId: json["tc_order_id"] == null ? null : json["tc_order_id"],
    redemptionLink: json["redemption_link"] == null ? null : json["redemption_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "qr_code_id": qrCodeId == null ? null : qrCodeId,
    "name": name == null ? null : name,
    "specialty": specialty == null ? null : specialty,
    "points": points,
    "catgory": catgory,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "poster_image": posterImage == null ? null : posterImage,
    "fisrtname": fisrtname == null ? null : fisrtname,
    "lastname": lastname == null ? null : lastname,
    "email": email == null ? null : email,
    "amount": amount == null ? null : amount,
    "tc_order_id": tcOrderId == null ? null : tcOrderId,
    "redemption_link": redemptionLink == null ? null : redemptionLink,
  };
}
