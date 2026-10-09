abstract class SpecialiteState {}

class SpecialiteInitial extends SpecialiteState {}

class SpecialiteLoading extends SpecialiteState {}

class SpecialiteSuccess extends SpecialiteState {
  final List<String> specialites;

  SpecialiteSuccess(this.specialites);
}

class SpecialiteError extends SpecialiteState {
  final String error;

  SpecialiteError(this.error);
}