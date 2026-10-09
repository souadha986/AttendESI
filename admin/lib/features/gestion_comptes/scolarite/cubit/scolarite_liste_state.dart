import 'package:admin/features/gestion_comptes/scolarite/models/scolarite_model.dart';

abstract class ScolariteState {}

class ScolariteInitial extends ScolariteState {}

class ScolariteLoading extends ScolariteState {}

class ScolariteLoaded extends ScolariteState {
  final List<ScolariteModel> Scolarites;

  final List<ScolariteModel> filtered;

  ScolariteLoaded({required this.Scolarites, List<ScolariteModel>? filtered})
    : filtered = filtered ?? Scolarites;
}

class ScolariteError extends ScolariteState {
  final String message;

  ScolariteError(this.message);
}
