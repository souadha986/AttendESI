import 'package:scolarite/features/modifier_absences/models/absence_modif_models.dart';

abstract class ModifierState {}

class ModifierInitial extends ModifierState {}

class ModifierLoadingState extends ModifierState {}

class ModifierSuccessState extends ModifierState {
  final ModifAbsenceResponse data;

  ModifierSuccessState(this.data);
}

class ModifierErrorState extends ModifierState {
  final String error;

  ModifierErrorState(this.error);
}