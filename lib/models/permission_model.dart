class PermissionModel {
  final String id;
  final String parentMajorId;
  final String parentMajorName;
  final String majorId;
  final String majorName;
  final int permissionType;
  final String permissionTypeName;
  final String permissionName;
  final DateTime createAt;
  final String createBy;
  final int isActive;
  final bool isChecked;
  final int screenId;
  final String screenName;
  final int pageNumber;
  final int pageSize;

  PermissionModel({
    required this.id,
    required this.parentMajorId,
    required this.parentMajorName,
    required this.majorId,
    required this.majorName,
    required this.permissionType,
    required this.permissionTypeName,
    required this.permissionName,
    required this.createAt,
    required this.createBy,
    required this.isActive,
    required this.isChecked,
    required this.screenId,
    required this.screenName,
    required this.pageNumber,
    required this.pageSize,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'],
      parentMajorId: json['parentMajorId'],
      parentMajorName: json['parentMajorName'],
      majorId: json['majorId'],
      majorName: json['majorName'],
      permissionType: json['permissionType'],
      permissionTypeName: json['permissionTypeName'],
      permissionName: json['permissionName'],
      createAt: DateTime.parse(json['createAt']),
      createBy: json['createBy'],
      isActive: json['isActive'],
      isChecked: json['isChecked'],
      screenId: json['screenId'],
      screenName: json['screenName'],
      pageNumber: json['page_number'],
      pageSize: json['pageSize'] ?? json['page_size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentMajorId': parentMajorId,
      'parentMajorName': parentMajorName,
      'majorId': majorId,
      'majorName': majorName,
      'permissionType': permissionType,
      'permissionTypeName': permissionTypeName,
      'permissionName': permissionName,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
      'isChecked': isChecked,
      'screenId': screenId,
      'screenName': screenName,
      'page_number': pageNumber,
      'pageSize': pageSize,
    };
  }
}
