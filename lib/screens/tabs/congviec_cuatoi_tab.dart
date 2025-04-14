import 'package:ducanherp/blocs/nhom_nhan_vien/nhom_nhan_vien_bloc.dart';
import 'package:ducanherp/helpers/user_storage_helper.dart';
import 'package:ducanherp/models/application_user.dart';
import 'package:ducanherp/models/congvieccon_model.dart';
import 'package:ducanherp/models/nhomnhanvien_model.dart';
import 'package:ducanherp/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ducanherp/blocs/congviec/congviec_bloc.dart';
import 'package:ducanherp/blocs/congviec/congviec_state.dart';
import 'package:ducanherp/blocs/congviec/congviec_event.dart';
import 'package:ducanherp/models/congviec_model.dart';
import '../../widgets/list_cong_viec.dart';
import 'package:ducanherp/screens/them_congviec.dart';

class CongViecCuaToiTab extends StatefulWidget {
  const CongViecCuaToiTab({super.key});

  @override
  State<CongViecCuaToiTab> createState() => _CongViecCuaToiTabState();
}

class _CongViecCuaToiTabState extends State<CongViecCuaToiTab> {
  ApplicationUser? user;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final cachedUser = await UserStorageHelper.getCachedUserInfo();
    if (cachedUser != null) {
      setState(() {
        user = cachedUser;
      });
      final bloc = context.read<NhomNhanVienBloc>();
      final bloc1 = context.read<CongViecBloc>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bloc.add(
          LoadNhomNhanVien(
            groupId: user!.groupId,
            taiKhoan: user!.userName,
          ),
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bloc1.add(LoadAllCVC_Event());
      });
    }
  }

  CongViecModel buildCongViecModel(ApplicationUser user) {
    return CongViecModel(
      id: '',
      idNguoiGiaoViec: user.userName,
      nguoiThucHien: '',
      nhomCongViec: '',
      tenNhom: '',
      ngayBatDau: DateTime.now(),
      ngayKetThuc: DateTime.now(),
      mucDoUuTien: '',
      tuDanhGia: '',
      tienDo: 0,
      lapLai: '',
      noiDungCongViec: '',
      fileDinhKem: '',
      groupId: user.groupId,
      createAt: DateTime.now(),
      createBy: '',
      isActive: 1,
      pageNumber: 1,
      pageSize: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }
    final congViec = buildCongViecModel(user!);
    return _buildContent(congViec);
  }

  List<NhomNhanVienModel> nhoms = [];
  List<CongViecConModel> cvcs = [];
  NhomNhanVienModel? selectedNhom;

  Widget _buildContent(CongViecModel congViec) {
    return MultiBlocListener(
      listeners: [
        BlocListener<NhomNhanVienBloc, NhomNhanVienState>(
          listener: (context, state) {
            if (state is NhomNhanVienLoaded) {
              setState(() {
                nhoms = state.nhomNhanViens;
                if (nhoms.isNotEmpty) {
                  selectedNhom = nhoms.first;
                  congViec.nhomCongViec = nhoms.first.id;
                  context.read<CongViecBloc>().add(GetCongViecByVM(congViec));
                }
              });
              if (nhoms.isEmpty) {
                context.read<CongViecBloc>().add(GetCongViecByVM(buildCongViecModel(user!)));
              }
            }
          },
        ),
       
        BlocListener<CongViecBloc, CongViecState>(
          listener: (context, state) {
            if (state is CongViecLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Thêm công việc thành công!')),
              );
              context.read<CongViecBloc>().add(GetCongViecByVM(congViec));
              context.read<CongViecBloc>().add(LoadAllCVC_Event());
            }
            if (state is CongViecUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cập nhật công việc thành công!')),
              );
              context.read<CongViecBloc>().add(LoadAllCVC_Event());
            }
            if (state is LoadCVC) {
              setState(() {
                cvcs = state.cvcs;
              });
            }
            if (state is deleteCVC_State) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Xóa công việc con thành công!')),
              );

              context.read<CongViecBloc>().add(GetCongViecByVM(congViec));
              context.read<CongViecBloc>().add(LoadAllCVC_Event());
            }
            if (state is updateCVC_State) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cập nhật công việc con thành công!')),
              );
              context.read<CongViecBloc>().add(GetCongViecByVM(congViec));
              context.read<CongViecBloc>().add(LoadAllCVC_Event());
            }
            if (state is insertCVC_State) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Thêm công việc con thành công!')),
              );
              context.read<CongViecBloc>().add(GetCongViecByVM(congViec));
              context.read<CongViecBloc>().add(LoadAllCVC_Event());
            }
            
            if (state is CongViecError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Lỗi: ${state.message}')),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<CongViecBloc, CongViecState>(
        builder: (context, state) {
          if (state is CongViecInitial) {
            return nhoms.isEmpty 
                ? Center(
                    child: Text(
                      'Bạn không quản lý nhóm nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : Center(child: CircularProgressIndicator());
          }
          if (state is CongViecByVMLoaded) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: nhoms.length,
                        itemBuilder: (context, index) {
                          final isSelected = selectedNhom?.id == nhoms[index].id;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                 selectedNhom = nhoms[index];
                                 congViec.nhomCongViec = nhoms[index].id;
                                 context.read<CongViecBloc>().add(GetCongViecByVM(congViec));
                              });
                            },
                            child: Container(
                              width: 80,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blueAccent : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    nhoms[index].total.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    StringUtils.getInitials(nhoms[index].tenNhom),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: isSelected ? Colors.white70 : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                   
                    SizedBox(height: 10),
                    Expanded(
                      child: state.congViecs.isEmpty
                          ? Center(child: Text("Không có công việc nào."))
                          : ListCongViec(
                              items: state.congViecs,
                              item_cvcs: cvcs,
                              onRefresh: () async {
                                context.read<CongViecBloc>().add(GetCongViecByVM(congViec));
                              },
                            ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThemCongViec()),
                  ).then((shouldRefresh) {
                    if (shouldRefresh == true) {
                      context.read<CongViecBloc>().add(GetCongViecByVM(congViec));
                    }
                  });
                },
                backgroundColor: Colors.cyanAccent,
                elevation: 0,
                tooltip: 'Thêm công việc mới',
                child: Icon(Icons.add, size: 30, color: Color.fromARGB(255, 57, 11, 122)),
                shape: CircleBorder(),
              ),
            );
          }

          if (state is CongViecError) {
            return Center(child: Text('Đã xảy ra lỗi: ${state.message}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}