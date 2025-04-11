import 'package:equatable/equatable.dart';
import '../../models/nhanvien_model.dart';


abstract class NhanVienEvent extends Equatable {
  const NhanVienEvent();

  @override
  List<Object> get props => [];
}

class GetNhanVienByVM extends NhanVienEvent {
  final NhanVienModel nhanVien;

  const GetNhanVienByVM(this.nhanVien);

  @override
  List<Object> get props => [nhanVien];
}

class LoadNhanVien extends NhanVienEvent {
  final String groupId;
  final String taiKhoan;

  const LoadNhanVien({required this.groupId, required this.taiKhoan});
  @override
  List<Object> get props => [groupId, taiKhoan];
}

class GetNhanVienByNhom extends NhanVienEvent {
  final String groupId;
  final String Id_NhomNhanVien;

  const GetNhanVienByNhom({required this.groupId, required this.Id_NhomNhanVien});
  @override
  List<Object> get props => [groupId, Id_NhomNhanVien];
}

class AddNhanVien extends NhanVienEvent {
  final NhanVienModel nhanVien;
  const AddNhanVien(this.nhanVien);
  @override
  List<Object> get props => [nhanVien];
}

class DeleteNhanVien extends NhanVienEvent {
  final String id;
  const DeleteNhanVien(this.id);
  @override
  List<Object> get props => [id];
}

class RefreshNhanVien extends NhanVienEvent {
  const RefreshNhanVien();
  @override
  List<Object> get props => [];
}
