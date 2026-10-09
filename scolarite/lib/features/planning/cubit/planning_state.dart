import 'package:scolarite/features/planning/models/planning_models.dart';

abstract class PlanningState {}

class PlanningInitial extends PlanningState {}

class PlanningLoading extends PlanningState {}

class PlanningSuccess extends PlanningState {
  final NormalPlanning planning;

  PlanningSuccess(this.planning);
}

class PlanningError extends PlanningState {
  final String message;

  PlanningError(this.message);
}