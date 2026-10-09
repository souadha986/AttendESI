import 'package:etudiant/features/planning/models/seance_normal_model.dart';

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
