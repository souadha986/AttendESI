abstract class AddEtudiantState {}

class AddEtudiantInitial extends AddEtudiantState {}

class AddEtudiantLoading extends AddEtudiantState {}

class AddEtudiantSuccess extends AddEtudiantState {
  final String message;
  AddEtudiantSuccess(this.message);
}

class AddEtudiantError extends AddEtudiantState {
  final String message;
  AddEtudiantError(this.message);
}
