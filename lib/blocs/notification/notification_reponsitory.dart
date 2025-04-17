import 'dart:convert';
import 'package:ducanherp/helpers/user_storage_helper.dart';
import 'package:ducanherp/models/api_response_model.dart';
import 'package:ducanherp/models/notification_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepository {
  final http.Client client;
  final SharedPreferences prefs;

  NotificationRepository({required this.client, required this.prefs});

  // Hàm xây dựng headers với token
  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Phương thức gửi thông báo
  Future<String> sendNotification({
    required List<String> userIds,
    required String title,
    required String body,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/fcm/send-notification');
    final response = await client.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        'userIds': userIds,
        'title': title,
        'body': body,
      }),
    );

    return  _handleResponse(response);
  }

  // Phương thức đăng ký token FCM
  Future<String> registerToken({
    required String token,
    required String groupId,
    required String userId,
  }) async {
    final String? authToken = prefs.getString('token');
    if (authToken == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/fcm/register-token');
    final response = await client.post(
      uri,
      headers: _buildHeaders(authToken),
      body: json.encode({
        'token': token,
        'groupId': groupId,
        'userId': userId,
      }),
    );

    return _handleResponse(response);
  }

  Future<List<NotificationModel>>  getAllNotiByUser() async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    final uri = Uri.parse('${dotenv.env['API_URL']}/api/fcm/GetAllNotiByUser?userName=${cachedUser?.userName}');
    final response = await client.get(
      uri,
      headers: _buildHeaders(token),
    );
    if (response. statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
       
         return (apiResponse.data as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
      }
      throw Exception(apiResponse.message); 
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }

  Future<NotificationModel> updateNotification({required NotificationModel notifi})
   async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final uri = Uri.parse('${dotenv.env['API_URL']}/api/fcm/Update');
    final response = await client.put(
      uri,
      headers: _buildHeaders(token),
      body: jsonEncode(notifi)
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
          return NotificationModel.fromJson(apiResponse.data);
      }
      throw Exception(apiResponse.message); 
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }

  Future<NotificationModel> getAllCategoriesByUser() async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    final uri = Uri.parse('${dotenv.env['API_URL']}/api/fcm/GetAllCategoriesByUser?userName=${cachedUser?.userName}');
    final response = await client.get(
      uri,
      headers: _buildHeaders(token),
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return apiResponse.data.map((e) => NotificationModel.fromJson(e)).toList();
      }
      throw Exception(apiResponse.message); 
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }

  // Xử lý phản hồi từ server
  String _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return apiResponse.message; // Trả về thông báo thành công
      }
      throw Exception(apiResponse.message); // Thông báo lỗi từ server
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}
