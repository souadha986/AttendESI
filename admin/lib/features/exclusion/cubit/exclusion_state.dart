import 'package:admin/features/exclusion/model/detail_model.dart';
import 'package:admin/features/exclusion/model/exclusion_table_model.dart';

abstract class ExclusionState {}

class ExclusionInitial extends ExclusionState {}

class ExclusionLoading extends ExclusionState {}

class ExclusionLoaded extends ExclusionState {
  final List<EtudiantEnAlerteModel> etudiants;
  final List<EtudiantEnAlerteModel> filtered;

  ExclusionLoaded({
    required this.etudiants,
    List<EtudiantEnAlerteModel>? filtered,
  }) : filtered = filtered ?? etudiants;
}

class ExclusionError extends ExclusionState {
  final String message;
  ExclusionError(this.message);
}

// ── Recherche ────────────────────────────────────────────────────────────────

class ExclusionSearching extends ExclusionState {}  

class ExclusionSearchLoaded extends ExclusionState {
  final List<EtudiantEnAlerteModel> results;
  ExclusionSearchLoaded(this.results);
}

class ExclusionSearchError extends ExclusionState {
  final String message;
  ExclusionSearchError(this.message);
}


// ── États pour le dossier détaillé ──────────────────────────────────────────

class DossierLoading extends ExclusionState {}

class DossierLoaded extends ExclusionState {
  final DetailModel dossier;
  DossierLoaded(this.dossier);
}

class DossierError extends ExclusionState {
  final String message;
  DossierError(this.message);
}