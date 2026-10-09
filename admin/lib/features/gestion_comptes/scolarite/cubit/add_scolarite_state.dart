abstract class AddScolariteState {}

class AddScolariteInitial extends AddScolariteState {}

class AddScolariteLoading extends AddScolariteState {}

class AddScolariteSuccess extends AddScolariteState {
  final String message;
  AddScolariteSuccess(this.message);
}

class AddScolariteError extends AddScolariteState {
  final String message;
  AddScolariteError(this.message);
}
