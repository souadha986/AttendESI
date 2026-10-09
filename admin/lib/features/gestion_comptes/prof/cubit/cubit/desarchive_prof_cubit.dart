import 'package:admin/features/gestion_comptes/prof/cubit/cubit/desarchive_prof_state.dart';
import 'package:admin/features/gestion_comptes/prof/repo/prof_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesarchiveProfCubit extends Cubit<desarchiveProfState> {
  final ProfRepo _repo;
  DesarchiveProfCubit(this._repo) : super(desarcheiveProfInitial());
  Future<void> desarcheuveProf(String authId) async {
    emit(desarcheiveProfLoading());
    final result = await _repo.desarchiveProf(authId);
    result.fold(
      (error) => emit(desarcheiveProfError(error)),
      (_) => emit(desarcheiveProfSuccess()),
    );
  }
}
