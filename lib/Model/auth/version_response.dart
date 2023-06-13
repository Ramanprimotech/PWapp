class VersionResponse {
  bool? success;
  String? version;

  VersionResponse({this.success, this.version});

  VersionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['version'] = this.version;
    return data;
  }
}