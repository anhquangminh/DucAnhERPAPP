import 'package:equatable/equatable.dart';
import 'package:ducanherp/models/danhgia_model.dart';

abstract class DanhGiaEvent extends Equatable {
  const DanhGiaEvent();

  @override
  List<Object?> get props => [];
}

/// Sự kiện load đánh giá theo id cụ thể (sử dụng getById)
class LoadDanhGiaByIdEvent extends DanhGiaEvent {
  final String id;

  const LoadDanhGiaByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

/// Sự kiện load đánh giá theo idCongViec (sử dụng getByIdCongViec)
class LoadDanhGiaByIdCongViecEvent extends DanhGiaEvent {
  final String idCongViec;

  const LoadDanhGiaByIdCongViecEvent(this.idCongViec);

  @override
  List<Object> get props => [idCongViec];
}

/// Sự kiện tạo mới đánh giá
class CreateDanhGiaEvent extends DanhGiaEvent {
  final DanhGiaModel model;
  final String userName;

  const CreateDanhGiaEvent({required this.model, required this.userName});

  @override
  List<Object> get props => [model, userName];
}

/// Sự kiện cập nhật đánh giá
class UpdateDanhGiaEvent extends DanhGiaEvent {
  final DanhGiaModel model;
  final String userName;

  const UpdateDanhGiaEvent({required this.model, required this.userName});

  @override
  List<Object> get props => [model, userName];
}
