import 'package:admin/features/gestion_comptes/scolarite/cubit/delete_scolarite_state.dart';
import 'package:admin/features/gestion_comptes/scolarite/repo/scolarite_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteScolariteCubit extends Cubit<DeleteScolariteState> {
  final ScolariteRepo _repo;

  DeleteScolariteCubit(this._repo) : super(DeleteScolariteInitial());

  Future<void> deleteScolarite(String authId) async {
    emit(DeleteScolariteLoading());
    final result = await _repo.deleteScolarite(authId);
    result.fold(
      (error) => emit(DeleteScolariteError(error)),
      (_) => emit(DeleteScolariteSuccess()),
    );
  }
}
