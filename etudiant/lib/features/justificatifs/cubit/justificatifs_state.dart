import 'package:etudiant/features/justificatifs/models/justification.dart';

abstract class JustificationState {}

class InitialState extends JustificationState {}

class LoadingState extends JustificationState {}

class LoadedState extends JustificationState {
  final List<Justification> products;
  LoadedState(this.products);
}

class DeleteLoadingState extends JustificationState {}

class DeleteSuccessState extends JustificationState {
  final String error;
  DeleteSuccessState(this.error);
}

class DeleteErrorState extends JustificationState {
  final String error;
  DeleteErrorState(this.error);
}

class ErrorState extends JustificationState {
  final String error;
  ErrorState(this.error);
}
