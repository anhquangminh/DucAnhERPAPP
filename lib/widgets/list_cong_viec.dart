import 'package:ducanherp/blocs/congviec/congviec_bloc.dart';
import 'package:ducanherp/blocs/congviec/congviec_event.dart';
import 'package:ducanherp/models/congviec_model.dart';
import 'package:ducanherp/models/congvieccon_model.dart';
import 'package:ducanherp/screens/danh_gia.dart';
import 'package:ducanherp/screens/them_congviec.dart';
import 'package:ducanherp/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListCongViec extends StatelessWidget {
  final List<CongViecModel> items;
  final List<CongViecConModel> item_cvcs;
  final Future<void> Function() onRefresh; // thêm callback onRefresh

  const ListCongViec({
    super.key,
    required this.items,
    required this.item_cvcs,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 50),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final cvcs = this.item_cvcs.where((cv) => cv.idCongViec == item.id).toList();
          return ListItem(
            congViec: item,
            item_cvcs: cvcs,
            onDanhGia: (context){
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DanhGia(
                    congViec: item,
                  ),
                ),
              ).then((shouldRefresh) {
                if (shouldRefresh == true) {
                  onRefresh();
                }
              });
            },
            onEdit: (context) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemCongViec(
                    congViecToEdit: item,
                  ),
                ),
              ).then((shouldRefresh) {
                if (shouldRefresh == true) {
                  onRefresh();
                }
              });
            },
            onDelete: (context) async {
              // 👉 Lưu trước bloc và scaffoldMessenger
              final congViecBloc = context.read<CongViecBloc>();
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text('Xác nhận xóa'),
                  content: Text('Bạn có chắc chắn muốn xóa công việc "${item.noiDungCongViec}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      child: Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                  congViecBloc.add(DeleteCongViec(item.id));
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa "${item.noiDungCongViec}"'),
                      duration: Duration(seconds: 2),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
