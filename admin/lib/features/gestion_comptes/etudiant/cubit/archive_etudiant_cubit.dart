import 'package:admin/features/gestion_comptes/etudiant/cubit/archive_etudiant_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/repo/etudiant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchiveEtudiantCubit extends Cubit<ArchiveEtudiantState> {
  final EtudiantRepo _repo;

  ArchiveEtudiantCubit(this._repo) : super(ArchiveEtudiantInitial());

  Future<void> archiveEtudiant(String authId) async {
    emit(ArchiveEtudiantLoading());
    final result = await _repo.archiveEtudiant(authId);
    result.fold(
      (error) => emit(ArchiveEtudiantError(error)),
      (_) => emit(ArchiveEtudiantSuccess()),
    );
  }
}
