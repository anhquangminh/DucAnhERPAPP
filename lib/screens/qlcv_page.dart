import 'package:flutter/material.dart';

import '../widgets/task_tab.dart';
import '../screens/tabs/congviec_cuatoi_tab.dart';
import '../screens/tabs/congviec_duocgiao_tab.dart';

class QLCVPage extends StatefulWidget {
  const QLCVPage({super.key});

  @override
  _QLCVPageState createState() => _QLCVPageState();
}

class _QLCVPageState extends State<QLCVPage> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabs = [
    CongViecCuaToiTab(),
    CongViecDuocGiaoTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TaskTab(
                      title: 'Công việc của tôi',
                      isSelected: _selectedTabIndex == 0,
                      onTap: () => setState(() => _selectedTabIndex = 0),
                    ),
                    SizedBox(width: 5),
                    TaskTab(
                      title: 'Công việc được giao',
                      isSelected: _selectedTabIndex == 1,
                      onTap: () => setState(() => _selectedTabIndex = 1),
                    ),
                  ],
                ),
              ),
              Expanded(child: _tabs[_selectedTabIndex]),
            ],
          ),
        ),
      );
  }
}
