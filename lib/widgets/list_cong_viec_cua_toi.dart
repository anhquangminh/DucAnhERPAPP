import 'package:ducanherp/models/congviec_model.dart';
import 'package:ducanherp/widgets/list_item_cua_toi.dart';
import 'package:flutter/material.dart';


class ListCongViecCuaToi extends StatelessWidget {
  final List<CongViecModel> items;
  final Future<void> Function() onRefresh;

  const ListCongViecCuaToi({
    super.key,
    required this.items,
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
          return ListItemCuaToi(
            congViec: item,
            onRefresh: onRefresh
          );
        },
      ),
    );
  }
}
