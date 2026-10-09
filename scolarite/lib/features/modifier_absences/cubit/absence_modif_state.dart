
import 'package:scolarite/features/modifier_absences/models/absence_modif_models.dart';

abstract class AbsenceModifState {}

class AbsenceModifInitial extends AbsenceModifState {}

class AbsenceModifLoadingState extends AbsenceModifState {}

class AbsenceModifSuccessState extends AbsenceModifState {
  final AbsenceModifModels data;

  AbsenceModifSuccessState(this.data);
}

class AbsenceModifErrorState extends AbsenceModifState {
  final String error;

  AbsenceModifErrorState(this.error);
}