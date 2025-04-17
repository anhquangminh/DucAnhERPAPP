import 'package:ducanherp/blocs/danhgia/danhgia_event.dart';
import 'package:ducanherp/blocs/danhgia/danhgia_state.dart';
import 'package:ducanherp/helpers/user_storage_helper.dart';
import 'package:ducanherp/utils/date_utils.dart';
import 'package:ducanherp/widgets/custom_dropdown_form_field.dart';
import 'package:ducanherp/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/danhgia/danhgia_bloc.dart';
import '../../models/application_user.dart';
import '../../models/congviec_model.dart';
import '../models/danhgia_model.dart';

class DanhGia extends StatefulWidget {
  final CongViecModel congViec;

  const DanhGia({super.key, required this.congViec});

  @override
  State<DanhGia> createState() => _DanhGiaState();
}

class _DanhGiaState extends State<DanhGia> {
  final _formKey = GlobalKey<FormState>();
  ApplicationUser? user;
  late DanhGiaModel danhgia = DanhGiaModel(
    id: '',
    idCongViec: widget.congViec.id,
    danhGia: 0,
    groupId: '',   // Sẽ gán lại sau khi load user
    createAt: DateTime.now(),
    createBy: '',  // Sẽ gán lại sau khi load user
    isActive: 1,
  );

 final TextEditingController _ghiChuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    user = await UserStorageHelper.getCachedUserInfo();
    if (user == null) return;
    // Gán lại giá trị groupId và createBy sau khi lấy được user
    danhgia.groupId = user!.groupId;
    danhgia.createBy = user!.userName;
    // Khởi tạo yêu cầu load đánh giá
    context.read<DanhGiaBloc>().add(
      LoadDanhGiaByIdCongViecEvent(
        widget.congViec.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đánh giá',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
              // Bảng hiển thị thông tin congViec với 2 cột: label và giá trị
              Table(
                columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
                border: TableBorder.all(color: Colors.grey),
                children: [
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Người giao việc:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.congViec.idNguoiGiaoViec),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Tên nhóm:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.congViec.tenNhom),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Nhân viên thực hiện:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.congViec.nguoiThucHien),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Nội dung công việc:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.congViec.noiDungCongViec),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Ngày (dd/MM/yy):',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${DateUtilsHelper.formatDateCustom(widget.congViec.ngayBatDau, "dd/MM/yy")} - ${DateUtilsHelper.formatDateCustom(widget.congViec.ngayKetThuc, "dd/MM/yy")}",
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Mức độ ưu tiên:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.congViec.mucDoUuTien),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Nhân viên tự đánh giá:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.congViec.tuDanhGia),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Tiến độ:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.congViec.tienDo.toString()),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomDropdownFormField<String>(
                            label: 'Đánh giá',
                            items: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
                            selectedId: danhgia.danhGia == 0 ? '' : danhgia.danhGia.toString(),
                            getId: (item) => item,
                            getLabel: (item) => "$item / 10",
                            onChanged: (value) => danhgia.danhGia = value == null ? 0 : int.parse(value),
                          ),
              const SizedBox(height: 10),
              CustomTextFormField(label:"Ghi chú",controller: _ghiChuController,),
              const SizedBox(height: 10),

              BlocConsumer<DanhGiaBloc, DanhGiaState>(
                listener: (context, state) {
                  if (state is DanhGiaLoaded) {
                    setState(() {
                      danhgia = state.danhGia;
                      _ghiChuController.text = danhgia.ghiChu ?? '';
                    });
                  } else if (state is DanhGiaError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is DanhGiaSuccess) {
                    Navigator.pop(context, true); // Quay lại màn hình trước đó
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      danhgia.ghiChu = _ghiChuController.text;
                      if (danhgia.id == "") {
                        context.read<DanhGiaBloc>().add(
                          CreateDanhGiaEvent(model: danhgia, userName: user!.userName),
                        );
                      } else {
                        context.read<DanhGiaBloc>().add(
                          UpdateDanhGiaEvent(model: danhgia, userName: user!.userName),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Đánh giá',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  );
                },
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
