
import 'package:admin/features/exclusion/cubit/action_exclusion_state.dart';
import 'package:admin/features/exclusion/repo/exclusion_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionExclusionCubit extends Cubit<ActionExclusionState> {
  final ExclusionRepo _repo;

  ActionExclusionCubit(this._repo) : super(ActionExclusionInitial());
Future<void> prononcerExclusion({
  required String studentAuthId,
  required int matiereId,
}) async {
  emit(PrononcerExclusionLoading());
  final result = await _repo.prononcerExclusion(
    studentAuthId: studentAuthId,
    matiereId: matiereId,
  );
  result.fold(
    (error) => emit(PrononcerExclusionError(error)),
    (decision) => emit(PrononcerExclusionSuccess(decision)), // ← modèle
  );
}

Future<void> accorderDerogation({
  required String studentAuthId,
  required int matiereId,
}) async {
  emit(AccorderDerogationLoading());
  final result = await _repo.accorderDerogation(
    studentAuthId: studentAuthId,
    matiereId: matiereId,
  );
  result.fold(
    (error) => emit(AccorderDerogationError(error)),
    (decision) => emit(AccorderDerogationSuccess(decision)), // ← modèle
  );
}

}