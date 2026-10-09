import 'package:scolarite/features/historique_notification/models/notif_models.dart';


abstract class NotifState {}

class NotifInitial extends NotifState {}

class NotifLoadingState extends NotifState {}

class NotifSuccessState extends NotifState {
  final NotifModel notif;
  NotifSuccessState(this.notif);
}

class NotifErrorState extends NotifState {
  final String error;
  NotifErrorState(this.error);
}