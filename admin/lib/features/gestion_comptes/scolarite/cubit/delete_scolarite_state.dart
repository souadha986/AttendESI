abstract class DeleteScolariteState {}

class DeleteScolariteInitial extends DeleteScolariteState {}

class DeleteScolariteLoading extends DeleteScolariteState {}

class DeleteScolariteSuccess extends DeleteScolariteState {}

class DeleteScolariteError extends DeleteScolariteState {
  final String message;
  DeleteScolariteError(this.message);
}
