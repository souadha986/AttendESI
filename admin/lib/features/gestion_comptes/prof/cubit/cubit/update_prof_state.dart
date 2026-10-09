abstract class ProfupdateState {}

class ProfupdateInitial extends ProfupdateState {}

class ProfupdateLoading extends ProfupdateState {}

class ProfupdateError extends ProfupdateState {
  final String message;
  ProfupdateError(this.message);
}

class ProfUpdateSuccess extends ProfupdateState {
  final String message;
  ProfUpdateSuccess(this.message);
}
