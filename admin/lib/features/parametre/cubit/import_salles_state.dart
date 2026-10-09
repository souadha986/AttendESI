import 'package:admin/features/parametre/model/import_salles_model.dart';

abstract class ImportSallesState {}

class ImportSallesInitial extends ImportSallesState {}

class ImportSallesLoading extends ImportSallesState {}

class ImportSallesSuccess extends ImportSallesState {
  final ImportSallesModel result;
  ImportSallesSuccess(this.result);
}

class ImportSallesError extends ImportSallesState {
  final String message;
  ImportSallesError(this.message);
}