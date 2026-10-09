import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prof/features/etudiant/cubit/remplacement_state.dart';

import 'package:prof/features/etudiant/module/remplcement_model.dart';
import 'package:prof/features/etudiant/repo/marquer_absence_api.dart';

class EligibleAbsentsCubit extends Cubit<RemplacementState> {
  final MarquerAbsenceApi api;
  EligibleAbsentsCubit(this.api) : super(EligibleAbsentsInitial());

  Future<void> getlisterempacement({
    required String specialite,
    required String dateAbsence,
    required String matiereId,
    required String niveau,
    required List<int> groupe,
  }) async {
    emit(EligibleAbsentsLoading());
    final Either<String, List<RemplacementModel>> res = await api
        .fetchEligibleAbsents(
          niveau: niveau,
          specialite: specialite,
          matiereId: matiereId,
          dateAbsence: dateAbsence,
          groupIds: groupe,
        );
    res.fold(
      (left) => emit(EligibleAbsentsError(left)),
      (right) => emit(EligibleAbsentsSuccess(right)),
    );
  }
}
