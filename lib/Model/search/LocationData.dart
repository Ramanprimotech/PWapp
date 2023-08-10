import 'dart:convert';

class LocationData {
  bool? success;
  List<Datum>? data;
  String? message;

  LocationData({
    this.success,
    this.data,
    this.message,
  });

  factory LocationData.fromRawJson(String str) => LocationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
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
  String? address1;
  String? company;
  String? city;
  String? state;
  String? unitLocationDesc;

  Datum({
    this.id,
    this.address1,
    this.company,
    this.city,
    this.state,
    this.unitLocationDesc,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    address1: json["address_1"],
    company: json["company"],
    city: json["city"],
    state: json["state"],
    unitLocationDesc: json["unit_location_desc"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address_1": address1,
    "company": company,
    "city": city,
    "state": state,
    "unit_location_desc": unitLocationDesc,
  };
}



class LocationDataError {
  bool? success;
  String? message;
  String? data;

  LocationDataError({
    this.success,
    this.message,
    this.data,
  });

  factory LocationDataError.fromRawJson(String str) => LocationDataError.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationDataError.fromJson(Map<String, dynamic> json) => LocationDataError(
    success: json["success"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data,
  };
}
