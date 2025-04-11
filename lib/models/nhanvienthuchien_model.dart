class NhanVienThucHienModel {
  String id;
  String idCongViec;
  String idNhanVien;
  String tuDanhGia;
  String groupId;
  DateTime createAt;
  String createBy;
  int isActive;

  NhanVienThucHienModel({
    required this.id,
    required this.idCongViec,
    required this.idNhanVien,
    this.tuDanhGia = '',
    this.groupId = '',
    DateTime? createAt,
    required this.createBy,
    this.isActive = 1,
  }) : createAt = createAt ?? DateTime.now();

  factory NhanVienThucHienModel.fromJson(Map<String, dynamic> json) {
    return NhanVienThucHienModel(
      id: json['id'],
      idCongViec: json['id_CongViec'],
      idNhanVien: json['id_NhanVien'],
      tuDanhGia: json['tuDanhGia'] ?? '',
      groupId: json['groupId'] ?? '',
      createAt: DateTime.parse(json['createAt']),
      createBy: json['createBy'],
      isActive: json['isActive'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_CongViec': idCongViec,
      'id_NhanVien': idNhanVien,
      'tuDanhGia': tuDanhGia,
      'groupId': groupId,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
    };
  }
}
