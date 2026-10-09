abstract class NiveauState {}

class NiveauInitial extends NiveauState {}

class NiveauLoading extends NiveauState {}

class NiveauSuccess extends NiveauState {
  final List<String> niveaux;

  NiveauSuccess(this.niveaux);
}

class NiveauError extends NiveauState {
  final String error;
  NiveauError(this.error);
}
