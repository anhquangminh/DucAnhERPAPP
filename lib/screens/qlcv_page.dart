import 'package:ducanherp/blocs/permission/permission_bloc.dart';
import 'package:ducanherp/blocs/permission/permission_state.dart';
import 'package:ducanherp/screens/tabs/congviec_cuatoi_tab.dart';
import 'package:ducanherp/screens/tabs/congviec_duocgiao_tab.dart';
import 'package:ducanherp/screens/tabs/nhanvien_tab.dart';
import 'package:ducanherp/screens/tabs/nhomnhanvien_tab.dart';
import 'package:ducanherp/screens/tabs/quanlynhanvien_tab.dart';
import 'package:ducanherp/widgets/task_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QLCVPage extends StatefulWidget {
  const QLCVPage({super.key});

  @override
  State<QLCVPage> createState() => _QLCVPageState();
}

class _QLCVPageState extends State<QLCVPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionBloc, PermissionState>(
      builder: (context, state) {
        if (state is PermissionLoading || state is PermissionInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PermissionError) {
          return Center(child: Text('Lỗi: ${state.message}'));
        }

        if (state is PermissionLoaded) {
          // Kiểm tra từng quyền
          final hasPermission_CongViecCuaToi = state.permissions.any((p) =>
              p.majorId == "2105f7e7-1d45-4369-85a9-fdd185c3490b" &&
              p.permissionType == 1);

          final hasPermission_NhanVien = state.permissions.any((p) =>
              p.majorId == "abcdef12-3456-7890-abcd-ef1234567890" &&
              p.permissionType == 1);

          final hasPermission_NhomNhanVien = state.permissions.any((p) =>
              p.majorId == "b9100b9e-6be2-45fa-a85c-b1bfc6b313ba" &&
              p.permissionType == 1);
          
          final hasPermission_QuanLyNhanVien = state.permissions.any((p) =>
              p.majorId == "fcf752d9-c19a-496d-bba9-f0864928f32b" &&
              p.permissionType == 1);


          // Tạo danh sách tabs và labels động
          final tabs = <Widget>[];
          final tabLabels = <String>[];

          if (hasPermission_CongViecCuaToi) {
            tabs.add(CongViecCuaToiTab());
            tabLabels.add("Công việc của tôi");
          }

          tabs.add(CongViecDuocGiaoTab());
          tabLabels.add("Công việc được giao");

          if (hasPermission_NhanVien) {
            tabs.add(NhanVienTab());
            tabLabels.add("Nhân viên");
          }

          if (hasPermission_NhomNhanVien) {
            tabs.add(NhomnhanvienTab());
            tabLabels.add("Nhóm nhân viên");
          }

           if (hasPermission_QuanLyNhanVien) {
            tabs.add(QuanLyNhanVienTab());
            tabLabels.add("Quản lý nhân viên");
          }

          // Đảm bảo selected index không vượt quá số lượng tab
          if (_selectedTabIndex >= tabs.length) {
            _selectedTabIndex = 0;
          }

          return Scaffold(
            backgroundColor: Colors.blue[50],
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(tabLabels.length, (index) {
                        return Row(
                          children: [
                            TaskTab(
                              title: tabLabels[index],
                              isSelected: _selectedTabIndex == index,
                              onTap: () => setState(() {
                                _selectedTabIndex = index;
                              }),
                            ),
                            const SizedBox(width: 5),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(child: tabs[_selectedTabIndex]),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
