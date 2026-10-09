abstract class AbsencesValidateState {}

/// INITIAL
class AbsencesValidateInitial extends AbsencesValidateState {}

/// LOADING
class AbsencesValidateLoading extends AbsencesValidateState {}

/// SUCCESS
class AbsencesValidateSuccess extends AbsencesValidateState {
  final String message;
  final int? id;

  AbsencesValidateSuccess({
    required this.message,
    this.id,
  });
}

/// ERROR
class AbsencesValidateError extends AbsencesValidateState {
  final String error;

  AbsencesValidateError(this.error);
}