import 'package:equatable/equatable.dart';

class ThemNgayModel extends Equatable {
  final String id;
  final String idCongViec;
  final String idCongViecThemNgay;
  final int soNgay;
  final String groupId;
  final DateTime createAt;
  final String createBy;
  final int isActive;

  const ThemNgayModel({
    required this.id,
    required this.idCongViec,
    required this.idCongViecThemNgay,
    this.soNgay = 0,
    this.groupId = '',
    required this.createAt,
    required this.createBy,
    this.isActive = 1,
  }); 

  factory ThemNgayModel.fromJson(Map<String, dynamic> json) {
    return ThemNgayModel(
      id: json['id'],
      idCongViec: json['id_CongViec'],
      idCongViecThemNgay: json['id_CongViecThemNgay'],
      soNgay: json['soNgay'] ?? 0,
      groupId: json['groupId'] ?? '',
       createAt: DateTime.parse(json['createAt'] as String),
      createBy: json['createBy'],
      isActive: json['isActive'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_CongViec': idCongViec,
      'id_CongViecThemNgay': idCongViecThemNgay,
      'soNgay': soNgay,
      'groupId': groupId,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
        id,
        idCongViec,
        idCongViecThemNgay,
        soNgay,
        groupId,
        createAt,
        createBy,
        isActive,
      ];

  ThemNgayModel copyWith({
    String? id,
    String? idCongViec,
    String? idCongViecThemNgay,
    int? soNgay,
    String? groupId,
    DateTime? createAt,
    String? createBy,
    int? isActive,
  }) {
    return ThemNgayModel(
      id: id ?? this.id,
      idCongViec: idCongViec ?? this.idCongViec,
      idCongViecThemNgay: idCongViecThemNgay ?? this.idCongViecThemNgay,
      soNgay: soNgay ?? this.soNgay,
      groupId: groupId ?? this.groupId,
      createAt: createAt ?? this.createAt,
      createBy: createBy ?? this.createBy,
      isActive: isActive ?? this.isActive,
    );
  }
}
