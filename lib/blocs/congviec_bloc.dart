// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/congviec_model.dart';
// import '../models/api_response_model.dart';

// class CongViecBloc extends Cubit<List<CongViecModel>> {
//   CongViecBloc() : super([]);

//   Future<void> addTask(CongViecModel task) async {
//     // Logic to add the task to the API or local storage
//     // This is a placeholder for the actual implementation
//     print('Task added: ${task.noiDungCongViec}');
//     // You may want to call fetchCongViec() again to refresh the task list
//   }

//   Future<void> fetchCongViec() async {
//     final prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');

//     var headers = {
//       'Content-Type': 'application/json',
//        'Authorization': 'Bearer ${token ?? ''}'
//     };

//     var request = http.Request(
//       'POST',
//       Uri.parse('${dotenv.env['API_URL']}/api/CongViec/GetByVM?groupId=5a022928-fb56-49d8-bc8a-d69f2f3e2412'),
//     );

//     request.body = json.encode({
//       "Id": "",
//       "id_NguoiGiaoViec": "",
//       "NguoiThucHien":"",
//       "NhomCongViec": "",
//       "TenNhom": "",
//       "NgayBatDau": null,
//       "NgayKetThuc": null,
//       "MucDoUuTien": "",
//       "TuDanhGia": "",
//       "TienDo": 0,
//       "LapLai": "",
//       "NoiDungCongViec": "",
//       "FileDinhKem": "",
//       "GroupId": "",
//       "CreateAt": "2023-10-10T00:00:00.000",
//       "CreateBy": "",
//       "IsActive": 1
//     });
//     request.headers.addAll(headers);

//     try {
//       http.StreamedResponse response = await request.send();
//       if (response.statusCode == 200) {
//         final responseData = await response.stream.bytesToString();
//         final Map<String, dynamic> decodedJson = json.decode(responseData);
//         final ApiResponseModel apiResponse = ApiResponseModel.fromJson(decodedJson);
        
//         if (apiResponse.success) {
//           final List<dynamic> jsonData = apiResponse.data;
//           final List<CongViecModel> congViecList =
//               jsonData.map((item) => CongViecModel.fromJson(item)).toList();
//           emit(congViecList);
//         } else {
//           emit([]);
//         }
//       } else {
//         print('Lỗi: ${response.reasonPhrase}');
//         emit([]);
//       }
//     } catch (e) {
//       print('Lỗi kết nối: $e');
//       emit([]);
//     }
//   }
// }
