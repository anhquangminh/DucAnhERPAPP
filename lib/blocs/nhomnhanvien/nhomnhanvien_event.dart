part of 'nhomnhanvien_bloc.dart';

abstract class NhomNhanVienEvent extends Equatable {
  const NhomNhanVienEvent();

  @override
  List<Object> get props => [];
}

class LoadNhomNhanVien extends NhomNhanVienEvent {
  final String groupId;
  final String taiKhoan;

  const LoadNhomNhanVien({
    required this.groupId,
    required this.taiKhoan,
  });

  @override
  List<Object> get props => [groupId, taiKhoan];
}

class AddNhomNhanVien extends NhomNhanVienEvent {
  final NhomNhanVienModel nhomNhanVien;

  const AddNhomNhanVien(this.nhomNhanVien);

  @override
  List<Object> get props => [nhomNhanVien];
}

class UpdateNhomNhanVien extends NhomNhanVienEvent {
  final NhomNhanVienModel nhomNhanVien;

  const UpdateNhomNhanVien(this.nhomNhanVien);

  @override
  List<Object> get props => [nhomNhanVien];
}

class DeleteNhomNhanVien extends NhomNhanVienEvent {
  final String id;

  const DeleteNhomNhanVien(this.id);

  @override
  List<Object> get props => [id];
}

class RefreshNhomNhanVien extends NhomNhanVienEvent {
  const RefreshNhomNhanVien();
}

class GetNhomNhanVienByVM extends NhomNhanVienEvent {
  final NhomNhanVienModel congViec;
  
  const GetNhomNhanVienByVM(this.congViec);

  @override
  List<Object> get props => [congViec];
}

class GetNhomNhanVienByCVDG extends NhomNhanVienEvent {
  final String groupId;
  final String taiKhoan;
  
  const GetNhomNhanVienByCVDG(this.groupId, this.taiKhoan);

  @override
  List<Object> get props => [groupId, taiKhoan];
}