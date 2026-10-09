import 'package:etudiant/features/planning/models/examen_model.dart';

abstract class RemplacementState1 {}

class RemplacmentInitial extends RemplacementState1 {}

class RemplacementLoading extends RemplacementState1 {}

class RemplacementSuccess extends RemplacementState1 {
  final List<ExamModel> exams;
  RemplacementSuccess(this.exams);
}

class RemplacementError extends RemplacementState1 {
  final String message;
  RemplacementError(this.message);
}
