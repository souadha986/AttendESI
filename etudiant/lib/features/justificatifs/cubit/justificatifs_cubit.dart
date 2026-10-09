import 'package:dartz/dartz.dart';
import 'package:etudiant/features/justificatifs/cubit/justificatifs_state.dart';
import 'package:etudiant/features/justificatifs/models/justification.dart';
import 'package:etudiant/features/justificatifs/repo/justificatis_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class JustificatifsCubit extends Cubit<JustificationState> {
  JustificatifsCubit(this.justificatifsRepo) : super((InitialState()));

  final JustificatifsRepo justificatifsRepo;

  Future<void> fetchjustificatifs() async {
    emit(LoadingState());
    final Either<String, List<Justification>> res = await justificatifsRepo
        .getjustifications();
    res.fold(
      (left) => emit(ErrorState(left)),
      (right) => emit(LoadedState(right)),
    );
  }

  Future<void> deletejustificatif(String id) async {
    emit(DeleteLoadingState());
    final Either<String, String> res = await justificatifsRepo
        .deletejustification(id);
    res.fold(
      (left) => emit(DeleteErrorState(left)),
      (right) => fetchjustificatifs(), // refreshes list after delete
    );
  }
}
