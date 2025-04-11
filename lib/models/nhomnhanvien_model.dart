class NhomNhanVienModel {
  String id;
  String idQuanLy;
  String tenNhanVien;
  String taiKhoan;
  String tenNhom;
  int total;
  String groupId;
  DateTime createAt;
  String? createBy;
  int isActive;
  int pageNumber;
  int pageSize;

  NhomNhanVienModel({
    required this.id,
    required this.idQuanLy,
    required this.tenNhanVien,
    required this.taiKhoan,
    required this.tenNhom,
    required this.total,
    required this.groupId,
    required this.createAt,
    this.createBy,
    required this.isActive,
    required this.pageNumber,
    required this.pageSize,
  });

  factory NhomNhanVienModel.fromJson(Map<String, dynamic> json) {
    return NhomNhanVienModel(
      id: json["id"],
      idQuanLy: json["id_QuanLy"],
      tenNhanVien: json["tenNhanVien"],
      taiKhoan: json["taiKhoan"],
      tenNhom: json["tenNhom"],
      total: json["total"],
      groupId: json["groupId"],
      createAt: DateTime.parse(json["createAt"]),
      createBy: json["createBy"],
      isActive: json["isActive"],
      pageNumber: json["page_number"],
      pageSize: json["pageSize"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "id_QuanLy": idQuanLy,
      "tenNhanVien": tenNhanVien,
      "taiKhoan": taiKhoan,
      "tenNhom": tenNhom,
      "total": total,
      "groupId": groupId,
      "createAt": createAt.toIso8601String(),
      "createBy": createBy,
      "isActive": isActive,
      "page_number": pageNumber,
      "pageSize": pageSize,
    };
  }
}
