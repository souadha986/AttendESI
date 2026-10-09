import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/modifier_absences/cubit/modif_liste_state.dart';
import 'package:scolarite/features/modifier_absences/models/absence_modif_models.dart';
import 'package:scolarite/features/modifier_absences/repo/absence_modif_repo.dart';

class ModifListeCubit extends Cubit<ModifListeState> {
  ModifListeCubit(this.api) : super(ModifListeInitial());

  final AbsenceModifApi api;

  Future<void> getModifListe(int absenceId) async {
    emit(ModifListeLoadingState());

    final Either<String, ModifListeModel> res =
        await api.getModifListe(absenceId);

    res.fold(
      (left) {
        emit(ModifListeErrorState(left));
      },
      (right) {
        emit(ModifListeSuccessState(right));
      },
    );
  }
}