abstract class PermissionEvent {}

class FetchPermissions extends PermissionEvent {
  final String groupId;
  final String userId;
  final String? majorId;
  final String? parentMajorId;

  FetchPermissions({
    required this.groupId,
    required this.userId,
    this.majorId,
    this.parentMajorId,
  });
}

class LoadSinglePermission extends PermissionEvent {
  final String groupId;
  final String userId;
  final String? majorId;
  final String? parentMajorId;
  final int? permissionType;

  LoadSinglePermission({
    required this.groupId,
    required this.userId,
    this.majorId,
    this.parentMajorId,
    this.permissionType,
  });
}

