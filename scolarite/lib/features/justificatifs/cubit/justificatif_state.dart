import 'package:scolarite/features/justificatifs/models/justificatifs_model.dart';

abstract class JustificatifsState {}

class JustificatifsInitial extends JustificatifsState {}

class JustificatifsLoadingState extends JustificatifsState {}

class JustificatifsSuccessState extends JustificatifsState {
  final List<JustificatifsModel> justificatifs;

  JustificatifsSuccessState(this.justificatifs);
}

class JustificatifsErrorState extends JustificatifsState {
  final String error;

  JustificatifsErrorState(this.error);
}