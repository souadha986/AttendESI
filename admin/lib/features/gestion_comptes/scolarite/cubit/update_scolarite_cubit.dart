import 'package:admin/features/gestion_comptes/scolarite/cubit/update_scolarite_state.dart';
import 'package:admin/features/gestion_comptes/scolarite/repo/scolarite_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateScolariteCubit extends Cubit<ScolariteupdateState> {
  final ScolariteRepo repo;

  UpdateScolariteCubit(this.repo) : super(ScolariteupdateInitial());

  Future<void> modifyScolarite(
    String authId,
    Map<String, dynamic> updatedData,
  ) async {
    emit(ScolariteupdateLoading());

    final result = await repo.updateScolarite(authId, updatedData);

    result.fold(
      (error) => emit(ScolariteupdateError(error)),
      (success) => emit(ScolariteUpdateSuccess(success)),
    );
  }
}
