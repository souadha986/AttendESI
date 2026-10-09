import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/absences/cubit/absences_state.dart';
import 'package:scolarite/features/absences/models/absence_models.dart';
import 'package:scolarite/features/absences/repo/absences_repo.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  final AbsenceApi absenceApi;

  AbsenceCubit(this.absenceApi) : super(AbsenceInitial());

  Future<void> getEtudiantsAbsence({
    required String situation,
    required String matiereId,
    required String salle,
    required String date,
    String? specialite,
    String? search,
  }) async {
    emit(AbsenceLoading());

    final Either<String, AbsenceModels> res =
        await absenceApi.getEtudiantsAbsence(
      situation: situation,
      matiereId: matiereId,
      salle: salle,
      date: date,
      specialite: specialite,
      search: search,
    );

    res.fold(
      (left) => emit(AbsenceError(left)),
      (right) => emit(AbsenceSuccess(right)),
    );
  }
}