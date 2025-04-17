import 'package:ducanherp/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final String message;

  NotificationSuccess(this.message);
}

class GetAllNotiByUserSuccessSate extends NotificationState {
  final List<NotificationModel> notifi;
  GetAllNotiByUserSuccessSate(this.notifi);
}

class NotificationError extends NotificationState {
  final String error;

  NotificationError(this.error);
}
