import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/nhomnhanvien_model.dart';
import 'nhom_nhan_vien_repository.dart';

part 'nhom_nhan_vien_event.dart';
part 'nhom_nhan_vien_state.dart';

class NhomNhanVienBloc extends Bloc<NhomNhanVienEvent, NhomNhanVienState> {
  late final NhomNhanVienRepository repository;
  final http.Client client;
  final SharedPreferences prefs;

   NhomNhanVienBloc({required this.client, required this.prefs})
      : repository = NhomNhanVienRepository(client: client, prefs: prefs),
        super(NhomNhanVienInitial()) {
    on<LoadNhomNhanVien>(_onLoadNhomNhanVien);
    on<AddNhomNhanVien>(_onAddNhomNhanVien);
    // on<UpdateNhomNhanVien>(_onUpdateNhomNhanVien);
    on<DeleteNhomNhanVien>(_onDeleteNhomNhanVien);
    on<RefreshNhomNhanVien>(_onRefreshNhomNhanVien);
    on<GetNhomNhanVienByVM>(_onGetNhomNhanVienByVM);
    on<GetNhomNhanVienByCVDG>(_onGetNhomNhanVienByCVDG);
  }

  Future<void> _onLoadNhomNhanVien(LoadNhomNhanVien event,Emitter<NhomNhanVienState> emit) 
  async {
    try {
      emit(NhomNhanVienLoading());
      final nhomNhanViens = await repository.fetchNhomNhanVien(
        groupId: event.groupId,
        taiKhoan: event.taiKhoan,
      );
      emit(NhomNhanVienLoaded(
        nhomNhanViens: nhomNhanViens,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(NhomNhanVienError(
        e.toString(),
        errorTime: DateTime.now(),
      ));
    }
  }

  Future<void> _onAddNhomNhanVien(AddNhomNhanVien event, Emitter<NhomNhanVienState> emit)
  async {
    if (state is NhomNhanVienLoaded) {
      final currentState = state as NhomNhanVienLoaded;
      try {
        final newNhomNhanVien = await repository.addNhomNhanVien(event.nhomNhanVien);
        emit(NhomNhanVienLoaded(
          nhomNhanViens: [...currentState.nhomNhanViens, newNhomNhanVien],
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        emit(NhomNhanVienError(
          e.toString(),
          errorTime: DateTime.now(),
        ));
        emit(currentState);
      }
    }
  }

  Future<void> _onDeleteNhomNhanVien(DeleteNhomNhanVien event,Emitter<NhomNhanVienState> emit) 
  async {
    if (state is NhomNhanVienLoaded) {
      final currentState = state as NhomNhanVienLoaded;
      try {
        await repository.deleteNhomNhanVien(event.id);
        emit(NhomNhanVienLoaded(
          nhomNhanViens: currentState.nhomNhanViens
              .where((nhom) => nhom.id != event.id)
              .toList(),
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        emit(NhomNhanVienError(
          e.toString(),
          errorTime: DateTime.now(),
        ));
        emit(currentState);
      }
    }
  }

  Future<void> _onRefreshNhomNhanVien(RefreshNhomNhanVien event,Emitter<NhomNhanVienState> emit) 
  async {
    if (state is NhomNhanVienLoaded) {
      final currentState = state as NhomNhanVienLoaded;
      try {
        emit(NhomNhanVienLoading());
        final nhomNhanViens = await repository.fetchNhomNhanVien(
          groupId: currentState.nhomNhanViens.first.groupId,
          taiKhoan: currentState.nhomNhanViens.first.taiKhoan,
        );
        emit(NhomNhanVienLoaded(
          nhomNhanViens: nhomNhanViens,
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        emit(NhomNhanVienError(
          e.toString(),
          errorTime: DateTime.now(),
        ));
        emit(currentState);
      }
    }
  }

  Future<void> _onGetNhomNhanVienByVM(GetNhomNhanVienByVM event, Emitter<NhomNhanVienState> emit) 
   async {
    try {
      final nhomnhanviens = await repository.getNhomNhanVienByVM(event.congViec);
      emit(NhomNhanVienLoaded(nhomNhanViens: nhomnhanviens,lastUpdated: DateTime.now()));
    } catch (e) {
       emit(NhomNhanVienError(
          e.toString(),
          errorTime: DateTime.now(),
        ));
    }
  }

  Future<void> _onGetNhomNhanVienByCVDG(GetNhomNhanVienByCVDG event, Emitter<NhomNhanVienState> emit) 
   async {
    try {
      final nhomnhanviens = await repository.GetNhomNhanVienByCVDG(event.groupId,event.taiKhoan);
      emit(NhomNhanVienLoaded(nhomNhanViens: nhomnhanviens,lastUpdated: DateTime.now()));
    } catch (e) {
       emit(NhomNhanVienError(
          e.toString(),
          errorTime: DateTime.now(),
        ));
    }
  }

}