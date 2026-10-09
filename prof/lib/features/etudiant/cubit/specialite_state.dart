abstract class SpecialiteState {}

class Specialiteinitial extends SpecialiteState {}

class SpecialiteLoading extends SpecialiteState {}

class SpecialiteLoaded extends SpecialiteState {
  final List<String> specialities;
  SpecialiteLoaded(this.specialities);
}

class SpecialiteError extends SpecialiteState {
  final String error;
  SpecialiteError(this.error);
}
