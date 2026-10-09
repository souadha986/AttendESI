import 'package:scolarite/features/justificatifs/models/justificatifs_model.dart';

abstract class RefusState {}

class RefusInitial extends RefusState {}

class RefusLoading extends RefusState {}

class RefusSuccess extends RefusState {
  final JustificatifTraitement justificatif;

  RefusSuccess(this.justificatif);
}
class RefusError extends RefusState {
  final String message;
  RefusError(this.message);
}