import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/absences/cubit/filtre_state.dart';
import 'package:scolarite/features/absences/models/absence_models.dart';
import 'package:scolarite/features/absences/repo/absences_repo.dart';

class FiltreCubit extends Cubit<FiltreState> {
  final AbsenceApi absenceApi;
  FiltreCubit(this.absenceApi) : super(FiltreInitial());

  Future<void> getFiltres() async {
    emit(FiltreLoading());
    final Either<String, FiltreModel> res = await absenceApi.getFiltres();
    res.fold(
      (left) => emit(FiltreError(left)),
      (right) => emit(FiltreSuccess(right)),
    );
  }
}