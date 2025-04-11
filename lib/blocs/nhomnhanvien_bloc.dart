// import 'dart:convert';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import '../models/nhomnhanvien_model.dart';
// import '../models/api_response_model.dart';

// // Khai báo các sự kiện của Bloc
// abstract class NhomNhanVienEvent {}

// class LoadNhomNhanVien extends NhomNhanVienEvent {}

// abstract class NhomNhanVienState {}

// class NhomNhanVienLoading extends NhomNhanVienState {}

// class NhomNhanVienLoaded extends NhomNhanVienState {
//   final List<NhomNhanVienModel> nhomNhanViens;
//   NhomNhanVienLoaded(this.nhomNhanViens);
// }

// class NhomNhanVienError extends NhomNhanVienState {
//   final String message;
//   NhomNhanVienError(this.message);
// }

// class NhomNhanVienBloc extends Bloc<NhomNhanVienEvent, NhomNhanVienState> {
//   NhomNhanVienBloc() : super(NhomNhanVienLoading());

//   Stream<NhomNhanVienState> mapEventToState(NhomNhanVienEvent event) async* {
//     if (event is LoadNhomNhanVien) {
//       yield* _loadNhomNhanVien();
//     }
//   }

//   // Tạo method để load nhóm nhân viên
//   Stream<NhomNhanVienState> _loadNhomNhanVien() async* {
//     yield NhomNhanVienLoading();

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('token');

//       if (token == null) {
//         yield NhomNhanVienError("Token không tồn tại");
//         return;
//       }

//       final String groupId = '5a022928-fb56-49d8-bc8a-d69f2f3e2412';
//       final String taiKhoan = 'qminh97ictu@gmail.com';

//       var headers = {
//         'Authorization': 'Bearer $token',
//       };

//       final url = Uri.parse(
//         '${dotenv.env['API_URL']}/api/NhomNhanVien/GetNhomNhanVienByTaiKhoanAsync?groupId=$groupId&taiKhoan=$taiKhoan',
//       );

//       var response = await http.get(url, headers: headers);

//       if (response.statusCode == 200) {
//         final decodedJson = json.decode(response.body);
//         final ApiResponseModel apiResponse = ApiResponseModel.fromJson(decodedJson);

//         if (apiResponse.success) {
//           final List<NhomNhanVienModel> nhomNhanViens = (apiResponse.data as List)
//               .map((item) => NhomNhanVienModel.fromJson(item))
//               .toList();
//           yield NhomNhanVienLoaded(nhomNhanViens);
//         } else {
//           yield NhomNhanVienError("Không thể tải nhóm nhân viên");
//         }
//       } else {
//         yield NhomNhanVienError("Lỗi kết nối server: ${response.statusCode}");
//       }
//     } catch (e) {
//       yield NhomNhanVienError("Lỗi: ${e.toString()}");
//     }
//   }
// }
