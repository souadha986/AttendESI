import 'package:scolarite/features/justificatifs/models/justificatifs_model.dart';

abstract class ValiderState {}

class ValiderInitial extends ValiderState {}

class ValiderLoading extends ValiderState {}

class ValiderSuccess extends ValiderState {
  final JustificatifTraitement justificatif;

  ValiderSuccess(this.justificatif);
}

class ValiderError extends ValiderState {
  final String message;

  ValiderError(this.message);
}