abstract class UpdateState {}

class Updateinitial extends UpdateState {}

class UpdateLoadingState extends UpdateState {}

class UpdateSuccessState extends UpdateState {
  final String message;
  UpdateSuccessState(this.message);
}

class UpdateErrorState extends UpdateState {
  final String error;
  UpdateErrorState(this.error);
}
