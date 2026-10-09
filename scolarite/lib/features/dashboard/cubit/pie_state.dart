import 'package:scolarite/features/dashboard/models/dashboard_models.dart';

abstract class PieState {}

class PieInitial extends PieState {}

class PieLoadingState extends PieState {}
class PieSuccessState extends PieState {
  final PieModel? normale;
  final PieModel? examen;

  PieSuccessState({
    this.normale,
    this.examen,
  });
}

class PieErrorState extends PieState {
  final String error;

  PieErrorState(this.error);
}