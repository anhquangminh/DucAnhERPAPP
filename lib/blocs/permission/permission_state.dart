
import 'package:ducanherp/models/permission_model.dart';

abstract class PermissionState {}

class PermissionInitial extends PermissionState {}

class PermissionLoading extends PermissionState {}

class PermissionLoaded extends PermissionState {
  final List<PermissionModel> permissions;

  PermissionLoaded(this.permissions);
}

class PermissionError extends PermissionState {
  final String message;

  PermissionError(this.message);
}
class PermissionSingleLoaded extends PermissionState {
  final PermissionModel? permission;

  PermissionSingleLoaded(this.permission);
}
