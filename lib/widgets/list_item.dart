import 'package:flutter/material.dart';
import 'package:ducanherp/models/congviec_model.dart';
import 'package:ducanherp/utils/date_utils.dart';

class ListItem extends StatelessWidget {
  final CongViecModel congViec;
  final Function(BuildContext) onEdit;
  final Function(BuildContext) onDelete;

  const ListItem({
    super.key,
    required this.congViec,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Đảm bảo chiều rộng xác định
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Để nội dung không bị lỗi giới hạn kích thước
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nội dung công việc với icon
                Row(
                  children: [
                    Icon(Icons.work, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        congViec.noiDungCongViec,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis, // Tránh tràn chữ
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),

                // Ngày bắt đầu - Ngày kết thúc
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

                // Mức độ ưu tiên
                Row(
                  children: [
                    _buildPriorityChip(congViec.mucDoUuTien),
                  ],
                ),
              ],
            ),
          ),

          // Menu chức năng (Sửa/Xóa)
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                onEdit(context);
              } else if (value == 'delete') {
                onDelete(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
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
        Icon(icon, size: 20, color: Colors.white), // Tăng kích thước biểu tượng
        SizedBox(width: 8), // Tăng khoảng cách giữa biểu tượng và văn bản
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Đậm hơn
            fontSize: 16, // Tăng kích thước chữ
          ),
        ),
      ],
    ),
    backgroundColor: chipColor,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Thêm padding
    elevation: 4, // Thêm độ nổi cho chip
  );
}