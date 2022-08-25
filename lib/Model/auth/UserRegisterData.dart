// To parse this JSON data, do
//
//     final userRegisterData = userRegisterDataFromJson(jsonString);

import 'dart:convert';

class UserRegisterData {
  bool? success;
  Data? data;
  String? message;

  UserRegisterData({
    this.success,
    this.data,
    this.message,
  });

  factory UserRegisterData.fromRawJson(String str) => UserRegisterData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserRegisterData.fromJson(Map<String, dynamic> json) => UserRegisterData(
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
  String? firstname;
  String? lastname;
  String? email;
  String? address;
  String? addressId;
  String? specialty;
  String? deviceId;
  String? phone;
  String? profilePic;
  String? points;
  int? isAdmin;
  String? name;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  AdminSetting? adminSetting;

  Data({
    this.firstname,
    this.lastname,
    this.email,
    this.address,
    this.addressId,
    this.specialty,
    this.deviceId,
    this.phone,
    this.profilePic,
    this.points,
    this.isAdmin,
    this.name,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.adminSetting,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    address: json["address"],
    addressId: json["address_id"],
    specialty: json["specialty"],
    deviceId: json["device_id"],
    phone: json["phone"],
    profilePic: json["profile_pic"],
    points: json["points"],
    isAdmin: json["is_admin"],
    name: json["name"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    adminSetting: AdminSetting.fromJson(json["admin_setting"]),
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "address": address,
    "address_id": addressId,
    "specialty": specialty,
    "device_id": deviceId,
    "phone": phone,
    "profile_pic": profilePic,
    "points": points,
    "is_admin": isAdmin,
    "name": name,
    "updated_at": updatedAt!.toIso8601String(),
    "created_at": createdAt!.toIso8601String(),
    "id": id,
    "admin_setting": adminSetting!.toJson(),
  };
}

class AdminSetting {
  String? platformName;
  String? platformKey;
  String? customerIdentifier;
  String? accountIdentifier;
  String? accountNumber;
  String? registerPoints;
  String? pointsForMoney;
  String? senderEmail;
  String? senderFirstname;
  String? senderLastname;
  String? etid;

  AdminSetting({
    this.platformName,
    this.platformKey,
    this.customerIdentifier,
    this.accountIdentifier,
    this.accountNumber,
    this.registerPoints,
    this.pointsForMoney,
    this.senderEmail,
    this.senderFirstname,
    this.senderLastname,
    this.etid,
  });

  factory AdminSetting.fromRawJson(String str) => AdminSetting.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdminSetting.fromJson(Map<String, dynamic> json) => AdminSetting(
    platformName: json["platform_name"],
    platformKey: json["platform_key"],
    customerIdentifier: json["customer_identifier"],
    accountIdentifier: json["account_identifier"],
    accountNumber: json["account_number"],
    registerPoints: json["register_points"],
    pointsForMoney: json["points_for_money"],
    senderEmail: json["sender_email"],
    senderFirstname: json["sender_firstname"],
    senderLastname: json["sender_lastname"],
    etid: json["etid"],
  );

  Map<String, dynamic> toJson() => {
    "platform_name": platformName,
    "platform_key": platformKey,
    "customer_identifier": customerIdentifier,
    "account_identifier": accountIdentifier,
    "account_number": accountNumber,
    "register_points": registerPoints,
    "points_for_money": pointsForMoney,
    "sender_email": senderEmail,
    "sender_firstname": senderFirstname,
    "sender_lastname": senderLastname,
    "etid": etid,
  };
}


class RegisterErrorData {
  bool? success;
  String? message;

  RegisterErrorData({
    this.success,
    this.message,
  });

  factory RegisterErrorData.fromRawJson(String str) => RegisterErrorData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterErrorData.fromJson(Map<String, dynamic> json) => RegisterErrorData(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
