import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/modifier_absences/cubit/modifier_state.dart';
import 'package:scolarite/features/modifier_absences/models/absence_modif_models.dart';
import 'package:scolarite/features/modifier_absences/repo/absence_modif_repo.dart';

class ModifierCubit extends Cubit<ModifierState> {
  ModifierCubit(this.api) : super(ModifierInitial());

  final AbsenceModifApi api;

  Future<void> modifierAbsences({
    required int absenceId,
    required ModifAbsence body,
  }) async {
    emit(ModifierLoadingState());

    final Either<String, ModifAbsenceResponse> res =
        await api.modifierAbsences(
      absenceId: absenceId,
      body: body,
    );

    res.fold(
      (left) {
        emit(ModifierErrorState(left));
      },
      (right) {
        emit(ModifierSuccessState(right));
      },
    );
  }
}