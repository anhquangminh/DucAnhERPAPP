import 'package:ducanherp/models/congviec_model.dart';
import 'package:ducanherp/models/congvieccon_model.dart';
import 'package:ducanherp/models/nhanvienthuchien_model.dart';
import 'package:ducanherp/models/themngay_model.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class CongViecEvent extends Equatable {
  const CongViecEvent();
  @override
  List<Object> get props => [];
}

// --- Công việc chính ---
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
  const AddCongViec({
    required this.congViec,
    required this.themNgay,
    required this.nhanViens,
  });

  @override
  List<Object> get props => [congViec, themNgay, nhanViens];
}

class UpdateCongViecEvent extends CongViecEvent {
  final CongViecModel congViec;
  final ThemNgayModel themNgay;
  final List<String> nhanViens;
  const UpdateCongViecEvent({
    required this.congViec,
    required this.themNgay,
    required this.nhanViens,
  });

  @override
  List<Object> get props => [congViec, themNgay, nhanViens];
}

class DeleteCongViec extends CongViecEvent {
  final String id;
  const DeleteCongViec(this.id);

  @override
  List<Object> get props => [id];
}

class RefreshCongViec extends CongViecEvent {
  const RefreshCongViec();
}

class GetCongViecByVM extends CongViecEvent {
  final CongViecModel congViec;
  const GetCongViecByVM(this.congViec);

  @override
  List<Object> get props => [congViec];
}

// --- Nhân viên thực hiện ---
class GetAllNVTH extends CongViecEvent {
  final String groupId;
  final NhanVienThucHienModel nvths;
  const GetAllNVTH(this.groupId, this.nvths);

  @override
  List<Object> get props => [groupId, nvths];
}

// --- Upload File ---
class UploadFileEvent extends CongViecEvent {
  final PlatformFile file;
  const UploadFileEvent(this.file);

  @override
  List<Object> get props => [file];
}

// --- CVC (Công việc con) ---
class LoadAllCVCEvent extends CongViecEvent {
  const LoadAllCVCEvent();
}

class LoadCVCByIdCVEvent extends CongViecEvent {
  final String idCongViec;
  const LoadCVCByIdCVEvent(this.idCongViec);

  @override
  List<Object> get props => [idCongViec];
}

class UpdateCVCEvent extends CongViecEvent {
  final CongViecConModel cvc;
  const UpdateCVCEvent(this.cvc);

  @override
  List<Object> get props => [cvc];
}

class InsertCVCEvent extends CongViecEvent {
  final CongViecConModel cvc;
  const InsertCVCEvent(this.cvc);

  @override
  List<Object> get props => [cvc];
}

class DeleteCVCEvent extends CongViecEvent {
  final String id;
  final String userName;
  const DeleteCVCEvent(this.id, this.userName);

  @override
  List<Object> get props => [id, userName];
}
