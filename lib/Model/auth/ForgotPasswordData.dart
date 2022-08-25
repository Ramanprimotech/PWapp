import 'dart:convert';

class ForgotPasswordData {
  bool? success;
  List<Datum>? data;
  String? message;

  ForgotPasswordData({
    this.success,
    this.data,
    this.message,
  });

  factory ForgotPasswordData.fromRawJson(String str) =>
      ForgotPasswordData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordData(
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
  String? addressId;
  String? name;
  String? firstname;
  String? lastname;
  String? address;
  String? email;
  dynamic emailVerifiedAt;
  String? specialty;
  String? points;
  String? phone;
  String? profilePic;
  String? deviceId;
  int? isAdmin;
  int? isFirst;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.addressId,
    this.name,
    this.firstname,
    this.lastname,
    this.address,
    this.email,
    this.emailVerifiedAt,
    this.specialty,
    this.points,
    this.phone,
    this.profilePic,
    this.deviceId,
    this.isAdmin,
    this.isFirst,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        addressId: json["address_id"],
        name: json["name"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        address: json["address"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        specialty: json["specialty"],
        points: json["points"],
        phone: json["phone"],
        profilePic: json["profile_pic"],
        deviceId: json["device_id"],
        isAdmin: json["is_admin"],
        isFirst: json["is_first"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address_id": addressId,
        "name": name,
        "firstname": firstname,
        "lastname": lastname,
        "address": address,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "specialty": specialty,
        "points": points,
        "phone": phone,
        "profile_pic": profilePic,
        "device_id": deviceId,
        "is_admin": isAdmin,
        "is_first": isFirst,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class ForgotPasswordErrorData {
  bool? success;
  String? message;

  ForgotPasswordErrorData({
    this.success,
    this.message,
  });

  factory ForgotPasswordErrorData.fromRawJson(String str) =>
      ForgotPasswordErrorData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForgotPasswordErrorData.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordErrorData(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
