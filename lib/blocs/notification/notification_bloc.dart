import 'package:ducanherp/blocs/notification/notification_reponsitory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc({required this.repository}) : super(NotificationInitial()) {
    // Xử lý sự kiện gửi thông báo
    on<SendNotificationEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final message = await repository.sendNotification(
          userIds: event.userIds,
          title: event.title,
          body: event.body,
        );
        emit(NotificationSuccess(message));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    // Xử lý sự kiện đăng ký token
    on<RegisterTokenEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final message = await repository.registerToken(
          token: event.token,
          groupId: event.groupId,
          userId: event.userId,
        );
        emit(NotificationSuccess(message));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
    
    on<UpdateNotificationEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
       await repository.updateNotification(notifi:  event.notifi);
       final message = await repository.getAllNotiByUser();
       emit(GetAllNotiByUserSuccessSate(message));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<GetAllNotiByUserEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final message = await repository.getAllNotiByUser();
        emit(GetAllNotiByUserSuccessSate(message));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
    
  }
}
