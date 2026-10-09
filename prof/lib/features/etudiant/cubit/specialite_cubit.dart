import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/etudiant/cubit/specialite_state.dart';
import 'package:prof/features/etudiant/repo/marquer_absence_api.dart';

class SpecialiteCubit extends Cubit<SpecialiteState> {
  final MarquerAbsenceApi repo;
  SpecialiteCubit(this.repo) : super((Specialiteinitial()));
  Future<void> getniveaux() async {
    emit(SpecialiteLoading());
    final Either<String, List<String>> res = await repo.fetchspecialites();
    res.fold(
      (left) => emit(SpecialiteError(left)),
      (right) => emit(SpecialiteLoaded(right)),
    );
  }
}
