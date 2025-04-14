import 'package:flutter/material.dart';
import 'package:ducanherp/models/congviec_model.dart';
import 'package:ducanherp/models/congvieccon_model.dart';
import 'package:file_picker/file_picker.dart';

class SubTasksWidget extends StatefulWidget {
  final CongViecModel congViec;
  final List<CongViecConModel> itemCvcs;
  final Function(CongViecConModel) onAddSubTask;
  final Function(CongViecConModel) onUpdateSubTask;
  final Function(String) onDeleteSubTask;
  final Function(PlatformFile, CongViecConModel?) onFileSelected;

  const SubTasksWidget({
    Key? key,
    required this.congViec,
    required this.itemCvcs,
    required this.onAddSubTask,
    required this.onUpdateSubTask,
    required this.onDeleteSubTask,
    required this.onFileSelected,
  }) : super(key: key);

  @override
  State<SubTasksWidget> createState() => _SubTasksWidgetState();
}

class _SubTasksWidgetState extends State<SubTasksWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Text('Công việc con (${widget.itemCvcs.length})'),
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            onPressed: () => _showTaskDialog(context),
            tooltip: 'Thêm công việc con',
          ),
        ],
      ),
      children: [
        if (widget.itemCvcs.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Không có công việc con nào'),
          )
        else
          _buildSubTasksList(),
      ],
    );
  }

  Widget _buildSubTasksList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.itemCvcs.length,
      itemBuilder: (context, index) {
        final task = widget.itemCvcs[index];
        return _buildSubTaskItem(task, index);
      },
    );
  }

  Widget _buildSubTaskItem(CongViecConModel task, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${index + 1}. ${task.noiDungCongViec}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showTaskDialog(context, task: task, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () => _confirmDeleteTask(context, task),
                    ),
                  ],
                ),
              ],
            ),
            if (task.fileDinhKem?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(Icons.attachment, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task.fileDinhKem!.split('/').last,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
           
          ],
        ),
      ),
    );
  }

  Future<void> _showTaskDialog(
    BuildContext context, {
    CongViecConModel? task,
    int? index,
  }) async {
    final controller = TextEditingController(text: task?.noiDungCongViec ?? '');
    final formKey = GlobalKey<FormState>();

    String? filePath = task?.fileDinhKem;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'Thêm công việc con' : 'Sửa công việc con'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập nội dung công việc!' : null,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                // Row(
                //   children: [
                //     ElevatedButton.icon(
                //       icon: const Icon(Icons.attach_file),
                //       label: const Text("Tệp đính kèm"),
                //       onPressed: () async {
                //         try {
                //           final result = await FilePicker.platform.pickFiles(
                //             type: FileType.any,
                //             allowMultiple: false,
                //           );
                          
                //           if (result != null && mounted) {
                //             final file = result.files.single;
                //             setState(() {
                //               fileName = file.name;
                //               filePath = file.path;
                //             });
                //             widget.onFileSelected(file, task);
                //           }
                //         } catch (e) {
                //           if (mounted) {
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               SnackBar(content: Text('Lỗi tải file: ${e.toString()}'))
                //             );
                //           }
                //         }
                //       },
                //     ),
                //     if (fileName != null)
                //       Padding(
                //         padding: const EdgeInsets.only(left: 8),
                //         child: Chip(
                //           label: Text(
                //             fileName!,
                //             overflow: TextOverflow.ellipsis,
                //           ),
                //           deleteIcon: const Icon(Icons.close),
                //           onDeleted: () {
                //             if (mounted) {
                //               setState(() {
                //                 fileName = null;
                //                 filePath = null;
                //               });
                //             }
                //           },
                //         ),
                //       ),
                //   ],
                // ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newTask = CongViecConModel(
                    id: task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    idCongViec: widget.congViec.id,
                    noiDungCongViec: controller.text,
                    fileDinhKem: filePath ?? '',
                    hoanThanh: task?.hoanThanh ?? 0,
                    groupId: widget.congViec.groupId,
                    createAt: DateTime.now(),
                    createBy: widget.congViec.createBy,
                    isActive: 1,
                  );

                  if (task == null) {
                    widget.onAddSubTask(newTask);
                  } else {
                    widget.onUpdateSubTask(newTask);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Lưu lại'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteTask(BuildContext context, CongViecConModel task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa công việc con "${task.noiDungCongViec}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      widget.onDeleteSubTask(task.id);
    }
  }
}