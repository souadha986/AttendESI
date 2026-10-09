import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prof/features/planning/cubit/remplacement_state.dart';

import 'package:prof/features/planning/repo/planning_api.dart';

class RemplacementCubit extends Cubit<RemplacementState1> {
  final PlanningRepo palnningapi;
  RemplacementCubit(this.palnningapi) : super(RemplacmentInitial());

  Future<void> getExamenRemplacement() async {
    emit(RemplacementLoading());
    final result = await palnningapi.getExamenRemplacement();
    result.fold(
      (left) => emit(RemplacementError(left)),
      (right) => emit(RemplacementSuccess(right)),
    );
  }
}
