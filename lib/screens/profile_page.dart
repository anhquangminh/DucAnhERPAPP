import 'package:ducanherp/blocs/login_bloc.dart';
import 'package:ducanherp/helpers/user_storage_helper.dart';
import 'package:ducanherp/models/application_user.dart';
import 'package:ducanherp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isProfileExpanded = false;
  bool isSettingsExpanded = false;
  ApplicationUser? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    setState(() {
      user = cachedUser;
    });
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('expiration');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginBloc(),
            child: const LoginScreen(),
          ),
        ),
      );
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          :  SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user!.firstName} ${user!.lastName}'.trim(),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(user!.email, style: const TextStyle(color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Card(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent, // ✅ Bỏ border mặc định
                      ),
                      child: ExpansionTile(
                      leading: const Icon(Icons.person),
                      title: const Text('My Profile'),
                      trailing: Icon(isProfileExpanded ? Icons.expand_less : Icons.expand_more),
                      onExpansionChanged: (expanded) => setState(() => isProfileExpanded = expanded),
                      children: [
                        ListTile(
                          title: Text('Tên: ${user!.firstName} ${user!.lastName}'),
                          leading: const Icon(Icons.account_circle),
                        ),
                        ListTile(
                          title: Text('Email: ${user!.email}'),
                          leading: const Icon(Icons.email),
                        ),
                        ListTile(
                          title: Text('Phone: ${user!.phoneNumber}'),
                          leading: const Icon(Icons.phone),
                        ),
                        ListTile(
                          title: Text('Địa chỉ: ${user!.address}'),
                          leading: const Icon(Icons.location_on),
                        ),
                      ],
                    ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent, // ✅ Bỏ border mặc định
                    ),
                    child: ExpansionTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      trailing: Icon(isSettingsExpanded ? Icons.expand_less : Icons.expand_more),
                      onExpansionChanged: (expanded) => setState(() => isSettingsExpanded = expanded),
                      children: const [
                        ListTile(title: Text('Theme'), leading: Icon(Icons.format_paint)),
                        ListTile(title: Text('Settings'), leading: Icon(Icons.tune)),
                      ],
                    ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notification'),
                    trailing: DropdownButton<String>(
                      value: 'Allow',
                      items: ['Allow', 'Mute'].map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          print('Notification setting changed to: $value');
                        }
                      },
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Log Out'),
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ) 
    );
  }
}
