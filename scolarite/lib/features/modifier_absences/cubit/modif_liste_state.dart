

import 'package:scolarite/features/modifier_absences/models/absence_modif_models.dart';

abstract class ModifListeState {}

class ModifListeInitial extends ModifListeState {}

class ModifListeLoadingState extends ModifListeState {}

class ModifListeSuccessState extends ModifListeState {
  final ModifListeModel data;

  ModifListeSuccessState(this.data);
}

class ModifListeErrorState extends ModifListeState {
  final String error;

  ModifListeErrorState(this.error);
}