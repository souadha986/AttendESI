import 'package:dartz/dartz.dart';

import 'package:etudiant/features/justificatifs/cubit/update_state.dart';

import 'package:etudiant/features/justificatifs/repo/justificatis_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit(this.justificatifsRepo) : super((Updateinitial()));

  final JustificatifsRepo justificatifsRepo;

  Future<void> updateJustification({
    required String id,
    required List<int> matiere,
    required String datedebutAbsence,
    required String datefinAbsence,
    required String typeJustification,
    required String raison,
    required String filePath,
  }) async {
    emit(UpdateLoadingState());
    final Either<String, String> res = await justificatifsRepo
        .updatejustification(
          id,
          matiere: matiere,

          datedebutAbsence: datedebutAbsence,
          datefinAbsence: datefinAbsence,
          typeJustification: typeJustification,
          raison: raison,
          filePath: filePath,
        );
    res.fold(
      (left) {
        emit(UpdateErrorState(left));
      },
      (right) {
        emit(UpdateSuccessState(right));
      },
    );
  }
}
