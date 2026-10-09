abstract class DeleteEtudiantState {}

class DeleteEtudiantInitial extends DeleteEtudiantState {}

class DeleteEtudiantLoading extends DeleteEtudiantState {}

class DeleteEtudiantSuccess extends DeleteEtudiantState {}

class DeleteEtudiantError extends DeleteEtudiantState {
  final String message;
  DeleteEtudiantError(this.message);
}
