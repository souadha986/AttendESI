// Base state

import 'package:etudiant/features/auth/login/models/auth_tokens.dart';

abstract class AuthState {}

// Initial state
class InitialState extends AuthState {}

// Loading state
class LoadingState extends AuthState {}

// Success state returns tokens
class SuccessState extends AuthState {
  final AuthTokens tokens; // Ce n'est plus une String, mais ton modèle

  SuccessState(this.tokens);
}

// Error state
class ErrorState extends AuthState {
  final String error;
  ErrorState(this.error);
}
