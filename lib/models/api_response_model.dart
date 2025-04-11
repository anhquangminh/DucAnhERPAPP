class ApiResponseModel {
  final bool success;
  final String message;
  final dynamic data;

  ApiResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}
