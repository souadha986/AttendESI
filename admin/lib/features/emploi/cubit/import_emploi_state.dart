import 'package:admin/features/emploi/models/import_emploi_model.dart';

abstract class ImportEmploiState {}

class ImportEmploiInitial extends ImportEmploiState {}

class ImportEmploiLoading extends ImportEmploiState {}

class ImportEmploiSuccess extends ImportEmploiState {
  final ImportEmploiModel result;
  ImportEmploiSuccess(this.result);
}

class ImportEmploiError extends ImportEmploiState {
  final String message;
  ImportEmploiError(this.message);
}