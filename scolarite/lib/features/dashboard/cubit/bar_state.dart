import 'package:scolarite/features/dashboard/models/dashboard_models.dart';

abstract class BarState {}

class BarInitial extends BarState {}

class BarLoadingState extends BarState {}

class BarSuccessState extends BarState {
  final BarModel barModel;
  BarSuccessState(this.barModel);
}

class BarErrorState extends BarState {
  final String error;
  BarErrorState(this.error);
}