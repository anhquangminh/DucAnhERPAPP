class CongViecModel {
  String id;
  String idNguoiGiaoViec;
  String nguoiThucHien;
  String nhomCongViec;
  String tenNhom;
  DateTime ngayBatDau;
  DateTime ngayKetThuc;
  String mucDoUuTien;
  String tuDanhGia;
  int tienDo;
  String lapLai;
  String noiDungCongViec;
  String fileDinhKem;
  String groupId;
  DateTime createAt;
  String createBy;
  int isActive;
  int pageNumber;
  int pageSize;

  CongViecModel({
    required this.id,
    required this.idNguoiGiaoViec,
    required this.nguoiThucHien,
    required this.nhomCongViec,
    required this.tenNhom,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.mucDoUuTien,
    required this.tuDanhGia,
    required this.tienDo,
    required this.lapLai,
    required this.noiDungCongViec,
    required this.fileDinhKem,
    required this.groupId,
    required this.createAt,
    required this.createBy,
    required this.isActive,
    required this.pageNumber,
    required this.pageSize,
  });

  factory CongViecModel.fromJson(Map<String, dynamic> json) {
  return CongViecModel(
    id: json['id'] ?? '',
    idNguoiGiaoViec: json['id_NguoiGiaoViec'] ?? '',
    nguoiThucHien: json['nguoiThucHien'] ?? '',
    nhomCongViec: json['nhomCongViec'] ?? '',
    tenNhom: json['tenNhom'] ?? '',
    ngayBatDau: DateTime.parse(json['ngayBatDau']),
    ngayKetThuc: DateTime.parse(json['ngayKetThuc']),
    mucDoUuTien: json['mucDoUuTien'] ?? '',
    tuDanhGia: json['tuDanhGia'] ?? '',
    tienDo: json['tienDo'] ?? 0,
    lapLai: json['lapLai'] ?? '',
    noiDungCongViec: json['noiDungCongViec'] ?? '',
    fileDinhKem: json['fileDinhKem'] ?? '',
    groupId: json['groupId'] ?? '',
    createAt: DateTime.parse(json['createAt']),
    createBy: json['createBy'] ?? '',
    isActive: json['isActive'] ?? 1,
    pageNumber: json['page_number'] ?? 1,
    pageSize: json['pageSize'] ?? 10,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_NguoiGiaoViec': idNguoiGiaoViec,
      'nguoiThucHien': nguoiThucHien,
      'nhomCongViec': nhomCongViec,
      'tenNhom': tenNhom,
      'ngayBatDau': ngayBatDau.toIso8601String(),
      'ngayKetThuc': ngayKetThuc.toIso8601String(),
      'mucDoUuTien': mucDoUuTien,
      'tuDanhGia': tuDanhGia,
      'tienDo': tienDo,
      'lapLai': lapLai,
      'noiDungCongViec': noiDungCongViec,
      'fileDinhKem': fileDinhKem,
      'groupId': groupId,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
      'page_number': pageNumber,
      'pageSize': pageSize,
    };
  }
}
