import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prof/features/planning/cubit/seance_normal_state.dart';
import 'package:prof/features/planning/repo/planning_api.dart';

class SeanceNormaleCubit extends Cubit<SeanceNormaleState> {
  final PlanningRepo palnningapi;
  SeanceNormaleCubit(this.palnningapi) : super(NormalPlanningInitial());
  Future<void> getAbsences() async {
    emit(NormalPlanningLoading());
    final result = await palnningapi.getSeance();
    result.fold(
      (left) => emit(NormalPlanningError(left)),
      (right) => emit(NormalPlanningSuccess(right)),
    );
  }
}
