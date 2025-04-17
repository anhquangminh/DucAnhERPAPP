import 'package:ducanherp/models/congvieccon_model.dart';
import 'package:ducanherp/models/nhanvienthuchien_model.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/congviec_model.dart';

abstract class CongViecState extends Equatable {
  const CongViecState();
  @override
  List<Object> get props => [];
}

class CongViecInitial extends CongViecState {}

class CongViecLoading extends CongViecState {}

class CongViecInsertSuccess extends CongViecState {}

class CongViecDeleteSuccess extends CongViecState {}

class CongViecError extends CongViecState {
  final String message;
  final DateTime errorTime;
  const CongViecError(this.message, {required this.errorTime});
  @override
  List<Object> get props => [message, errorTime];
}

class CongViecLoaded extends CongViecState {
  final List<CongViecModel> congViecs;
  final DateTime lastUpdated;
  const CongViecLoaded({
    required this.congViecs,
    required this.lastUpdated,
  });
  @override
  List<Object> get props => [congViecs, lastUpdated];
}

class CongViecByVMLoaded extends CongViecState {
  final List<CongViecModel> congViecs;
  final String groupId;
  const CongViecByVMLoaded({required this.congViecs, required this.groupId});
  @override
  List<Object> get props => [congViecs, groupId];
}

class getAllNVTHLoaded extends CongViecState {
  final String groupId;
  final List<NhanVienThucHienModel> nvths;

  const getAllNVTHLoaded({required this.nvths, required this.groupId});
  @override
  List<Object> get props => [nvths, groupId];
}

class CongViecUpdated extends CongViecState {
  final CongViecModel congViec;
  const CongViecUpdated(this.congViec);
  @override
  List<Object> get props => [congViec];
}

class UploadFile extends CongViecState {
  final PlatformFile file;
  final String url;
  const UploadFile(this.file, this.url);
  @override
  List<Object> get props => [file,url];
}

class LoadCVCByIdCVState extends CongViecState {
  final List<CongViecConModel> cvcs;
  const LoadCVCByIdCVState(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}

class LoadCVCState extends CongViecState {
  final List<CongViecConModel> cvcs;
  const LoadCVCState(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}

class InsertCVCState extends CongViecState {
  final List<CongViecConModel> cvcs;
  const InsertCVCState(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}

class UpdateCVCState extends CongViecState {
  final List<CongViecConModel> cvcs;
  const UpdateCVCState(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}

class DeleteCVCState extends CongViecState {
  final List<CongViecConModel> cvcs;
  const DeleteCVCState(this.cvcs);
  @override
  List<Object> get props => [cvcs];
}