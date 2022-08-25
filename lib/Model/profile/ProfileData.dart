// To parse this JSON data, do
//
//     final profileData = profileDataFromJson(jsonString);

import 'dart:convert';

class ProfileData {
  bool? success;
  Data? data;
  String? message;

  ProfileData({
    this.success,
    this.data,
    this.message,
  });

  factory ProfileData.fromRawJson(String str) => ProfileData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
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
  List<UserProfile>? userProfile;
  int? reward;
  int? scannedPosters;

  Data({
    this.userProfile,
    this.reward,
    this.scannedPosters,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userProfile: List<UserProfile>.from(json["user_profile"].map((x) => UserProfile.fromJson(x))),
    reward: json["reward"],
    scannedPosters: json["scanned_posters"],
  );

  Map<String, dynamic> toJson() => {
    "user_profile": List<dynamic>.from(userProfile!.map((x) => x.toJson())),
    "reward": reward,
    "scanned_posters": scannedPosters,
  };
}

class UserProfile {
  int? id;
  String? addressId;
  String? name;
  String? firstname;
  String? lastname;
  String? address;
  String? email;
  dynamic emailVerifiedAt;
  String? password;
  String? specialty;
  String? points;
  String? phone;
  String? profilePic;
  String? deviceId;
  int? isAdmin;
  dynamic rememberToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserProfile({
    this.id,
    this.addressId,
    this.name,
    this.firstname,
    this.lastname,
    this.address,
    this.email,
    this.emailVerifiedAt,
    this.password,
    this.specialty,
    this.points,
    this.phone,
    this.profilePic,
    this.deviceId,
    this.isAdmin,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromRawJson(String str) => UserProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json["id"],
    addressId: json["address_id"],
    name: json["name"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    address: json["address"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    password: json["password"],
    specialty: json["specialty"],
    points: json["points"],
    phone: json["phone"],
    profilePic: json["profile_pic"],
    deviceId: json["device_id"],
    isAdmin: json["is_admin"],
    rememberToken: json["remember_token"],
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
    "password": password,
    "specialty": specialty,
    "points": points,
    "phone": phone,
    "profile_pic": profilePic,
    "device_id": deviceId,
    "is_admin": isAdmin,
    "remember_token": rememberToken,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
