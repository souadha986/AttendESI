import 'package:etudiant/features/planning/cubit/examen_state.dart';
import 'package:etudiant/features/planning/repo/planning_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
