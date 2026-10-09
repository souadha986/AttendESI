abstract class ScolariteupdateState {}

class ScolariteupdateInitial extends ScolariteupdateState {}

class ScolariteupdateLoading extends ScolariteupdateState {}

class ScolariteupdateError extends ScolariteupdateState {
  final String message;
  ScolariteupdateError(this.message);
}

class ScolariteUpdateSuccess extends ScolariteupdateState {
  final String message;
  ScolariteUpdateSuccess(this.message);
}
