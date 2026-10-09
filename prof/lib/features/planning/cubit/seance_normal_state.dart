import 'package:prof/features/planning/models/seance_normale_model.dart';

abstract class SeanceNormaleState {}

class NormalPlanningInitial extends SeanceNormaleState {}

class NormalPlanningLoading extends SeanceNormaleState {}

class NormalPlanningSuccess extends SeanceNormaleState {
  final List<SeanceNormaleModel> planning;
  NormalPlanningSuccess(this.planning);
}

class NormalPlanningError extends SeanceNormaleState {
  final String message;
  NormalPlanningError(this.message);
}
