import 'package:admin/features/gestion_comptes/prof/models/import_prof_model.dart';

abstract class ImportProfState {}

class ImportProfInitial extends ImportProfState {}

class ImportProfLoading extends ImportProfState {}

class ImportProfSuccess extends ImportProfState {
  final ImportProfModel result;
  ImportProfSuccess(this.result);
}

class ImportProfError extends ImportProfState {
  final String message;
  ImportProfError(this.message);
}