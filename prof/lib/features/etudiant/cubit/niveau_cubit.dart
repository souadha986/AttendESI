import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/etudiant/cubit/niveau_state.dart';
import 'package:prof/features/etudiant/repo/marquer_absence_api.dart';

class NiveauCubit extends Cubit<NiveauState> {
  final MarquerAbsenceApi repo;
  NiveauCubit(this.repo) : super(Niveauinitailstate());
  Future<void> getniveaux() async {
    emit(NiveauLoading());
    final Either<String, List<String>> res = await repo.fetchnniveaux();
    res.fold(
      (left) => emit(NiveauError(left)),
      (right) => emit(NiveauLoaded(right)),
    );
  }
}
