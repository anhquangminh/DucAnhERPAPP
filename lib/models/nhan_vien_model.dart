import 'package:equatable/equatable.dart';

class NhanVienModel extends Equatable {
  final String id;
  final String tenNhanVien;
  final String taiKhoan;
  final String groupId;
  final DateTime createAt;
  final String? createBy;
  final int isActive;

  const NhanVienModel({
    required this.id,
    required this.tenNhanVien,
    required this.taiKhoan,
    required this.groupId,
    required this.createAt,
    this.createBy,
    required this.isActive,
  });

  factory NhanVienModel.fromJson(Map<String, dynamic> json) {
    return NhanVienModel(
      id: json['id'] as String,
      tenNhanVien: json['tenNhanVien'] as String,
      taiKhoan: json['taiKhoan'] as String,
      groupId: json['groupId'] as String,
      createAt: DateTime.parse(json['createAt'] as String),
      createBy: json['createBy'] as String?,
      isActive: json['isActive'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenNhanVien': tenNhanVien,
      'taiKhoan': taiKhoan,
      'groupId': groupId,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
        id,
        tenNhanVien,
        taiKhoan,
        groupId,
        createAt,
        createBy,
        isActive,
      ];
}
