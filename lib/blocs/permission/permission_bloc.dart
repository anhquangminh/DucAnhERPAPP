import 'package:ducanherp/blocs/permission/permission_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'permission_event.dart';
import 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final PermissionRepository repository;

  PermissionBloc(this.repository) : super(PermissionInitial()) {
    on<FetchPermissions>((event, emit) async {
      emit(PermissionLoading());
      try {
        final data = await repository.getPermissions(
          groupId: event.groupId,
          userId: event.userId,
          parentMajorId: event.parentMajorId,
          majorId: event.majorId
        );
        emit(PermissionLoaded(data));
      } catch (e) {
        emit(PermissionError(e.toString()));
      }
    });

    on<LoadSinglePermission>((event, emit) async {
      emit(PermissionLoading());
      try {
        final data = await repository.getPermissions(
          groupId: event.groupId,
          majorId: event.majorId,
          parentMajorId: event.parentMajorId,
          userId: event.userId,
        );

        final filtered = event.permissionType != null
            ? data.where((p) => p.permissionType == event.permissionType).toList()
            : data;

        final permission = filtered.isNotEmpty ? filtered.first : null;

        emit(PermissionSingleLoaded(permission));
      } catch (e) {
        emit(PermissionError(e.toString()));
      }
    });

  }
}
