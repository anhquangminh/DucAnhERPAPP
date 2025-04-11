import 'dart:convert';
import 'dart:io';
import 'package:ducanherp/models/congvieccon_model.dart';
import 'package:ducanherp/models/nhanvienthuchien_model.dart';
import 'package:ducanherp/models/themngay_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/congviec_model.dart';
import '../../models/api_response_model.dart';

class CongViecRepository {
  final http.Client client;
  final SharedPreferences prefs;

  CongViecRepository({required this.client, required this.prefs});

  Future<List<CongViecModel>> fetchCongViec({
    required String groupId,
    required String nguoiThucHien,
  }) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
      '${dotenv.env['API_URL']}/api/CongViec/GetByVM?groupId=$groupId',
    );

    final response = await client.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        "NguoiThucHien": nguoiThucHien,
        "GroupId": groupId,
        // Các tham số khác
      }),
    );

    return _handleResponse(response);
  }

  Future<CongViecModel> addCongViec(CongViecModel congViec,
      ThemNgayModel themNgay, List<String> nhanVien) async {
    final url =
        Uri.parse('${dotenv.env['API_URL']}/api/CongViec/CreateCongViec');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString("token")}',
    };

    final body = {
      "congViec": congViec.toJson(),
      "nhanVienThucHien": nhanVien,
      "themNgay": themNgay.toJson(),
    };

    final request = http.Request('POST', url)
      ..headers.addAll(headers)
      ..body = jsonEncode(body);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Nếu là lỗi hệ thống như 404, 500 thì throw ngay
    if (response.statusCode >= 500 ||
        response.statusCode == 404 ||
        response.statusCode == 302) {
      throw Exception('Lỗi hệ thống: ${response.statusCode}');
    }

    try {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return CongViecModel.fromJson(apiResponse.data);
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      throw Exception('Lỗi phân tích response: $e');
    }
  }
  
  Future<String?> uploadFile(PlatformFile  file) async {
    try {
      final realFile = File(file.path!);
      final url = Uri.parse('${dotenv.env['API_URL']}/api/CongViec/upload');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("token")}',
      };

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('file', realFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
       // Nếu là lỗi hệ thống như 404, 500 thì throw ngay
      if (response.statusCode >= 500 ||
          response.statusCode == 404 ||
          response.statusCode == 302) {
        throw Exception('Lỗi hệ thống: ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return apiResponse.data;
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      throw Exception('Lỗi phân tích response: $e');
    }
  }

  Future<CongViecModel> updateCongViec(CongViecModel congViec,ThemNgayModel themNgay, List<String> nhanVien) async {
    try {
      final url = Uri.parse('${dotenv.env['API_URL']}/api/CongViec/UpdateCongViec?id=${congViec.id}');

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString("token")}',
      };

      final body = {
        "congViec": congViec.toJson(),
        "nhanVienThucHien": nhanVien,
        "themNgay": themNgay.toJson(),
      };

      final request = http.Request('PUT', url)
        ..headers.addAll(headers)
        ..body = jsonEncode(body);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Lỗi: ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return CongViecModel.fromJson(apiResponse.data);
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      throw Exception('Lỗi phân tích response: $e');
    }
  }

  Future<bool> deleteCongViec(String id) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final uri = Uri.parse(
        '${dotenv.env['API_URL']}/api/CongViec/$id?userName=${prefs.getString('userName')}');
    final response = await client.delete(
      uri,
      headers: _buildHeaders(token),
    );

    // Nếu là lỗi hệ thống như 404, 500 thì throw ngay
    if (response.statusCode >= 500 || response.statusCode == 404) {
      throw Exception('Lỗi hệ thống: ${response.statusCode}');
    }

    try {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return true;
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      throw Exception('Lỗi phân tích response: $e');
    }
  }

  Future<List<CongViecModel>> getCongViecByVM(CongViecModel congViec) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final request = http.Request(
      'POST',
      Uri.parse(
          '${dotenv.env['API_URL']}/api/CongViec/GetByVM?groupId=${congViec.groupId}'),
    );
    request.body = json.encode(congViec.toJson());
    request.headers.addAll(headers);

    final response = await client.send(request);
    final responseBody = await http.Response.fromStream(response);

    return _handleResponse(responseBody);
  }

  Future<List<NhanVienThucHienModel>> getAllNVTH(
      String groupId, NhanVienThucHienModel nvth) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final request = http.Request(
      'GET',
      Uri.parse(
          '${dotenv.env['API_URL']}/api/congviec/GetAllNVTH?groupId=$groupId'),
    );

    request.body = json.encode(nvth.toJson());
    request.headers.addAll(headers);

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        var a = (apiResponse.data as List)
            .map((e) => NhanVienThucHienModel.fromJson(e))
            .toList();
        return a;
      } else {
        throw Exception(apiResponse.message);
      }
    } else {
      throw Exception('Lỗi server: ${response.statusCode}');
    }
  }

  Future<List<CongViecConModel>> LoadCVCByIdCV(
      String id_CongViec) async {
    final String? token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final request = http.Request(
      'GET',
      Uri.parse(
          '${dotenv.env['API_URL']}/api/congviec/GetByIdCongViecCVC/$id_CongViec'),
    );
    request.headers.addAll(headers);

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return (apiResponse.data as List)
            .map((e) => CongViecConModel.fromJson(e))
            .toList();
      } else {
        throw Exception(apiResponse.message);
      }
    } else {
      throw Exception('Lỗi server: ${response.statusCode}');
    }
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  List<CongViecModel> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponseModel.fromJson(decoded);

      if (apiResponse.success) {
        return (apiResponse.data as List)
            .map((e) => CongViecModel.fromJson(e))
            .toList();
      }
      throw Exception(apiResponse.message);
    }
    throw Exception('Lỗi server: ${response.statusCode}');
  }
}
