// Base state


abstract class AuthState {}

// Initial state
class InitialState extends AuthState {}

// Loading state
class LoadingState extends AuthState {}

// Success state returns tokens
class SuccessState extends AuthState {
  final String tokens;
  SuccessState(this.tokens);
}

// Error state
class ErrorState extends AuthState {
  final String error;
  ErrorState(this.error);
}