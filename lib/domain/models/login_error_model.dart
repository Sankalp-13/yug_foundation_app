class LoginError {
  int? statusCode;
  String? message;
  String? error;

  LoginError({this.statusCode, this.message, this.error});

  LoginError.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}
