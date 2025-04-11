import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ducanherp/blocs/download/download_event.dart';
import 'package:ducanherp/blocs/download/download_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc() : super(DownloadInitial()) {
    on<StartDownload>(_onDownload);
  }

  Future<void> _onDownload(StartDownload event, Emitter<DownloadState> emit) async {
    emit(DownloadInProgress());

    try {
      // Xin quyền
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          emit(DownloadFailure("Permission denied"));
          return;
        }
      }

      // Đường dẫn
      Directory dir = Platform.isAndroid
          ? Directory("/storage/emulated/0/Download")
          : await getApplicationDocumentsDirectory();

      String fullPath = '${dir.path}/${event.fileName}';
      Dio dio = Dio();
      await dio.download(event.url, fullPath);

      emit(DownloadSuccess());
    } catch (e) {
      emit(DownloadFailure(e.toString()));
    }
  }
}
