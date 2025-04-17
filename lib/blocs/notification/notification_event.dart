import 'package:ducanherp/models/notification_model.dart';

abstract class NotificationEvent {}

class SendNotificationEvent extends NotificationEvent {
  final List<String> userIds;
  final String title;
  final String body;

  SendNotificationEvent({
    required this.userIds,
    required this.title,
    required this.body,
  });
}

class RegisterTokenEvent extends NotificationEvent {
  final String token;
  final String groupId;
  final String userId;

  RegisterTokenEvent({
    required this.token,
    required this.groupId,
    required this.userId,
  });
}

class UpdateNotificationEvent extends NotificationEvent {
  final NotificationModel notifi;
  UpdateNotificationEvent({required this.notifi});
}

class GetAllNotiByUserEvent extends NotificationEvent {
  GetAllNotiByUserEvent();
}
