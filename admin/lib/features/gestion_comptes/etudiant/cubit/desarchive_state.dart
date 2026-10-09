abstract class desarchiveEtudiantState {}

class desarcheiveEtudiantInitial extends desarchiveEtudiantState {}

class desarcheiveEtudiantLoading extends desarchiveEtudiantState {}

class desarcheiveEtudiantSuccess extends desarchiveEtudiantState {}

class desarcheiveEtudiantError extends desarchiveEtudiantState {
  final String message;
  desarcheiveEtudiantError(this.message);
}
