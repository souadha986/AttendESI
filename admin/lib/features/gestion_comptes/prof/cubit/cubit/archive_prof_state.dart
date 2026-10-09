abstract class ArchiveProfState {}

class ArchiveProfInitial extends ArchiveProfState {}

class ArchiveProfLoading extends ArchiveProfState {}

class ArchiveProfSuccess extends ArchiveProfState {}

class ArchiveProfError extends ArchiveProfState {
  final String message;
  ArchiveProfError(this.message);
}
