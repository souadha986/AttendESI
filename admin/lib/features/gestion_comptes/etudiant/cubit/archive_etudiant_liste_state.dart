import 'package:admin/features/gestion_comptes/etudiant/models/etudiant_model.dart';

abstract class EtudiantArcheive {}

class EtudiantArcheiveInitial extends EtudiantArcheive {}

class EtudiantArcheiveLoading extends EtudiantArcheive {}

class EtudiantArcheiveLoaded extends EtudiantArcheive {
  final List<EtudiantModel> etudiants;

  final List<EtudiantModel> filtered;

  EtudiantArcheiveLoaded({
    required this.etudiants,
    List<EtudiantModel>? filtered,
  }) : filtered = filtered ?? etudiants;
}

class EtudiantArcheiveError extends EtudiantArcheive {
  final String message;

  EtudiantArcheiveError(this.message);
}
