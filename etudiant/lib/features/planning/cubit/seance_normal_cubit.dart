import 'package:etudiant/features/planning/cubit/seance_normal_state.dart';
import 'package:etudiant/features/planning/repo/planning_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeanceNormaleCubit extends Cubit<SeanceNormaleState> {
  final PlanningRepo palnningapi;
  SeanceNormaleCubit(this.palnningapi) : super(NormalPlanningInitial());
  Future<void> getSeances() async {
    emit(NormalPlanningLoading());
    final result = await palnningapi.getSeance();
    result.fold(
      (left) => emit(NormalPlanningError(left)),
      (right) => emit(NormalPlanningSuccess(right)),
    );
  }
}
