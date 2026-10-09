abstract class MarquerAbsenceState {
  const MarquerAbsenceState();
}

class MarquerAbsenceInitial extends MarquerAbsenceState {
  const MarquerAbsenceInitial();
}

class MarquerAbsenceLoading extends MarquerAbsenceState {
  const MarquerAbsenceLoading();
}

class MarquerAbsenceSuccess extends MarquerAbsenceState {
  final String success;
  const MarquerAbsenceSuccess(this.success);
}

class MarquerAbsenceError extends MarquerAbsenceState {
  final String error;
  const MarquerAbsenceError(this.error);
}
