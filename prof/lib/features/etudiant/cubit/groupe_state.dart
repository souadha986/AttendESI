abstract class GroupeState {}

class Groupeinitailstate extends GroupeState {}

class GroupeLoading extends GroupeState {}

class GroupeLoaded extends GroupeState {
  final List<String> groupes;
  GroupeLoaded(this.groupes);
}

class GroupeError extends GroupeState {
  final String error;
  GroupeError(this.error);
}
