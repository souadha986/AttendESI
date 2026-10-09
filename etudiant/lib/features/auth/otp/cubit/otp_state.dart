// Base state

abstract class OtpState {}

// Initial state
class InitialState extends OtpState {}

class PasswordResetSuccessState extends OtpState {
  final String message;
  PasswordResetSuccessState(this.message);
}

// Loading state
class LoadingState extends OtpState {}

// Success state returns tokens
class SuccessState extends OtpState {
  final String successMessage;
  SuccessState(this.successMessage);
}

class ResendOtpSuccessState extends OtpState {
  final String message;
  ResendOtpSuccessState(this.message);
}

// Error state
class ErrorState extends OtpState {
  final String error;
  ErrorState(this.error);
}
