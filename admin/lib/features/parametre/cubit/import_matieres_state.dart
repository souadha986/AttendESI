import 'package:admin/features/parametre/model/import_matieres_model.dart';

abstract class ImportMatieresState {}

class ImportMatieresInitial extends ImportMatieresState {}

class ImportMatieresLoading extends ImportMatieresState {}

class ImportMatieresSuccess extends ImportMatieresState {
  final ImportMatieresModel result;
  ImportMatieresSuccess(this.result);
}

class ImportMatieresError extends ImportMatieresState {
  final String message;
  ImportMatieresError(this.message);
}