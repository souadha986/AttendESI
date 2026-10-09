import 'package:prof/features/etudiant/module/etudiant.dart';
import 'package:prof/features/etudiant/module/etudiant_modifier.dart';

abstract class EtudiantState {
  const EtudiantState();
}

class EtudiantInitial extends EtudiantState {
  const EtudiantInitial();
}

class EtudiantLoading extends EtudiantState {
  const EtudiantLoading();
}

class EtudiantLoaded extends EtudiantState {
  final List<Etudiant> etudiants;
  const EtudiantLoaded(this.etudiants);
}

class EtudiantModifierLoaded extends EtudiantState {
  final List<EtudiantModifier> etudiant;
  const EtudiantModifierLoaded(this.etudiant);
}

class EtudiantError extends EtudiantState {
  final String error;
  const EtudiantError(this.error);
}
