class CongViecConModel {
  String id;
  String idCongViec;
  String noiDungCongViec;
  String? fileDinhKem;
  int hoanThanh;
  String groupId;
  DateTime createAt;
  String createBy;
  int isActive;

  CongViecConModel({
    required this.id,
    required this.idCongViec,
    required this.noiDungCongViec,
    required this.fileDinhKem ,
    required this.hoanThanh,
    required this.groupId,
    required this.createAt,
    required this.createBy,
    this.isActive = 1,
  });
        
  factory CongViecConModel.fromJson(Map<String, dynamic> json) {
    return CongViecConModel(
      id: json['id']??'',
      idCongViec: json['id_CongViec']??'',
      noiDungCongViec: json['noiDungCongViec']??'',
      fileDinhKem: json['fileDinhKem']??'',
      hoanThanh: json['hoanThanh']??'',
      groupId: json['groupId']??'',
      createAt: DateTime.parse(json['createAt']),
      createBy: json['createBy']??'',
      isActive: json['isActive']??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_CongViec': idCongViec,
      'noiDungCongViec': noiDungCongViec,
      'fileDinhKem': fileDinhKem,
      'hoanThanh': hoanThanh,
      'groupId': groupId,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
    };
  }
}
