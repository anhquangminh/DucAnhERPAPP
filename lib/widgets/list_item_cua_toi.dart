import 'package:ducanherp/blocs/congviec/congviec_event.dart' as congviec_event;
import 'package:ducanherp/blocs/download/download_bloc.dart';
import 'package:ducanherp/blocs/download/download_event.dart';
import 'package:ducanherp/blocs/download/download_state.dart';
import 'package:ducanherp/blocs/congviec/congviec_bloc.dart';
import 'package:ducanherp/blocs/congviec/congviec_event.dart';
import 'package:ducanherp/blocs/congviec/congviec_state.dart';
import 'package:ducanherp/models/themngay_model.dart';
import 'package:ducanherp/widgets/custom_dropdown_form_field.dart';
import 'package:ducanherp/widgets/custom_text_area.dart';
import 'package:ducanherp/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/models/congviec_model.dart';
import 'package:ducanherp/utils/date_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ListItemCuaToi extends StatelessWidget {
  final CongViecModel congViec;
  final Future<void> Function() onRefresh;

  const ListItemCuaToi({
    super.key,
    required this.congViec,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: () async {
          final result = await _showCongViecModal(context, congViec,onRefresh);
          if (result == null) {
            await onRefresh(); 
          }
        },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.work, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          congViec.noiDungCongViec,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                      SizedBox(width: 5),
                      Text(
                        DateUtilsHelper.formatDate(congViec.ngayBatDau),
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 10),
                      Text("–", style: TextStyle(color: Colors.grey)),
                      SizedBox(width: 10),
                      Text(
                        DateUtilsHelper.formatDate(congViec.ngayKetThuc),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      _buildPriorityChip(congViec.mucDoUuTien),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget hiển thị mức độ ưu tiên theo màu sắc
Widget _buildPriorityChip(String priority) {
  Color chipColor;
  String label;
  IconData icon;

  switch (priority) {
    case 'Thấp':
      chipColor = Colors.green;
      label = 'Thấp';
      icon = Icons.check_circle;
      break;
    case 'Trung bình':
      chipColor = Colors.orange;
      label = 'Trung bình';
      icon = Icons.warning;
      break;
    case 'Cao':
      chipColor = Colors.red;
      label = 'Cao';
      icon = Icons.priority_high;
      break;
    case 'Khẩn cấp':
      chipColor = Colors.purple;
      label = 'Khẩn cấp';
      icon = Icons.dangerous;
      break;
    default:
      chipColor = Colors.grey;
      label = 'Không xác định';
      icon = Icons.help_outline;
      break;
  }

  return Chip(
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.white),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
    backgroundColor: chipColor,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    elevation: 4,
  );
}

Future<bool?> _showCongViecModal(
  BuildContext context,
  CongViecModel congViec,
  Future<void> Function()? onRefresh,
) async {
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

  context.read<CongViecBloc>().add(LoadCVCByIdCVEvent(congViec.id));

  return await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BlocListener<CongViecBloc, CongViecState>(
        listener: (context, state) {
          if (state is CongViecUpdated) {
            Navigator.pop(context, true);
            if (onRefresh != null) onRefresh();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('✅ Cập nhật công việc thành công')),
            );
          } else if (state is CongViecError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ Lỗi: ${state.message}')),
            );
          }
        },
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Chi tiết công việc', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () async {
                          Navigator.pop(context, true);
                          if (onRefresh != null) await onRefresh();
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          CustomTextArea(
                            initialValue: congViec.noiDungCongViec,
                            label: 'Nội dung công việc',
                            enabled: false,
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            label: 'Người giao việc',
                            controller: TextEditingController(text: congViec.idNguoiGiaoViec),
                            enabled: false,
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            label: 'Tên nhóm',
                            controller: TextEditingController(text: congViec.tenNhom),
                            enabled: false,
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            label: 'Ngày bắt đầu',
                            controller: TextEditingController(text: congViec.ngayBatDau.toString()),
                            enabled: false,
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            label: 'Ngày kết thúc',
                            controller: TextEditingController(text: congViec.ngayKetThuc.toString()),
                            enabled: false,
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            label: 'Mức độ ưu tiên',
                            controller: TextEditingController(text: congViec.mucDoUuTien.toString()),
                            enabled: false,
                          ),
                          BlocListener<DownloadBloc, DownloadState>(
                            listener: (context, state) {
                              if (state is DownloadSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Tải file thành công")));
                              } else if (state is DownloadFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Lỗi download")));
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tệp đính kèm"),
                                if (congViec.fileDinhKem != "")
                                  IconButton(
                                    icon: Icon(Icons.download),
                                    onPressed: () {
                                      final url = '${dotenv.env['API_URL']}${congViec.fileDinhKem}';
                                      final fileName = congViec.fileDinhKem.split('/').last;
                                      context.read<DownloadBloc>().add(StartDownload(url, fileName));
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đang tải file...')));
                                    },
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          BlocBuilder<CongViecBloc, CongViecState>(
                            builder: (context, state) {
                              if (state is LoadCVCByIdCV && state.cvcs.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Danh sách công việc con', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    SizedBox(height: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Table(
                                        columnWidths: {
                                          0: FixedColumnWidth(40),
                                          1: FlexColumnWidth(2),
                                          2: FlexColumnWidth(2),
                                          3: FixedColumnWidth(80),
                                        },
                                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(color: Colors.blue.shade100),
                                            children: [
                                              tableCell('STT', isHeader: true),
                                              tableCell('Tên công việc', isHeader: true),
                                              tableCell('Tệp đính kèm', isHeader: true),
                                              tableCell('Hoàn thành', isHeader: true),
                                            ],
                                          ),
                                          ...state.cvcs.asMap().entries.map((entry) {
                                            final cvc = entry.value;
                                            return TableRow(
                                              decoration: BoxDecoration(
                                                color: entry.key % 2 == 0 ? Colors.grey.shade100 : Colors.white,
                                              ),
                                              children: [
                                                tableCell('${entry.key + 1}'),
                                                tableCell(cvc.noiDungCongViec),
                                                cvc.fileDinhKem != null && cvc.fileDinhKem!.isNotEmpty
                                                  ? tableCellWithIcon(
                                                      cvc.fileDinhKem!.split('/').last,
                                                      icon: Icons.download,
                                                      onTap: () {
                                                        final url = '${dotenv.env['API_URL']}${cvc.fileDinhKem}';
                                                        final fileName = cvc.fileDinhKem!.split('/').last;
                                                        context.read<DownloadBloc>().add(StartDownload(url, fileName));
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đang tải file...')));
                                                      },
                                                    )
                                                  : tableCell(''),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Checkbox(
                                                    value: cvc.hoanThanh == 1,
                                                    onChanged: (bool? value) {
                                                      // Toggle giá trị
                                                      cvc.hoanThanh = value == true ? 1 : 0;
                                                      // Gọi setState nếu cần cập nhật UI (nếu trong StatefulWidget)
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                );
                              } else if (state is CongViecError) {
                                return Text('Lỗi: ${state.message}');
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                          ),
                          CustomTextFormField(
                            label: 'Tự đánh giá',
                            controller: TextEditingController(text: congViec.tuDanhGia == '' ? '' : congViec.tuDanhGia.toString()),
                            onChanged: (value) => congViec.tuDanhGia = value,
                          ),
                          SizedBox(height: 10),
                          CustomDropdownFormField<String>(
                            label: 'Tiến độ',
                            items: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
                            selectedId: congViec.tienDo == 0 ? '' : congViec.tienDo.toString(),
                            getId: (item) => item,
                            getLabel: (item) => "$item / 10",
                            onChanged: (value) => congViec.tienDo = value == null ? 0 : int.parse(value),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context, true);
                                  if (onRefresh != null) await onRefresh();
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                child: Text('Hủy'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<CongViecBloc>().add(
                                        congviec_event.UpdateCongViecEvent(
                                          congViec: congViec,
                                          themNgay: themNgay,
                                          nhanViens: [],
                                        ),
                                      );
                                },
                                child: Text('Lưu'),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget tableCell(String text, {bool isHeader = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        fontSize: 14,
        color: isHeader ? Colors.black87 : Colors.black,
      ),
    ),
  );
}

Widget tableCellWithIcon(
  String text, {
  IconData? icon,
  Color? color,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: Row(
      children: [
        if (icon != null)
          GestureDetector(
            onTap: onTap,
            child: Icon(icon, size: 20, color: color ?? Colors.blue),
          ),
        if (text.isNotEmpty) ...[
          SizedBox(width: 6),
          Expanded(
            child: Text(text, overflow: TextOverflow.ellipsis),
          ),
        ],
      ],
    ),
  );
}