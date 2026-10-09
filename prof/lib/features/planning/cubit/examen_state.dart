import 'package:prof/features/planning/models/examen_model.dart';

abstract class ExamenState {}

class ExamenInitial extends ExamenState {}

class ExamenLoading extends ExamenState {}

class ExamenSuccess extends ExamenState {
  final List<ExamenModel> exams;
  ExamenSuccess(this.exams);
}

class ExamenError extends ExamenState {
  final String message;
  ExamenError(this.message);
}
