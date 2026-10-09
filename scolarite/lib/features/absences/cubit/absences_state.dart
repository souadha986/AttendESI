

import 'package:scolarite/features/absences/models/absence_models.dart';

abstract class AbsenceState {}

class AbsenceInitial extends AbsenceState {}

class AbsenceLoading extends AbsenceState {}

class AbsenceSuccess extends AbsenceState {
  final AbsenceModels data;
  AbsenceSuccess(this.data);
}

class AbsenceError extends AbsenceState {
  final String error;
  AbsenceError(this.error);
}