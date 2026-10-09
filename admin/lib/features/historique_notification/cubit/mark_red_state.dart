import 'package:admin/features/historique_notification/model/notification_model.dart';

abstract class MarkAsReadState {}

class MarkAsReadInitial extends MarkAsReadState {}

class MarkAsReadLoadingState extends MarkAsReadState {}

class MarkAsReadSuccessState extends MarkAsReadState {
  final NotificationDetailModel notification;
  MarkAsReadSuccessState(this.notification);
}

class MarkAsReadErrorState extends MarkAsReadState {
  final String error;
  MarkAsReadErrorState(this.error);
}