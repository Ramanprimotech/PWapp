class ContactUsFailedResponse {
  bool? success;
  String? message;
  Data? data;

  ContactUsFailedResponse({this.success, this.message, this.data});

  ContactUsFailedResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<String>? deviceId;
  List<String>? name;
  List<String>? email;
  List<String>? phone;
  List<String>? message;

  Data({this.deviceId, this.name, this.email, this.phone, this.message});

  Data.fromJson(Map<String, dynamic> json) {
    deviceId = json['device_id'].cast<String>();
    name = json['name'].cast<String>();
    email = json['email'].cast<String>();
    phone = json['phone'].cast<String>();
    message = json['message'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['device_id'] = this.deviceId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['message'] = this.message;
    return data;
  }
}
