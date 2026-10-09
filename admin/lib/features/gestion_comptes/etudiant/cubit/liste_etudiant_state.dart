import 'package:admin/features/gestion_comptes/etudiant/models/etudiant_model.dart';

abstract class EtudiantState {}

class EtudiantInitial extends EtudiantState {}

class EtudiantLoading extends EtudiantState {}

class EtudiantLoaded extends EtudiantState {
  final List<EtudiantModel> etudiants;

  final List<EtudiantModel> filtered;

  EtudiantLoaded({required this.etudiants, List<EtudiantModel>? filtered})
    : filtered = filtered ?? etudiants;
}

class EtudiantError extends EtudiantState {
  final String message;

  EtudiantError(this.message);
}
