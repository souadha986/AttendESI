import 'package:admin/features/emploi/models/import_examen_model.dart';

abstract class ImportExamenState {}

class ImportExamenInitial extends ImportExamenState {}

// ── EMD ──
class ImportExamenEmdLoading extends ImportExamenState {}

class ImportExamenEmdSuccess extends ImportExamenState {
  final ImportExamenModel result;
  ImportExamenEmdSuccess(this.result);
}

class ImportExamenEmdError extends ImportExamenState {
  final String message;
  ImportExamenEmdError(this.message);
}

// ── Remplacement ──
class ImportExamenRemplacementLoading extends ImportExamenState {}

class ImportExamenRemplacementSuccess extends ImportExamenState {
  final ImportExamenModel result;
  ImportExamenRemplacementSuccess(this.result);
}

class ImportExamenRemplacementError extends ImportExamenState {
  final String message;
  ImportExamenRemplacementError(this.message);
}