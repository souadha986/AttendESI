import 'package:admin/features/exclusion/model/seuil_congif_model.dart';

abstract class SeuilState {}

// ── GET ────────────────────────────────────────────────────────────────────
class SeuilInitial extends SeuilState {}

class SeuilLoading extends SeuilState {}

class SeuilLoaded extends SeuilState {
  final SeuilModel seuil;
  SeuilLoaded(this.seuil);
}

class SeuilError extends SeuilState {
  final String message;
  SeuilError(this.message);
}

// ── POST ───────────────────────────────────────────────────────────────────
class SeuilSaving extends SeuilState {
  /// On garde l'ancienne valeur affichée pendant la sauvegarde
  final SeuilModel current;
  SeuilSaving(this.current);
}

class SeuilSaved extends SeuilState {
  final SeuilModel updated;
  final String message;
  SeuilSaved({required this.updated, required this.message});
}

class SeuilSaveError extends SeuilState {
  final SeuilModel current; // pour ne pas perdre l'affichage
  final String message;
  SeuilSaveError({required this.current, required this.message});
}