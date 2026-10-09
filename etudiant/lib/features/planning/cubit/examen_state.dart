import 'package:etudiant/features/planning/models/examen_model.dart';

abstract class ExamenState {}

class ExamenInitial extends ExamenState {}

class ExamenLoading extends ExamenState {}

class ExamenSuccess extends ExamenState {
  final List<ExamModel> exams;
  ExamenSuccess(this.exams);
}

class ExamenError extends ExamenState {
  final String message;
  ExamenError(this.message);
}
