import 'package:prof/features/etudiant/module/student_model.dart';

abstract class ListeEtudiantState {}

class ListeEtudiantInitial extends ListeEtudiantState {}

class ListeEtudiantLoading extends ListeEtudiantState {}

class ListeEtudiantLoaded extends ListeEtudiantState {
  final List<StudentModel> students;
  ListeEtudiantLoaded(this.students);
}

class ListeEtudiantError extends ListeEtudiantState {
  final String message;
  ListeEtudiantError(this.message);
}

class ExportLoading extends ListeEtudiantState {}

class ExportSuccess extends ListeEtudiantState {
  final String filePath;
  ExportSuccess(this.filePath);
}

class ExportError extends ListeEtudiantState {
  final String message;
  ExportError(this.message);
}
