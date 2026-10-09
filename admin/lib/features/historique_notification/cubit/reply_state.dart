import 'package:admin/features/historique_notification/model/notification_model.dart';


abstract class SendNotificationState {}

class SendNotificationInitial extends SendNotificationState {}

class SendNotificationLoadingState extends SendNotificationState {}

class SendNotificationSuccessState extends SendNotificationState {
  final SendNotificationResponseModel response;
  SendNotificationSuccessState(this.response);
}

class SendNotificationErrorState extends SendNotificationState {
  final String error;
  SendNotificationErrorState(this.error);
}