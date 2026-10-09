import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prof/features/etudiant/repo/marquer_absence_api.dart';
import 'etudiant_state.dart';

class EtudiantCubit extends Cubit<EtudiantState> {
  final MarquerAbsenceApi repository;

  EtudiantCubit(this.repository) : super(const EtudiantInitial());

  Future<void> getEtudiantsModifies({
    required String heure,
    required String niveau,
    required String specialite,
    required String groupe,
    required String matiereid,
    required String date,
  }) async {
    emit(const EtudiantLoading());
    final result = await repository.fetchEtudiantsmodifies(
      heure: heure,
      niveau: niveau,
      specialite: specialite,
      groupe: groupe,
      matiereid: matiereid,
      date: date,
    );
    result.fold(
      (left) => emit(EtudiantError(left)),
      (right) => emit(EtudiantModifierLoaded(right)),
    );
  }

  Future<void> getEtudiants({
    required String niveau,
    required String specialite,
    required String groupe,
    required int matiereId,
  }) async {
    emit(const EtudiantLoading());
    final result = await repository.fetchEtudiants(
      matiereId: matiereId,
      niveau: niveau,
      specialite: specialite,
      groupe: groupe,
    );
    result.fold(
      (left) => emit(EtudiantError(left)),
      (right) => emit(EtudiantLoaded(right)),
    );
  }
}
