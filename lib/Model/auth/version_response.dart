class VersionResponse {
  bool? success;
  String? message;
  String? version;

  VersionResponse({this.success, this.message, this.version});

  @override
  String toString() {
    return 'VersionResponse{success: $success, message: $message, version: $version}';
  }

  VersionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['version'] = this.version;
    return data;
  }
}

