abstract class ArchiveEtudiantState {}

class ArchiveEtudiantInitial extends ArchiveEtudiantState {}

class ArchiveEtudiantLoading extends ArchiveEtudiantState {}

class ArchiveEtudiantSuccess extends ArchiveEtudiantState {}

class ArchiveEtudiantError extends ArchiveEtudiantState {
  final String message;
  ArchiveEtudiantError(this.message);
}
