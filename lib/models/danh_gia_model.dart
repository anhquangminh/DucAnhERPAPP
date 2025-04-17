class DanhGiaModel {
  final String id;
  final String idCongViec;
  int danhGia;
  String groupId;
  DateTime createAt;
  String createBy;
  int isActive;
  String? ghiChu;
  String? nguoiThucHien;
  String? noiDungCongViec;
  int? tienDo;
  bool? isEdited;

  DanhGiaModel({
    required this.id,
    required this.idCongViec,
    required this.danhGia,
    required this.groupId,
    required this.createAt,
    required this.createBy,
    required this.isActive,
    this.ghiChu,
    this.nguoiThucHien,
    this.noiDungCongViec,
    this.tienDo,
    this.isEdited,
  });

  factory DanhGiaModel.fromJson(Map<String, dynamic> json) {
    return DanhGiaModel(
      id: json['id'] as String,
      idCongViec: json['id_CongViec'] as String,
      danhGia: json['danhGia'] as int,
      groupId: json['groupId'] as String,
      createAt: DateTime.parse(json['createAt']),
      createBy: json['createBy'] as String,
      isActive: json['isActive'] as int,
      ghiChu: json['ghiChu'] as String?,
      nguoiThucHien: json['nguoiThucHien'] as String?,
      noiDungCongViec: json['noiDungCongViec'] as String?,
      tienDo: json['tienDo'] as int?,
      isEdited: json['isEdited'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_CongViec': idCongViec,
      'danhGia': danhGia,
      'groupId': groupId,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
      'ghiChu': ghiChu,
      'nguoiThucHien': nguoiThucHien,
      'noiDungCongViec': noiDungCongViec,
      'tienDo': tienDo,
      'isEdited': isEdited,
    };
  }

  DanhGiaModel copyWith({
    String? id,
    String? idCongViec,
    int? danhGia,
    String? groupId,
    DateTime? createAt,
    String? createBy,
    int? isActive,
    String? ghiChu,
    String? nguoiThucHien,
    String? noiDungCongViec,
    int? tienDo,
    bool? isEdited,
  }) {
    return DanhGiaModel(
      id: id ?? this.id,
      idCongViec: idCongViec ?? this.idCongViec,
      danhGia: danhGia ?? this.danhGia,
      groupId: groupId ?? this.groupId,
      createAt: createAt ?? this.createAt,
      createBy: createBy ?? this.createBy,
      isActive: isActive ?? this.isActive,
      ghiChu: ghiChu ?? this.ghiChu,
      nguoiThucHien: nguoiThucHien ?? this.nguoiThucHien,
      noiDungCongViec: noiDungCongViec ?? this.noiDungCongViec,
      tienDo: tienDo ?? this.tienDo,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
