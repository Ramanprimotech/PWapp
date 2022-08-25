// To parse this JSON data, do
//
//     final userLoginData = userLoginDataFromJson(jsonString);

import 'dart:convert';

class UserLoginData {
  bool? success;
  Data? data;
  String? message;

  UserLoginData({
    this.success,
    this.data,
    this.message,
  });

  factory UserLoginData.fromRawJson(String str) => UserLoginData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserLoginData.fromJson(Map<String, dynamic> json) => UserLoginData(
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
  AdminSetting? adminSetting;

  Data({
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
    this.adminSetting,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    adminSetting: AdminSetting.fromJson(json["admin_setting"]),
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


class LoginFailData {
  bool? success;
  String? message;

  LoginFailData({
    this.success,
    this.message,
  });

  factory LoginFailData.fromRawJson(String str) => LoginFailData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginFailData.fromJson(Map<String, dynamic> json) => LoginFailData(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
