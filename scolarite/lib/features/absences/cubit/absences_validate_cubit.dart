import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:scolarite/features/absences/repo/absences_repo.dart';
import 'package:scolarite/features/absences/cubit/absences_validate_state.dart';
import 'package:scolarite/features/absences/models/absence_models.dart';

class AbsencesValidateCubit extends Cubit<AbsencesValidateState> {
  final AbsenceApi absenceApi;

  AbsencesValidateCubit(this.absenceApi) : super(AbsencesValidateInitial());

  Future<void> validerAbsences({
    required String situation,
    required int examenId,
    required List<String> absences,
    required List<String> presences,
  }) async {
    emit(AbsencesValidateLoading());

    final Either<String, ValiderAbsenceResponse> res = await absenceApi
        .validerAbsences(
          body: ValiderAbsenceModel(
            situation: situation,
            examenId: examenId,
            absences: absences,
            presences: presences,
          ),
        );

    res.fold(
      (left) => emit(AbsencesValidateError(left)),
      (right) => emit(
        AbsencesValidateSuccess(
          message: right.message ?? "Absences enregistrées avec succès",
          id: right.id,
        ),
      ),
    );
  }
}
