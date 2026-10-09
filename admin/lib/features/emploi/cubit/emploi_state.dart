import 'package:admin/features/emploi/models/emploi_model.dart';
import 'package:admin/features/emploi/models/examen_model.dart';

abstract class EmploiState {}

class EmploiInitial extends EmploiState {}

// ── Normal schedule ────────────────────────────────────────────────────────

class EmploiNormalLoadingState extends EmploiState {}

class EmploiNormalSuccessState extends EmploiState {
  final EmploiNormalModel emploi;
  EmploiNormalSuccessState(this.emploi);
}

class EmploiNormalErrorState extends EmploiState {
  final String error;
  EmploiNormalErrorState(this.error);
}

// ── Exam schedule ──────────────────────────────────────────────────────────

class EmploiExamenLoadingState extends EmploiState {}

class EmploiExamenSuccessState extends EmploiState {
  final EmploiExamenModel examens;
  EmploiExamenSuccessState(this.examens);
}

class EmploiExamenErrorState extends EmploiState {
  final String error;
  EmploiExamenErrorState(this.error);
}

// ── Replacement schedule ───────────────────────────────────────────────────

class EmploiRemplacementLoadingState extends EmploiState {}

class EmploiRemplacementSuccessState extends EmploiState {
  final EmploiExamenModel remplacements; 
  EmploiRemplacementSuccessState(this.remplacements);
}

class EmploiRemplacementErrorState extends EmploiState {
  final String error;
  EmploiRemplacementErrorState(this.error);
}