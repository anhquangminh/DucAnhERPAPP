
import 'package:ducanherp/models/congvieccon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ducanherp/models/congviec_model.dart';
import 'package:ducanherp/blocs/congviec/congviec_bloc.dart';
import 'package:ducanherp/blocs/congviec/congviec_event.dart';
import 'package:ducanherp/utils/date_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ducanherp/widgets/sub_tasks_widget.dart';

class ListItem extends StatelessWidget {
  final CongViecModel congViec;
  final List<CongViecConModel> item_cvcs;
  final Function(BuildContext) onEdit;
  final Function(BuildContext) onDelete;

  const ListItem({
    super.key,
    required this.item_cvcs,
    required this.congViec,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), 
    child: Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(context),
            backgroundColor: Colors.teal,
            icon: Icons.edit,
            label: 'Sửa',
          ),
          SlidableAction(
            onPressed: (context) => onDelete(context),
            backgroundColor: Colors.redAccent,
            icon: Icons.delete,
            label: 'Xóa',
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nội dung công việc
            Row(
              children: [
                const Icon(Icons.work_outline, color: Colors.indigo),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    congViec.noiDungCongViec,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Ngày
            Row(
              children: [
                _buildPriorityChip(congViec.mucDoUuTien),
                Text(
                  '${DateUtilsHelper.formatDate(congViec.ngayBatDau)} – ${DateUtilsHelper.formatDate(congViec.ngayKetThuc)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            SubTasksWidget(
              congViec: congViec,
              itemCvcs: item_cvcs,
              onAddSubTask: (cvc) {
               context.read<CongViecBloc>().add(InsertCVCEvent(cvc));
              },
              onUpdateSubTask: (cvc) {
                context.read<CongViecBloc>().add(UpdateCVCEvent(cvc));
              },
              onDeleteSubTask: (id,) {
                context.read<CongViecBloc>().add(DeleteCVCEvent(id,congViec.createBy));
              },
               onFileSelected: (file, task) {
                context.read<CongViecBloc>().add(UploadFileEvent(file));
              },
            ),
          ],
        ),
      ),
    ));
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
      icon = Icons.check_circle_outline;
      break;
    case 'Trung bình':
      chipColor = Colors.orange;
      label = 'Trung bình';
      icon = Icons.warning_amber_rounded;
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
    avatar: Icon(icon, size: 20, color: Colors.white),
    label: Text(
      label,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
    ),
    backgroundColor: chipColor,
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
