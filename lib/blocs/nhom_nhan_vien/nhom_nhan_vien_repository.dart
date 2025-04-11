import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/nhomnhanvien_model.dart';
import '../../models/api_response_model.dart';

class NhomNhanVienRepository {
  final http.Client client;
  final SharedPreferences prefs;

  NhomNhanVienRepository({required this.client, required this.prefs});

  Future<List<NhomNhanVienModel>> fetchNhomNhanVien({
    required String groupId,
    required String taiKhoan,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/NhomNhanVien/GetNhomNhanVienByTaiKhoanAsync?groupId=$groupId&taiKhoan=$taiKhoan',
    );
    
    final response = await client.get(
      uri,
      headers: _buildHeaders(token),
    );

    return _handleResponse(response);
  }

  Future<NhomNhanVienModel> addNhomNhanVien(NhomNhanVienModel model) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhomNhanVien');
    final response = await client.post(
      uri,
      headers: _buildHeaders(token),
      body: jsonEncode(model.toJson()),
    );

    return NhomNhanVienModel.fromJson(
      _handleResponse(response).first as Map<String, dynamic>,
    );
  }

  Future<void> deleteNhomNhanVien(String id) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhomNhanVien/$id');
    final response = await client.delete(
      uri,
      headers: _buildHeaders(token),
    );

    _handleResponse(response);
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  List<NhomNhanVienModel> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return (apiResponse.data as List)
            .map((e) => NhomNhanVienModel.fromJson(e))
            .toList();
      }
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }

  Future<List<NhomNhanVienModel>> getNhomNhanVienByVM(NhomNhanVienModel nhomNhanVien) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final request = http.Request(
      'POST',
      Uri.parse('${dotenv.env['API_URL']}/api/NhomNhanVien/GetByVM?groupId=${nhomNhanVien.groupId}'),
    );
    request.body = json.encode(nhomNhanVien.toJson());
    request.headers.addAll(headers);

    final response = await client.send(request);
    final responseBody = await http.Response.fromStream(response);

    return _handleResponse(responseBody);
  }

  Future<List<NhomNhanVienModel>> GetNhomNhanVienByCVDG(String groupId,String taiKhoan) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final request = http.Request(
      'GET',
      Uri.parse('${dotenv.env['API_URL']}/api/NhomNhanVien/GetNhomNhanVienByCVDGAsync?groupId=${groupId}&taiKhoan=${taiKhoan}'),
    );
    request.headers.addAll(headers);

    final response = await client.send(request);
    final responseBody = await http.Response.fromStream(response);

    return _handleResponse(responseBody);
  }
}
