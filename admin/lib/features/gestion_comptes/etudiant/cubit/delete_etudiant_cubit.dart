import 'package:admin/features/gestion_comptes/etudiant/cubit/delete_etudiant_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/repo/etudiant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteEtudiantCubit extends Cubit<DeleteEtudiantState> {
  final EtudiantRepo _repo;

  DeleteEtudiantCubit(this._repo) : super(DeleteEtudiantInitial());

  Future<void> deleteEtudiant(String authId) async {
    emit(DeleteEtudiantLoading());
    final result = await _repo.deleteEtudiant(authId);
    result.fold(
      (error) => emit(DeleteEtudiantError(error)),
      (_) => emit(DeleteEtudiantSuccess()),
    );
  }
}
