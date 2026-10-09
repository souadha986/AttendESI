import 'package:admin/features/historique_notification/model/notification_model.dart';

abstract class GetNotificationsState {}

class GetNotificationsInitial extends GetNotificationsState {}

class GetNotificationsLoadingState extends GetNotificationsState {}

class GetNotificationsSuccessState extends GetNotificationsState {
  final List<NotificationModel> notifications;
  GetNotificationsSuccessState(this.notifications);
}

class GetNotificationsErrorState extends GetNotificationsState {
  final String error;
  GetNotificationsErrorState(this.error);
}