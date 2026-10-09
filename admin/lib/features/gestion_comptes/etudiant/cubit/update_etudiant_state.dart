abstract class EtudintupdateState {}

class EtudintupdateInitial extends EtudintupdateState {}

class EtudintupdateLoading extends EtudintupdateState {}

class EtudintupdateError extends EtudintupdateState {
  final String message;
  EtudintupdateError(this.message);
}

class EtudiantUpdateSuccess extends EtudintupdateState {
  final String message;
  EtudiantUpdateSuccess(this.message);
}
