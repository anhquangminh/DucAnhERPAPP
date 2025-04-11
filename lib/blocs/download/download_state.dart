abstract class DownloadState {}

class DownloadInitial extends DownloadState {}

class DownloadInProgress extends DownloadState {}

class DownloadSuccess extends DownloadState {}

class DownloadFailure extends DownloadState {
  final String error;
  DownloadFailure(this.error);
}
