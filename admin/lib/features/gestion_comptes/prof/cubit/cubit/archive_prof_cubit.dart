import 'package:admin/features/gestion_comptes/prof/cubit/cubit/archive_prof_state.dart';
import 'package:admin/features/gestion_comptes/prof/repo/prof_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchiveProfCubit extends Cubit<ArchiveProfState> {
  final ProfRepo _repo;

  ArchiveProfCubit(this._repo) : super(ArchiveProfInitial());

  Future<void> archiveProf(String authId) async {
    emit(ArchiveProfLoading());
    final result = await _repo.archiveProf(authId);
    result.fold(
      (error) => emit(ArchiveProfError(error)),
      (_) => emit(ArchiveProfSuccess()),
    );
  }
}
