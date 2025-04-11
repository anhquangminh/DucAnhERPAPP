import 'dart:convert';
import 'package:ducanherp/models/api_response_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/nhanvien_model.dart';

class NhanVienRepository {
  final http.Client client;
  final SharedPreferences prefs;

  NhanVienRepository({required this.client, required this.prefs});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<NhanVienModel>> fetchNhanVien({
    required String groupId,
    required String taiKhoan,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien?groupId=$groupId&taiKhoan=$taiKhoan');
    final response = await client.get(
      uri,
      headers: _buildHeaders(token),
    );

    final List<dynamic> data = json.decode(response.body);
    return data.map((e) => NhanVienModel.fromJson(e)).toList();
  }

  Future<NhanVienModel> addNhanVien(NhanVienModel nhanVien) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien');
    final response = await client.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode(nhanVien.toJson()),
    );

    return NhanVienModel.fromJson(json.decode(response.body));
  }

  Future<void> deleteNhanVien(String id) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien/$id');
    final response = await client.delete(
      uri,
      headers: _buildHeaders(token),
    );

    _handleResponse(response);
  }

  Future<List<NhanVienModel>> getNhanVienByVM(NhanVienModel nhanVien) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien/GetByVM?groupId=${nhanVien.groupId}');
    final response = await client.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode(nhanVien.toJson()),
    );

    return _handleResponse(response); // ✅ return giá trị
  }

  Future<List<NhanVienModel>> GetNhanVienByNhom({
    required String groupId,
    required String Id_NhomNhanVien,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse('${dotenv.env['API_URL']}/api/NhanVien/GetNhanVienByNhom?groupId=$groupId&Id_NhomNhanVien=$Id_NhomNhanVien');
    final response = await client.get(
      uri,
      headers: _buildHeaders(token),
    );

    return _handleResponse(response); // ✅ return giá trị
  }

  List<NhanVienModel> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return (apiResponse.data as List)
            .map((e) => NhanVienModel.fromJson(e))
            .toList();
      }
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}
