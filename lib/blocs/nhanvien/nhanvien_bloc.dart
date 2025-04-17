import 'dart:async';
import 'package:bloc/bloc.dart';
import 'nhanvien_repository.dart';
import 'nhanvien_event.dart';
import 'nhanvien_state.dart';

class NhanVienBloc extends Bloc<NhanVienEvent, NhanVienState> {
  final NhanVienRepository repository;
  StreamSubscription? _nhanVienSubscription;

  NhanVienBloc({required this.repository}) : super(NhanVienInitial()) {
    on<LoadNhanVien>(_onLoadNhanVien);
    on<GetNhanVienByVM>(_onGetNhanVienByVM);
    on<GetNhanVienByNhom>(_onGetNhanVienByNhom);
    on<AddNhanVien>(_onAddNhanVien);
    on<DeleteNhanVien>(_onDeleteNhanVien);
    on<RefreshNhanVien>(_onRefreshNhanVien);
  }

  Future<void> _onLoadNhanVien(
    LoadNhanVien event,
    Emitter<NhanVienState> emit,
  ) async {
    emit(NhanVienLoading());
    try {
      final nhanViens = await repository.fetchNhanVien(
        groupId: event.groupId,
        taiKhoan: event.taiKhoan,
      );
      emit(NhanVienLoaded(
        nhanViens: nhanViens,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(NhanVienError(
        e.toString(),
        errorTime: DateTime.now(),
      ));
    }
  }

  Future<void> _onAddNhanVien(
    AddNhanVien event,
    Emitter<NhanVienState> emit,
  ) async {
    if (state is NhanVienLoaded) {
      final currentState = state as NhanVienLoaded;
      try {
        final newNhanVien = await repository.addNhanVien(event.nhanVien);
        emit(NhanVienLoaded(
          nhanViens: [...currentState.nhanViens, newNhanVien],
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        emit(NhanVienError(
          e.toString(),
          errorTime: DateTime.now(),
        ));
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteNhanVien(
    DeleteNhanVien event,
    Emitter<NhanVienState> emit,
  ) async {
    if (state is NhanVienLoaded) {
      final currentState = state as NhanVienLoaded;
      try {
        await repository.deleteNhanVien(event.id);
        emit(NhanVienLoaded(
          nhanViens: currentState.nhanViens
              .where((nhanVien) => nhanVien.id != event.id)
              .toList(),
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        emit(NhanVienError(
          e.toString(),
          errorTime: DateTime.now(),
        ));
        emit(currentState);
      }
    }
  }

  Future<void> _onRefreshNhanVien(
    RefreshNhanVien event,
    Emitter<NhanVienState> emit,
  ) async {
    if (state is NhanVienLoaded) {
      final currentState = state as NhanVienLoaded;
      try {
        emit(NhanVienLoading());
        final nhanViens = await repository.fetchNhanVien(
          groupId: currentState.nhanViens.first.groupId,
          taiKhoan: currentState.nhanViens.first.taiKhoan,
        );
        emit(NhanVienLoaded(
          nhanViens: nhanViens,
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        emit(NhanVienError(
          e.toString(),
          errorTime: DateTime.now(),
        ));
        emit(currentState);
      }
    }
  }

  Future<void> _onGetNhanVienByVM(
    GetNhanVienByVM event,
    Emitter<NhanVienState> emit,
  ) async {
    emit(NhanVienLoading());
    try {
      final nhanViens = await repository.getNhanVienByVM(event.nhanVien);
      emit(NhanVienByVMLoaded(
        nhanViens: nhanViens,
        groupId: event.nhanVien.groupId,
      ));
    } catch (e) {
      emit(NhanVienError(
        e.toString(),
        errorTime: DateTime.now(),
      ));
    }
  }

  Future<void> _onGetNhanVienByNhom(
    GetNhanVienByNhom event,
    Emitter<NhanVienState> emit,
  ) async {
    emit(NhanVienLoading());
    try {
      final nhanViens = await repository.GetNhanVienByNhom(
        groupId: event.groupId,
        Id_NhomNhanVien: event.Id_NhomNhanVien,
      );
      emit(NhanVienLoaded(
        nhanViens: nhanViens,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(NhanVienError(
        e.toString(),
        errorTime: DateTime.now(),
      ));
    }
  }

  @override
  Future<void> close() {
    _nhanVienSubscription?.cancel();
    return super.close();
  }
}
