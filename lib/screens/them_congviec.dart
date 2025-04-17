import 'package:ducanherp/blocs/congviec/congviec_event.dart';
import 'package:ducanherp/blocs/congviec/congviec_state.dart';
import 'package:ducanherp/blocs/download/download_bloc.dart';
import 'package:ducanherp/blocs/download/download_event.dart';
import 'package:ducanherp/blocs/download/download_state.dart';
import 'package:ducanherp/blocs/nhanvien/nhanvien_bloc.dart';
import 'package:ducanherp/blocs/notification/notification_bloc.dart';
import 'package:ducanherp/blocs/notification/notification_event.dart';
import 'package:ducanherp/widgets/custom_datepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:file_picker/file_picker.dart';

import '../../blocs/congviec/congviec_bloc.dart';
import '../../blocs/congviec/congviec_event.dart' as congviec_event;
import '../blocs/nhanvien/nhanvien_event.dart' as nhan_vien_event;
import '../blocs/nhanvien/nhanvien_state.dart';
import '../blocs/nhomnhanvien/nhomnhanvien_bloc.dart';
import '../../helpers/user_storage_helper.dart';
import '../../models/application_user.dart';
import '../../models/congviec_model.dart';
import '../models/nhanvien_model.dart';
import '../../models/nhomnhanvien_model.dart';
import '../../models/themngay_model.dart';
import '../models/nhanvienthuchien_model.dart';
import '../../widgets/custom_dropdown_form_field.dart';
import '../../widgets/custom_text_area.dart';

class ThemCongViec extends StatefulWidget {
  final CongViecModel? congViecToEdit;

  const ThemCongViec({super.key, this.congViecToEdit});

  @override
  State<ThemCongViec> createState() => _ThemCongViecState();
}

class _ThemCongViecState extends State<ThemCongViec> {
  final _formKey = GlobalKey<FormState>();
  ApplicationUser? user;
  List<String> groupNames = [];
  List<NhanVienModel> nhanviens = [];
  List<CongViecModel> existingTasks = [];
  // ignore: unused_field
  List<NhanVienModel> _selectedNhanViens = [];
  bool isLoadingGroups = true;
  bool isLoadingNhanviens = false;
  bool isLoadingTasks = true;
  String? fileName;
  bool isUploading = false;

  late final CongViecModel newTask;

  @override
  void initState() {
    super.initState();
    newTask = widget.congViecToEdit ??
        CongViecModel(
          id: '',
          idNguoiGiaoViec: '',
          nguoiThucHien: '',
          nhomCongViec: '',
          tenNhom: '',
          ngayBatDau: DateTime.now(),
          ngayKetThuc: DateTime.now().add(const Duration(days: 7)),
          mucDoUuTien: '',
          tuDanhGia: '',
          tienDo: 0,
          lapLai: '',
          noiDungCongViec: '',
          fileDinhKem: '',
          groupId: '',
          createAt: DateTime.now(),
          createBy: '',
          isActive: 1,
          pageNumber: 1,
          pageSize: 10,
        );
    if (widget.congViecToEdit != null) {
      newTask.nhomCongViec = widget.congViecToEdit!.nhomCongViec;
      newTask.fileDinhKem = widget.congViecToEdit!.fileDinhKem;
      context.read<NhanVienBloc>().add(nhan_vien_event.GetNhanVienByNhom(
            groupId: newTask.groupId,
            Id_NhomNhanVien: newTask.nhomCongViec,
          ));
    }
    initData();
  }

  ThemNgayModel themNgay = ThemNgayModel(
    id: '',
    idCongViec: '',
    idCongViecThemNgay: '',
    soNgay: 0,
    groupId: '',
    createAt: DateTime.now(),
    createBy: '',
    isActive: 1,
  );

  Future<void> initData() async {
    user = await UserStorageHelper.getCachedUserInfo();
    if (user == null) return;
    newTask.groupId = user!.groupId;
    newTask.idNguoiGiaoViec = user!.userName;
    newTask.createBy = user!.userName;
    context.read<NhomNhanVienBloc>().add(LoadNhomNhanVien(groupId: user!.groupId, taiKhoan: user!.userName));
    context.read<CongViecBloc>().add(congviec_event.GetCongViecByVM(newTask));
  }

  bool get isNhanvienselectEnabled => newTask.nhomCongViec.isNotEmpty;

  bool isValidCongViecModel(CongViecModel model) {
    return model.idNguoiGiaoViec.trim().isNotEmpty &&
        _selectedNhanViens.isNotEmpty &&
        model.nhomCongViec.trim().isNotEmpty &&
        model.mucDoUuTien.trim().isNotEmpty &&
        model.lapLai.trim().isNotEmpty &&
        model.noiDungCongViec.trim().isNotEmpty &&
        model.groupId.trim().isNotEmpty;
  }

  List<CongViecModel> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            newTask.id.isEmpty ? 'Thêm Công Việc' : 'Cập Nhật Công Việc',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              BlocConsumer<NhomNhanVienBloc, NhomNhanVienState>(
                listener: (context, state) {
                  if (state is NhomNhanVienError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi tải nhóm: ${state.message}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is NhomNhanVienLoaded) {
                    return CustomDropdownFormField<NhomNhanVienModel>(
                      label: 'Nhóm',
                      items: state.nhomNhanViens,
                      selectedId: newTask.nhomCongViec,
                      getId: (e) => e.id,
                      getLabel: (e) => e.tenNhom,
                      onChanged: (nnv) {
                        newTask.nhomCongViec = nnv?.id ?? '';
                        _selectedNhanViens = [];
                        context
                            .read<NhanVienBloc>()
                            .add(nhan_vien_event.GetNhanVienByNhom(
                              groupId: newTask.groupId,
                              Id_NhomNhanVien: newTask.nhomCongViec,
                            ));
                      },
                    );
                  }
                  return const LinearProgressIndicator();
                },
              ),
              SizedBox(height: 10),
              BlocListener<CongViecBloc, CongViecState>(
                listener: (context, congViecState) {
                  if (congViecState is getAllNVTHLoaded) {
                    final selectedIds = congViecState.nvths
                        .map((e) => e.idNhanVien)
                        .expand((ids) => ids.split(','))
                        .map((e) => e.trim())
                        .toSet();

                    _selectedNhanViens = nhanviens
                        .where((nv) => selectedIds.contains(nv.id))
                        .toList();

                    setState(() {});
                  }
                  if(congViecState is CongViecUpdated){
                    List<String> listId = _selectedNhanViens.map((e) => e.id).toList();
                     context.read<NotificationBloc>().add(
                            SendNotificationEvent(
                              title: "Thông báo mới",
                              body: "Công việc đã được cập nhật:${congViecState.congViec.noiDungCongViec}",
                              userIds: listId,
                            ),
                          );
                  }
                  if(congViecState is CongViecInsertSuccess){
                    List<String> listId = _selectedNhanViens.map((e) => e.id).toList();
                     context.read<NotificationBloc>().add(
                            SendNotificationEvent(
                              title: "Thông báo mới",
                              body: "Công việc đã được cập nhật:${newTask.noiDungCongViec}",
                              userIds: listId,
                            ),
                          );
                  }
                },
                child: BlocListener<NhanVienBloc, NhanVienState>(
                  listener: (context, state) {
                    if (state is NhanVienLoaded) {
                      nhanviens = state.nhanViens;
                      if (widget.congViecToEdit != null) {
                        final nvthModel = NhanVienThucHienModel(
                            id: '',
                            idCongViec: widget.congViecToEdit!.id,
                            idNhanVien: '',
                            createBy: user?.userName ?? '',
                            groupId: newTask.groupId,
                            createAt: DateTime.now(),
                            isActive: 1);
                        context.read<CongViecBloc>().add(congviec_event
                            .GetAllNVTH(newTask.groupId, nvthModel));
                      }
                      setState(() {});
                    } else if (state is NhanVienError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Lỗi nhân viên: ${state.message}')),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: AbsorbPointer(
                      absorbing: !isNhanvienselectEnabled,
                      child: Opacity(
                        opacity: isNhanvienselectEnabled ? 1 : 0.5,
                        child: MultiSelectDialogField<NhanVienModel>(
                          items: nhanviens
                              .map((e) => MultiSelectItem<NhanVienModel>(e, e.tenNhanVien))
                              .toList(),
                          title: Text("Chọn nhân viên"),
                          selectedColor: Colors.blue,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.blue, width: 1),
                          ),
                          buttonText: Text("Chọn nhân viên"),
                          initialValue: _selectedNhanViens,
                          onConfirm: (results) {
                            setState(() {
                              _selectedNhanViens = results.cast<NhanVienModel>();
                             if (_selectedNhanViens.isNotEmpty) {
                                  if(widget.congViecToEdit != null){
                                    items = [];
                                  }else{
                                    items = existingTasks.where((task) {
                                      final taskEmails = task.nguoiThucHien
                                          .split(',')
                                          .map((e) {
                                            final match = RegExp(r'\(([^)]+)\)').firstMatch(e);
                                            return match != null
                                                ? match.group(1)?.trim().toLowerCase()
                                                : null;
                                          })
                                          .whereType<String>()
                                          .toList();

                                      return _selectedNhanViens
                                          .any((nv) => taskEmails.contains(nv.taiKhoan.trim().toLowerCase()));
                                    }).toList();
                                  }
                                } else {
                                  items = [];
                                }
                            });
                          },
                          dialogHeight: MediaQuery.of(context).size.height * 0.5, // 50% chiều cao
                          listType: MultiSelectListType.LIST, // Cho scroll khi dài
                        ),

                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              CustomTextArea(
                label: 'Nội Dung Công Việc',
                onSaved: (v) => newTask.noiDungCongViec = v ?? '',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Vui lòng nhập nội dung' : null,
                initialValue: newTask.noiDungCongViec,
              ),
              SizedBox(height: 10),
              CustomDropdownFormField<String>(
                label: 'Mức Độ Ưu Tiên',
                items: const ['Thấp', 'Trung bình', 'Cao', 'Khẩn cấp'],
                selectedId: newTask.mucDoUuTien,
                getId: (e) => e,
                getLabel: (e) => e,
                onChanged: (val) => newTask.mucDoUuTien = val ?? '',
              ),
              SizedBox(height: 10),
              CustomDropdownFormField<String>(
                label: 'Lặp lại',
                items: [
                  'Hàng ngày',
                  'Hàng tuần',
                  'Hàng tháng',
                  'Không lặp lại'
                ],
                selectedId: newTask.lapLai,
                getId: (item) => item,
                getLabel: (item) => item,
                onChanged: (item) {
                  if (item != null) {
                    setState(() {
                      newTask.lapLai = item;
                    });
                  } else {
                    setState(() {
                      newTask.lapLai = "";
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              CustomDatePicker(
                label: 'Ngày bắt đầu',
                selectedDate: newTask.ngayBatDau,
                onDateSelected: (date) {
                  setState(() {
                    newTask.ngayBatDau = date;
                  });
                },
              ),
              SizedBox(height: 10),
              CustomDatePicker(
                label: 'Ngày Kết Thúc',
                selectedDate: newTask.ngayKetThuc,
                onDateSelected: (date) {
                  setState(() {
                    newTask.ngayKetThuc = date;
                  });
                },
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              SizedBox(height: 10),
              // Nút chọn file và icon tải file
              BlocListener<DownloadBloc, DownloadState>(
                listener: (context, state) {
                  if (state is DownloadSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("✅ Tải file thành công")),
                    );
                  } else if (state is DownloadFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("❌ Lỗi: ${state.error}")),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      child: const Text("Chọn file"),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result != null && result.files.single.path != null) {
                          final file = result.files.single;
                          context.read<CongViecBloc>().add(UploadFileEvent(file));
                        }
                      },
                    ),
                    if (newTask.fileDinhKem != "")
                      IconButton(
                        icon: Icon(Icons.download, size: 32),
                        onPressed: () {
                          final url = '${dotenv.env['API_URL']}${newTask.fileDinhKem}';
                          final fileName = newTask.fileDinhKem.split('/').last;

                          context.read<DownloadBloc>().add(
                                StartDownload(url, fileName),
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đang tải file...')),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Hiển thị trạng thái upload file
              BlocBuilder<CongViecBloc, CongViecState>(
                buildWhen: (previous, current) =>
                    current is CongViecLoading ||
                    current is UploadFile ||
                    current is CongViecError,
                builder: (context, state) {
                  Widget content = const SizedBox.shrink();
                  if (state is CongViecLoading) {
                    content = const SizedBox.shrink();
                  } else if (state is UploadFile) {
                    newTask.fileDinhKem = state.url;
                    content = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Đã upload: ${state.file.name}",
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    );
                  } else if (state is CongViecError) {
                    content = Text(
                      "Lỗi: ${state.message}",
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 10),
                    child: content,
                  );
                },
              ),


              SizedBox(height: 10),
              BlocConsumer<CongViecBloc, CongViecState>(
                listener: (context, state) {
                  if (state is CongViecByVMLoaded) {
                    setState(() {
                      existingTasks = state.congViecs;
                      isLoadingTasks = false;
                    });
                  } else if (state is CongViecError) {
                    setState(() {
                      isLoadingTasks = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Lỗi tải danh sách công việc: ${state.message}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (isLoadingTasks) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Thêm ngày cho công việc',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          LinearProgressIndicator(),
                        ],
                      ),
                    );
                  }
                  return _selectedNhanViens.isEmpty || items.isEmpty
                      ? SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdownFormField<CongViecModel>(
                              label: 'Thêm ngày cho công việc',
                              items: items,
                              selectedId: themNgay.idCongViecThemNgay,
                              getId: (task) => task.id,
                              getLabel: (task) => task.noiDungCongViec,
                              onChanged: (task) {
                                if (task != null) {
                                  setState(() {
                                    themNgay = themNgay.copyWith(
                                        idCongViecThemNgay: task.id);
                                  });
                                } else {
                                  setState(() {
                                    themNgay = themNgay.copyWith(
                                        idCongViecThemNgay: "");
                                  });
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            if (themNgay.idCongViecThemNgay != "")
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Số ngày thêm',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[1-9][0-9]*$'))
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng nhập số ngày';
                                  }
                                  final num = int.tryParse(value);
                                  if (num == null || num <= 0) {
                                    return 'Số ngày phải là số nguyên dương';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  final num = int.tryParse(value);
                                  setState(() {
                                    themNgay =
                                        themNgay.copyWith(soNgay: (num ?? 0));
                                  });
                                },
                              ),
                          ],
                        );
                },
              ),
              SizedBox(height: 10),
              BlocConsumer<CongViecBloc, CongViecState>(
                listener: (context, state) {
                  if (state is CongViecLoaded) {
                    Navigator.pop(context, true);
                  } else if (state is CongViecError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        if (!isValidCongViecModel(newTask)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Vui lòng điền đầy đủ thông tin!')),
                          );
                          return;
                        }

                        if (_selectedNhanViens.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Vui lòng chọn nhân viên thực hiện!')),
                          );
                          return;
                        }
                        final nhanVienIds = _selectedNhanViens.map((e) => e.id).toList();

                        if (widget.congViecToEdit != null) {
                          if (widget.congViecToEdit!.id.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Vui lòng chọn công việc để cập nhật!')),
                            );
                            return;
                          }
                          newTask.id = widget.congViecToEdit!.id;
                          context.read<CongViecBloc>().add(
                            congviec_event.UpdateCongViecEvent(
                              congViec: newTask,
                              themNgay: themNgay,
                              nhanViens: nhanVienIds,
                            ),
                          );
                        } else {
                          context.read<CongViecBloc>().add(
                            congviec_event.AddCongViec(
                              congViec: newTask,
                              themNgay: themNgay,
                              nhanViens: nhanVienIds,
                            ),
                          );
                          
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.congViecToEdit != null ? 'Cập nhật' : 'Thêm Công Việc',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  );
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
