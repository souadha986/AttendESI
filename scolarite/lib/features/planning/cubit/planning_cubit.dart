import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/planning/models/planning_models.dart';
import 'package:scolarite/features/planning/cubit/planning_state.dart';
import 'package:scolarite/features/planning/repo/planning_repo.dart';

class PlanningCubit extends Cubit<PlanningState> {
  PlanningCubit(this.planningApi) : super(PlanningInitial());

  final PlanningApi planningApi;

  Future<void> getPlanning({
    String? niveau,
    String? specialite,
  }) async {
    emit(PlanningLoading());

    final Either<String, NormalPlanning> res =
        await planningApi.getPlanning(
      niveau: niveau,
      specialite: specialite,
    );

    res.fold(
      (left) {
        emit(PlanningError(left));
      },
      (right) {
        emit(PlanningSuccess(right));
      },
    );
  }
}