import 'dart:convert';
import 'package:ducanherp/models/api_response_model.dart';
import 'package:ducanherp/models/danhgia_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DanhGiaRepository {
  final SharedPreferences prefs;

  DanhGiaRepository(this.prefs);

  Future<Map<String, String>> _buildHeaders() async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  Future<DanhGiaModel> getByIdCongViec(String idCongViec) async {
    final String baseUrl = dotenv.env['API_URL']!;
    final uri = Uri.parse('$baseUrl/api/danhgia/GetByIdCongViec?idCongViec=$idCongViec');

    final headers = await _buildHeaders();
    final request = http.Request('GET', uri)
      ..headers.addAll(headers);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Future<DanhGiaModel> create(DanhGiaModel model, String userName) async {
    final String baseUrl = dotenv.env['API_URL']!;
    final uri = Uri.parse('$baseUrl/api/danhgia?userName=$userName');

    final headers = await _buildHeaders();
    final request = http.Request('POST', uri)
      ..headers.addAll(headers)
      ..body = jsonEncode(model.toJson());

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Future<DanhGiaModel> update(DanhGiaModel model, String userName) async {
    final String baseUrl = dotenv.env['API_URL']!;
    final uri = Uri.parse('$baseUrl/api/danhgia/${model.id}?userName=$userName');

    final headers = await _buildHeaders();
    final request = http.Request('PUT', uri)
      ..headers.addAll(headers)
      ..body = jsonEncode(model.toJson());

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }
  
  Future<DanhGiaModel> getById(String id) async {
    final String baseUrl = dotenv.env['API_URL']!;
    final uri = Uri.parse('$baseUrl/api/danhgia/$id');

    final headers = await _buildHeaders();
    final request = http.Request('GET', uri)..headers.addAll(headers);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Future<DanhGiaModel> _handleResponse(http.Response response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return DanhGiaModel.fromJson(apiResponse.data);
      }
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}
