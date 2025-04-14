import 'package:ducanherp/blocs/congviec/congviec_bloc.dart';
import 'package:ducanherp/blocs/congviec/congviec_event.dart';
import 'package:ducanherp/models/congviec_model.dart';
import 'package:ducanherp/models/congvieccon_model.dart';
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
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Xác nhận xóa'),
                  content: Text('Bạn có chắc chắn muốn xóa công việc "${item.noiDungCongViec}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                // Get the CongViecBloc from context
                final congViecBloc = context.read<CongViecBloc>();
                
                // Dispatch DeleteCongViec event
                congViecBloc.add(DeleteCongViec(item.id));
                
                ScaffoldMessenger.of(context).showSnackBar(
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
