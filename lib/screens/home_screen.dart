import 'package:flutter/material.dart';
import 'qlcv_page.dart'; // Import HomePage
import 'settings_page.dart'; // Import SettingsPage
import 'profile_page.dart'; // Import ProfilePage

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    QLCVPage(), // Trang chính
    SettingsPage(), // Trang cài đặt
    ProfilePage(), // Trang hồ sơ
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Đức Anh',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          elevation: 4, // Tạo hiệu ứng nổi
          centerTitle: true, // Canh giữa tiêu đề
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white), // Icon menu
            onPressed: () {
              // Hành động khi nhấn vào menu
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.white), // Icon tìm kiếm
              onPressed: () {
                // Hành động khi nhấn tìm kiếm
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.white), // Icon thông báo
              onPressed: () {
                // Hành động khi nhấn thông báo
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // Bo góc phía dưới
            ),
          ),
        ),

      body: _pages[_selectedIndex], // Hiển thị trang tương ứng
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'QLCV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}