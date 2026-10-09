import 'package:admin/features/gestion_comptes/etudiant/models/import_etudiant_model.dart';

abstract class ImportEtudiantState {}

class ImportEtudiantInitial extends ImportEtudiantState {}

class ImportEtudiantLoading extends ImportEtudiantState {}

class ImportEtudiantSuccess extends ImportEtudiantState {
  final ImportEtudiantModel result;
  ImportEtudiantSuccess(this.result);
}

class ImportEtudiantError extends ImportEtudiantState {
  final String message;
  ImportEtudiantError(this.message);
}