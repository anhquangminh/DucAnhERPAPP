abstract class DownloadEvent {}

class StartDownload extends DownloadEvent {
  final String url;
  final String fileName;
  StartDownload(this.url, this.fileName);
}
