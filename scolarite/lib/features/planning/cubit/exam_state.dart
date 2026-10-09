import 'package:scolarite/features/planning/models/planning_models.dart';

abstract class ExamState {}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamSuccess extends ExamState {
  final ExamPlanning examPlanning;

  ExamSuccess(this.examPlanning);
}

class ExamError extends ExamState {
  final String message;

  ExamError(this.message);
}