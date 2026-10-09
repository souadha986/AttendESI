import 'package:scolarite/features/justificatifs/models/justificatifs_model.dart';

abstract class JustificatifDetailsState {}

class JustificatifDetailsInitial extends JustificatifDetailsState {}

class JustificatifDetailsLoadingState extends JustificatifDetailsState {}

class JustificatifDetailsSuccessState extends JustificatifDetailsState {
  final JustificatifDetails justificatif;

  JustificatifDetailsSuccessState(this.justificatif);
}

class JustificatifDetailsErrorState extends JustificatifDetailsState {
  final String error;

  JustificatifDetailsErrorState(this.error);
}