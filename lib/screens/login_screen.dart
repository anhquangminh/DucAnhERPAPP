import 'dart:convert';

import 'package:ducanherp/blocs/notification/notification_bloc.dart';
import 'package:ducanherp/blocs/notification/notification_event.dart';
import 'package:ducanherp/blocs/permission/permission_bloc.dart';
import 'package:ducanherp/blocs/permission/permission_event.dart';
import 'package:ducanherp/blocs/permission/permission_state.dart';
import 'package:ducanherp/helpers/user_storage_helper.dart';
import 'package:ducanherp/screens/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? passwordError;

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }


  void _loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email') ?? '';
    final savedPassword = prefs.getString('saved_password') ?? '';
    final remember = prefs.getBool('remember_me') ?? false;

    setState(() {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
      _rememberMe = remember;
    });
  }

  Future<void> _saveLoginInfoIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', emailController.text);
      await prefs.setString('saved_password', passwordController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state.isLoggedIn) {
            await _saveLoginInfoIfNeeded();

            final fcmToken = await FirebaseMessaging.instance.getToken();
            final user = await UserStorageHelper.getCachedUserInfo();

            if (fcmToken != null && user != null && user.id.isNotEmpty && user.groupId != "") {
              context.read<NotificationBloc>().add(
                RegisterTokenEvent(
                  token: fcmToken,
                  groupId: user.groupId,
                  userId: user.id,
                ),
              );

              final permissionBloc = BlocProvider.of<PermissionBloc>(context);
              permissionBloc.add(FetchPermissions(
                groupId: user.groupId,
                userId: user.id,
                parentMajorId: "249ff511-8f10-45e8-bf8f-29b0ada5ab84",
              ));

              permissionBloc.stream.firstWhere((permState) => permState is PermissionLoaded).then((permState) async {
                final permissions = (permState as PermissionLoaded).permissions;

                final prefs = await SharedPreferences.getInstance();
                final permissionJsonList = permissions.map((p) => jsonEncode(p.toJson())).toList();
                await prefs.setStringList('permissions', permissionJsonList);

                final now = DateTime.now();
                await prefs.setString('permissions_date', now.toIso8601String());

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              });

            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 100),
              const SizedBox(height: 20),
              buildTextField(Icons.email, 'Email', emailController, emailError),
              buildTextField(Icons.lock, 'Password', passwordController, passwordError, obscureText: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    },
                  ),
                  const Text('Lưu thông tin đăng nhập'),
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return state.errorMessage != null
                      ? Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                        )
                      : const SizedBox.shrink();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;

                  setState(() {
                    emailError = null;
                    passwordError = null;
                  });

                  if (email.isEmpty) {
                    setState(() => emailError = 'Email không được để trống!');
                    return;
                  } else if (!isValidEmail(email)) {
                    setState(() => emailError = 'Email không hợp lệ');
                    return;
                  }

                  if (password.isEmpty) {
                    setState(() => passwordError = 'Mật khẩu không được để trống!');
                    return;
                  }

                  BlocProvider.of<LoginBloc>(context).add(LoginEvent(email, password));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: Colors.purple,
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    IconData icon,
    String label,
    TextEditingController controller,
    String? errorText, {
    bool obscureText = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            obscureText: obscureText && !_isPasswordVisible,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: obscureText
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
              errorText: errorText,
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                errorText,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
