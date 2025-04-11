import 'package:ducanherp/blocs/congviec/congviec_bloc.dart';
import 'package:ducanherp/blocs/download/download_bloc.dart';
import 'package:ducanherp/blocs/nhan_vien/nhan_vien_bloc.dart';
import 'package:ducanherp/blocs/nhan_vien/nhan_vien_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/login_bloc.dart';
import 'blocs/nhom_nhan_vien/nhom_nhan_vien_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  final client = http.Client();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: prefs),
        Provider<http.Client>.value(value: client),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => CongViecBloc(
          client: context.read<http.Client>(),
          prefs: context.read<SharedPreferences>(),
        )),
        BlocProvider(
          create: (context) => NhomNhanVienBloc(
            client: context.read<http.Client>(),
            prefs: context.read<SharedPreferences>(),
          ),
          lazy: false, // Ensure bloc is created immediately
        ),
        BlocProvider(create: (context) => NhanVienBloc(
          repository: NhanVienRepository(
            client: context.read<http.Client>(),
            prefs: context.read<SharedPreferences>(),
          ),
        )),
        BlocProvider(create: (context) => DownloadBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ducanherp',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LoginCheck(),
    );
  }
}

class LoginCheck extends StatelessWidget {
  const LoginCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginState>(
      future: _loadLoginState(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final state = snapshot.data!;
          if (state.token != null && state.expiration != null) {
            DateTime expirationDate = DateTime.parse(state.expiration!);
            if (expirationDate.isAfter(DateTime.now())) {
              return HomeScreen();
            }
          }
        }
        return LoginScreen();
      },
    );
  }

  Future<LoginState> _loadLoginState(BuildContext context) async {
    final prefs = context.read<SharedPreferences>();
    String? token = prefs.getString('token');
    String? expiration = prefs.getString('expiration');
    return LoginState(token: token, expiration: expiration);
  }
}

class LoginState {
  final String? token;
  final String? expiration;

  LoginState({required this.token, required this.expiration});
}
