import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/planning/cubit/examen_state.dart';

import 'package:prof/features/planning/repo/planning_api.dart';

class ExamenCubit extends Cubit<ExamenState> {
  final PlanningRepo palnningapi;
  ExamenCubit(this.palnningapi) : super(ExamenInitial());
  Future<void> getExamen() async {
    emit(ExamenLoading());
    final result = await palnningapi.getExamen();
    result.fold(
      (left) => emit(ExamenError(left)),
      (right) => emit(ExamenSuccess(right)),
    );
  }
}
