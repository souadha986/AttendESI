import 'package:admin/features/gestion_comptes/prof/cubit/cubit/delete_prof_state.dart';
import 'package:admin/features/gestion_comptes/prof/repo/prof_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteProfCubit extends Cubit<DeleteProfState> {
  final ProfRepo _repo;

  DeleteProfCubit(this._repo) : super(DeleteProfInitial());

  Future<void> deleteProf(String authId) async {
    emit(DeleteProfLoading());
    final result = await _repo.deleteprof(authId);
    result.fold(
      (error) => emit(DeleteProfError(error)),
      (_) => emit(DeleteProfSuccess()),
    );
  }
}
