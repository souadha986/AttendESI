import 'package:etudiant/features/home/models/alerte_model.dart';

abstract class AlertState {}

class AlertInitialState extends AlertState {}

class AlertLoadingState extends AlertState {}

class AlertSuccessState extends AlertState {
  final List<AlertModel> alerts;
  AlertSuccessState(this.alerts);
}

class AlertErrorState extends AlertState {
  final String error;
  AlertErrorState(this.error);
}

class AlertEmptyState extends AlertState {}

class AlertMarkedReadState extends AlertState {}
