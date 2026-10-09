abstract class DeleteProfState {}

class DeleteProfInitial extends DeleteProfState {}

class DeleteProfLoading extends DeleteProfState {}

class DeleteProfSuccess extends DeleteProfState {}

class DeleteProfError extends DeleteProfState {
  final String message;
  DeleteProfError(this.message);
}
