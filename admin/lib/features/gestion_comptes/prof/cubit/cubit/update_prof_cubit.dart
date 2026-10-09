import 'package:admin/features/gestion_comptes/prof/cubit/cubit/update_prof_state.dart';
import 'package:admin/features/gestion_comptes/prof/repo/prof_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfCubit extends Cubit<ProfupdateState> {
  final ProfRepo repo;

  UpdateProfCubit(this.repo) : super(ProfupdateInitial());

  Future<void> modifyProf(
    String authId,
    Map<String, dynamic> updatedData,
  ) async {
    emit(ProfupdateLoading());

    final result = await repo.updateProf(authId, updatedData);

    result.fold(
      (error) => emit(ProfupdateError(error)),
      (success) => emit(ProfUpdateSuccess(success)),
    );
  }
}
