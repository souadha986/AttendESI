import 'package:admin/features/gestion_comptes/prof/cubit/cubit/add_prof_state.dart';
import 'package:admin/features/gestion_comptes/prof/repo/prof_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProfCubit extends Cubit<AddProfState> {
  final ProfRepo _repo;

  AddProfCubit(this._repo) : super(AddProfInitial());

  Future<void> addProf(Map<String, dynamic> data) async {
    emit(AddProfLoading());
    final result = await _repo.addprof(data); // ✅ change this
    result.fold(
      (error) => emit(AddProfError(error)),
      (success) => emit(AddProfSuccess(success)),
    );
  }
}
