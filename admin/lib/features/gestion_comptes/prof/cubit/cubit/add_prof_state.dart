abstract class AddProfState {}

class AddProfInitial extends AddProfState {}

class AddProfLoading extends AddProfState {}

class AddProfSuccess extends AddProfState {
  final String message;
  AddProfSuccess(this.message);
}

class AddProfError extends AddProfState {
  final String message;
  AddProfError(this.message);
}
