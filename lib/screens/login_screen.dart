import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/login_bloc.dart'; // Import the BLoC
import 'home_screen.dart'; // Import the HomeScreen

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

  bool _isPasswordVisible = false; // Biến để theo dõi trạng thái hiển thị mật khẩu
  bool _rememberMe = false; // Biến để theo dõi trạng thái checkbox

  bool isValidEmail(String email) {
    // Simple email validation regex
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isLoggedIn) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } 
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 100),
                SizedBox(height: 20),
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
                    Text('Lưu thông tin đăng nhập'),
                  ],
                ),
                SizedBox(height: 10),
                BlocBuilder<LoginBloc, LoginState>( 
                  builder: (context, state) {
                    return state.errorMessage != null 
                      ? Text(
                          state.errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        )
                      : SizedBox.shrink(); // Empty widget if no error
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    final email = emailController.text;
                    final password = passwordController.text;

                    setState(() {
                      emailError = null; // Reset email error
                      passwordError = null; // Reset password error
                    });

                    if (email.isEmpty) {
                      setState(() {
                        emailError = 'Email không được để trống!';
                      });
                      return;
                    } else if (!isValidEmail(email)) {
                      setState(() {
                        emailError = 'Email không hợp lệ';
                      });
                      return;
                    }

                    if (password.isEmpty) {
                      setState(() {
                        passwordError = 'Mật khẩu không được để trống!';
                      });
                      return;
                    }

                    // Dispatch login event
                    BlocProvider.of<LoginBloc>(context).add(LoginEvent(email, password));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.purple,
                  ),
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String label, TextEditingController controller, String? errorText, {bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            obscureText: obscureText && !_isPasswordVisible, // Kiểm tra trạng thái hiển thị mật khẩu
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.grey,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: obscureText // Thêm biểu tượng hiển thị mật khẩu
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible; // Chuyển đổi trạng thái hiển thị mật khẩu
                        });
                      },
                    )
                  : null,
            ),
          ),
          if (errorText != null) 
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                errorText,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}