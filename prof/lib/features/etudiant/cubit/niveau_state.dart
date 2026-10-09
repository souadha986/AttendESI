abstract class NiveauState {}

class Niveauinitailstate extends NiveauState {}

class NiveauLoading extends NiveauState {}

class NiveauLoaded extends NiveauState {
  final List<String> niveaux;
  NiveauLoaded(this.niveaux);
}

class NiveauError extends NiveauState {
  final String error;
  NiveauError(this.error);
}
