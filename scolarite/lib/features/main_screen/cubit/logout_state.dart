abstract class LogoutState {}

class LogoutInitialState extends LogoutState {}

class LogoutLoadingState extends LogoutState {}

class LogoutSuccessState extends LogoutState {
  final String message;
  LogoutSuccessState(this.message);
}

class LogoutErrorState extends LogoutState {
  final String error;
  LogoutErrorState(this.error);
}
