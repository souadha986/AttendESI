import 'package:admin/features/gestion_comptes/prof/models/prof_model.dart';

abstract class ProfState {}

class ProfInitial extends ProfState {}

class ProfLoading extends ProfState {}

class ProfLoaded extends ProfState {
  final List<ProfModel> Profs;

  final List<ProfModel> filtered;

  ProfLoaded({required this.Profs, List<ProfModel>? filtered})
    : filtered = filtered ?? Profs;
}

class ProfError extends ProfState {
  final String message;

  ProfError(this.message);
}
