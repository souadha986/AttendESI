import 'package:dartz/dartz.dart';

import 'package:etudiant/features/justificatifs/cubit/soumettre_state.dart';

import 'package:etudiant/features/justificatifs/repo/justificatis_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SoumettreCubit extends Cubit<SoumettreState> {
  SoumettreCubit(this.justificatifsRepo) : super((SoumettreInitial()));

  final JustificatifsRepo justificatifsRepo;

  Future<void> uploadJustification({
    required List<int> matiereIds,
    required String dateAbsenceDebut,
    required String dateAbsenceFin,
    required String typeJustification,
    required String raison,
    required String filePath,
  }) async {
    emit(SoumettreLoading());
    final Either<String, String> res = await justificatifsRepo
        .uploadJustificatif(
          matiereIds: matiereIds,
          dateAbsenceDebut: dateAbsenceDebut,
          dateAbsenceFin: dateAbsenceFin,
          typeJustification: typeJustification,
          raison: raison,
          filePath: filePath,
        );
    res.fold(
      (left) {
        emit(SoumettreError(left)); // Make sure to include the parameter name
      },
      (right) {
        emit(SoumettreSuccess(right));
      },
    );
  }
}
