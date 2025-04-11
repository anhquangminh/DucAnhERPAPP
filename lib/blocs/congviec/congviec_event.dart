import 'package:ducanherp/models/nhanvienthuchien_model.dart';
import 'package:ducanherp/models/themngay_model.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/congviec_model.dart';

abstract class CongViecEvent extends Equatable {
  const CongViecEvent();
  @override
  List<Object> get props => [];
}

class LoadCongViec extends CongViecEvent {
  final String groupId;
  final String nguoiThucHien;

  const LoadCongViec({required this.groupId, required this.nguoiThucHien});
  @override
  List<Object> get props => [groupId, nguoiThucHien];
}

class AddCongViec extends CongViecEvent {
  final CongViecModel congViec;
  final ThemNgayModel themNgay;
  final List<String> nhanViens;

  AddCongViec({
    required this.congViec,
    required this.themNgay,
    required this.nhanViens,
  });
}

class DeleteCongViec extends CongViecEvent {
  final String id;
  const DeleteCongViec(this.id);
  @override
  List<Object> get props => [id];
}

class RefreshCongViec extends CongViecEvent {
  const RefreshCongViec();
  @override
  List<Object> get props => [];
}

class GetCongViecByVM extends CongViecEvent {
  final CongViecModel congViec;

  const GetCongViecByVM(this.congViec);

  @override
  List<Object> get props => [congViec];
}

class getAllNVTH extends CongViecEvent {
  final String groupId;
  final NhanVienThucHienModel nvths;

  const getAllNVTH(this.groupId, this.nvths);

  @override
  List<Object> get props => [groupId, nvths];
}


class UpdateCongViecEvent extends CongViecEvent {
  final CongViecModel congViec;
  final ThemNgayModel themNgay;
  final List<String> nhanViens;

  UpdateCongViecEvent({
    required this.congViec,
    required this.themNgay,
    required this.nhanViens,
  });
}

class UploadFileEvent extends CongViecEvent {
  final PlatformFile file;

  const UploadFileEvent(this.file);

  @override
  List<Object> get props => [file];
}

class LoadCVCByIdCVEvent extends CongViecEvent {
  final String id_CongViec;

  const LoadCVCByIdCVEvent(this.id_CongViec);

  @override
  List<Object> get props => [id_CongViec];
}