import 'package:prof/features/etudiant/module/remplcement_model.dart';

abstract class RemplacementState {}

class EligibleAbsentsInitial extends RemplacementState {}

class EligibleAbsentsLoading extends RemplacementState {}

class EligibleAbsentsSuccess extends RemplacementState {
  final List<RemplacementModel> students;
  EligibleAbsentsSuccess(this.students);
}

class EligibleAbsentsError extends RemplacementState {
  final String message;
  EligibleAbsentsError(this.message);
}
