import 'package:admin/features/gestion_comptes/scolarite/cubit/add_scolarite_state.dart';
import 'package:admin/features/gestion_comptes/scolarite/repo/scolarite_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddScolariteCubit extends Cubit<AddScolariteState> {
  final ScolariteRepo _repo;

  AddScolariteCubit(this._repo) : super(AddScolariteInitial());

  Future<void> addScolarite(Map<String, dynamic> data) async {
    emit(AddScolariteLoading());
    final result = await _repo.addScolarite(data); // ✅ change this
    result.fold(
      (error) => emit(AddScolariteError(error)),
      (success) => emit(AddScolariteSuccess(success)),
    );
  }
}
