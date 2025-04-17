import 'package:equatable/equatable.dart';
import '../../models/nhanvien_model.dart';

abstract class NhanVienState extends Equatable {
  const NhanVienState();
  @override
  List<Object> get props => [];
}

class NhanVienInitial extends NhanVienState {}

class NhanVienLoading extends NhanVienState {}

class NhanVienLoaded extends NhanVienState {
  final List<NhanVienModel> nhanViens;
  final DateTime lastUpdated;

  const NhanVienLoaded({
    required this.nhanViens,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [nhanViens, lastUpdated];
}

class NhanVienByVMLoaded extends NhanVienState {
  final List<NhanVienModel> nhanViens;
  final String groupId;

  const NhanVienByVMLoaded({required this.nhanViens, required this.groupId});

  @override
  List<Object> get props => [nhanViens, groupId];
}

class GetNhanVienByNhomLoaded extends NhanVienState {
  final String groupId;
  final String Id_NhomNhanVien;

  const GetNhanVienByNhomLoaded({
    required this.groupId,
    required this.Id_NhomNhanVien
  });

  @override
  List<Object> get props => [groupId, Id_NhomNhanVien];
}

class NhanVienError extends NhanVienState {
  final String message;
  final DateTime errorTime;

  const NhanVienError(this.message, {required this.errorTime});

  @override
  List<Object> get props => [message, errorTime];
}
