import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/modifier_absences/cubit/absence_modif_state.dart';
import 'package:scolarite/features/modifier_absences/models/absence_modif_models.dart';
import 'package:scolarite/features/modifier_absences/repo/absence_modif_repo.dart';


class AbsenceModifCubit extends Cubit<AbsenceModifState> {
  AbsenceModifCubit(this.api) : super(AbsenceModifInitial());

  final AbsenceModifApi api;

  Future<void> getAbsences() async {
    emit(AbsenceModifLoadingState());

    final Either<String, AbsenceModifModels> res =
        await api.getAbsences();

    res.fold(
      (left) {
        emit(AbsenceModifErrorState(left));
      },
      (right) {
        emit(AbsenceModifSuccessState(right));
      },
    );
  }
}