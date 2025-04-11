import 'package:ducanherp/models/application_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import '../models/api_response_model.dart'; // Import the ApiResponseModel

class LoginEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class LogoutEvent {}

class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final String? token;
  final String? expiration;
  final bool isLoggedIn; // New field to indicate login status

  LoginState({this.isLoading = false, this.errorMessage, this.token, this.expiration, this.isLoggedIn = false});
}

class LoginBloc extends Bloc<dynamic, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginState(isLoading: true));
      
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('${dotenv.env['API_URL']}/api/user/Login')); // Use API_URL from .env
      request.body = json.encode({
        "Email": event.email,
        "Password": event.password,
        "RememberMe": true
      });
      request.headers.addAll(headers);

      try {
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var responseString = await response.stream.bytesToString();
          var jsonResponse = ApiResponseModel.fromJson(json.decode(responseString));
          
          if (jsonResponse.success == false) {
            emit(LoginState(errorMessage: jsonResponse.message)); // Emit error message if login fails
          } else {
            // Save token and expiration to shared preferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', jsonResponse.data['token']);
            await prefs.setString('expiration', jsonResponse.data['expiration']);

            // Gọi API lấy thông tin user
            final userInfoRequest = http.Request(
              'GET',
              Uri.parse('${dotenv.env['API_URL']}/api/ApplicationUser/getInforUser?userName=${event.email}'),
            );
            userInfoRequest.headers.addAll({
              'Authorization': 'Bearer ${jsonResponse.data['token']}',
              'Content-Type': 'application/json',
            });

            final userInfoResponse = await userInfoRequest.send();
             final response = await http.Response.fromStream(userInfoResponse);
            if (userInfoResponse.statusCode == 200) {
              final decoded = json.decode(response.body);
              final apiResponse = ApiResponseModel.fromJson(decoded);
              if (apiResponse.success == false) {
                emit(LoginState(errorMessage: apiResponse.message));
                return;
              }else{
                final applicationUser = ApplicationUser.fromJson(apiResponse.data);
                await prefs.setString('userInfo', json.encode(applicationUser.toJson()));
              }

              emit(LoginState(
                token: jsonResponse.data['token'],
                expiration: jsonResponse.data['expiration'],
                isLoggedIn: true,
              ));
            } else {
              emit(LoginState(errorMessage: 'Lấy thông tin user thất bại'));
            }
          }
        } else if(response.statusCode == 400){
           var responseString = await response.stream.bytesToString();
            var jsonResponse = ApiResponseModel.fromJson(json.decode(responseString));
            emit(LoginState(errorMessage: jsonResponse.message));
        }else {
          emit(LoginState(errorMessage: response.reasonPhrase));
        }
      } catch (e) {
        emit(LoginState(errorMessage: 'An error occurred: $e'));
      }
    });

    on<LogoutEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('expiration');
      emit(LoginState(isLoggedIn: false)); // Update login status
    });
  }
}
