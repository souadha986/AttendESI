abstract class SoumettreState {}

class SoumettreInitial extends SoumettreState {}

class SoumettreLoading extends SoumettreState {}

class SoumettreSuccess extends SoumettreState {
  final String message;
  SoumettreSuccess(this.message);
}

class SoumettreError extends SoumettreState {
  final String message;
  SoumettreError(this.message);
}
