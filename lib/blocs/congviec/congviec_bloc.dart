import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ducanherp/blocs/congviec/congviec_repository.dart';
import 'package:ducanherp/blocs/congviec/congviec_event.dart';
import 'package:ducanherp/blocs/congviec/congviec_state.dart';

class CongViecBloc extends Bloc<CongViecEvent, CongViecState> {
  final http.Client client;
  final SharedPreferences prefs;
  late final CongViecRepository repository;
  StreamSubscription? _congViecSubscription;

  CongViecBloc({required this.client, required this.prefs})
      : repository = CongViecRepository(client: client, prefs: prefs),
        super(CongViecInitial()) {
    on<LoadCongViec>(_onLoadCongViec);
    on<AddCongViec>(_onAddCongViec);
    on<UpdateCongViecEvent>(_onUpdateCongViec);
    on<DeleteCongViec>(_onDeleteCongViec);
    on<RefreshCongViec>(_onRefreshCongViec);
    on<GetCongViecByVM>(_onGetCongViecByVM);
    on<getAllNVTH>(_onGetAllNVTH);
    on<UploadFileEvent>(_onUploadFile);
    on<LoadCVCByIdCVEvent>(_onLoadCVCByIdCV);
  }

  Future<void> _onLoadCongViec(
    LoadCongViec event,
    Emitter<CongViecState> emit,
  ) async {
    emit(CongViecLoading());
    try {
      final congViecs = await repository.fetchCongViec(
        groupId: event.groupId,
        nguoiThucHien: event.nguoiThucHien,
      );
      emit(CongViecLoaded(
        congViecs: congViecs,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(CongViecError(
        e.toString(),
        errorTime: DateTime.now(),
      ));
    }
  }

  Future<void> _onAddCongViec(
    AddCongViec event,
    Emitter<CongViecState> emit,
  ) async {
    final currentState = state;

    emit(CongViecLoading());

    try {
      final newCongViec = await repository.addCongViec(
        event.congViec,
        event.themNgay,
        event.nhanViens,
      );

      // Nếu trước đó là CongViecLoaded thì thêm vào danh sách cũ
      if (currentState is CongViecLoaded) {
        emit(CongViecLoaded(
          congViecs: [...currentState.congViecs, newCongViec],
          lastUpdated: DateTime.now(),
        ));
      } else {
        // Nếu chưa có data thì tạo mới danh sách
        emit(CongViecLoaded(
          congViecs: [newCongViec],
          lastUpdated: DateTime.now(),
        ));
      }
    } catch (e) {
      emit(CongViecError(e.toString(), errorTime: DateTime.now()));

      // Optional: giữ lại state cũ nếu có
      if (currentState is CongViecLoaded) {
        emit(currentState);
      }
    }
  }

 Future<void> _onUpdateCongViec(
    UpdateCongViecEvent event,
    Emitter<CongViecState> emit,
  ) async {
    emit(CongViecLoading());

    try {
      final updated = await repository.updateCongViec(
        event.congViec,
        event.themNgay,
        event.nhanViens,
      );
      emit(CongViecUpdated(updated));
    } catch (e) {
      emit(CongViecError(e.toString(), errorTime: DateTime.now(),));
    }
  }

  Future<void> _onDeleteCongViec(
    DeleteCongViec event,
    Emitter<CongViecState> emit,
  ) async {
    final currentState = state;

    if (currentState is CongViecByVMLoaded) {
      try {
        final success = await repository.deleteCongViec(event.id);
        if (success) {
          final updatedList = currentState.congViecs
              .where((congViec) => congViec.id != event.id)
              .toList();
          emit(CongViecByVMLoaded(
              congViecs: updatedList, groupId: currentState.groupId));
        } else {
          emit(CongViecError(
            'Xoá thất bại',
            errorTime: DateTime.now(),
          ));
          emit(currentState);
        }
      } catch (e) {
        emit(CongViecError(
          'Lỗi khi xoá: ${e.toString()}',
          errorTime: DateTime.now(),
        ));
        emit(currentState);
      }
    }
  }

  Future<void> _onRefreshCongViec(
    RefreshCongViec event,
    Emitter<CongViecState> emit,
  ) async {
    if (state is CongViecLoaded) {
      final currentState = state as CongViecLoaded;
      try {
        emit(CongViecLoading());
        final congViecs = await repository.fetchCongViec(
          groupId: currentState.congViecs.first.groupId,
          nguoiThucHien: currentState.congViecs.first.nguoiThucHien,
        );
        emit(CongViecLoaded(
          congViecs: congViecs,
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        emit(CongViecError(
          e.toString(),
          errorTime: DateTime.now(),
        ));
        emit(currentState);
      }
    }
  }

  Future<void> _onGetCongViecByVM(
    GetCongViecByVM event,
    Emitter<CongViecState> emit,
  ) async {
    emit(CongViecLoading());
    try {
      final congViecs = await repository.getCongViecByVM(event.congViec);
      emit(CongViecByVMLoaded(
        congViecs: congViecs,
        groupId: event.congViec.groupId,
      ));
    } catch (e) {
      emit(CongViecError(
        e.toString(),
        errorTime: DateTime.now(),
      ));
    }
  }

  Future<void> _onGetAllNVTH(
    getAllNVTH event,
    Emitter<CongViecState> emit,
  ) async {
    try {
      final nvths = await repository.getAllNVTH(event.groupId, event.nvths);
      emit(getAllNVTHLoaded(
        nvths: nvths,
        groupId: event.groupId,
      ));
    } catch (e) {
      emit(CongViecError(
        e.toString(),
        errorTime: DateTime.now(),
      ));
    }
  }

  Future<void> _onUploadFile(
  UploadFileEvent event,
  Emitter<CongViecState> emit,
  ) async {
    emit(CongViecLoading());
    try {
      final url = await repository.uploadFile(event.file); // trả về url từ server
      emit(UploadFile(event.file, url!));
    } catch (e) {
      emit(CongViecError("Upload thất bại: ${e.toString()}", errorTime: DateTime.now()));
    }
  }

  Future<void> _onLoadCVCByIdCV(
    LoadCVCByIdCVEvent event,
    Emitter<CongViecState> emit,
  ) async {
    try {
      final cvc_repository = await repository.LoadCVCByIdCV(event.id_CongViec);
      emit(LoadCVCByIdCV(
        cvc_repository,
      ));
    } catch (e) {
      emit(CongViecError(
        e.toString(),
        errorTime: DateTime.now(),
      ));
    }
  }

  @override
  Future<void> close() {
    _congViecSubscription?.cancel();
    return super.close();
  }
}
