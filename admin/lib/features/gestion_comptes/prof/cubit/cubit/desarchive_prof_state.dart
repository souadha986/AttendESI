abstract class desarchiveProfState {}

class desarcheiveProfInitial extends desarchiveProfState {}

class desarcheiveProfLoading extends desarchiveProfState {}

class desarcheiveProfSuccess extends desarchiveProfState {}

class desarcheiveProfError extends desarchiveProfState {
  final String message;
  desarcheiveProfError(this.message);
}
