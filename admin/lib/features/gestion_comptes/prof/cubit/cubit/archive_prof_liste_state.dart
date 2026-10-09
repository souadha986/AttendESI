import 'package:admin/features/gestion_comptes/prof/models/prof_model.dart';

abstract class ProfArcheive {}

class ProfArcheiveInitial extends ProfArcheive {}

class ProfArcheiveLoading extends ProfArcheive {}

class ProfArcheiveLoaded extends ProfArcheive {
  final List<ProfModel> Profs;

  final List<ProfModel> filtered;

  ProfArcheiveLoaded({required this.Profs, List<ProfModel>? filtered})
    : filtered = filtered ?? Profs;
}

class ProfArcheiveError extends ProfArcheive {
  final String message;

  ProfArcheiveError(this.message);
}
