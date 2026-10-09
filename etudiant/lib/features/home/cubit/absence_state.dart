import 'package:etudiant/features/home/models/absence_model.dart';

abstract class AbsenceState {}

class AbsenceInitial extends AbsenceState {}

class AbsenceLoadingState extends AbsenceState {}

class AbsenceSuccessState extends AbsenceState {
  final List<AbsenceModuleModel> modules;
  AbsenceSuccessState(this.modules);
}

class AbsenceErrorState extends AbsenceState {
  final String error;
  AbsenceErrorState(this.error);
}
