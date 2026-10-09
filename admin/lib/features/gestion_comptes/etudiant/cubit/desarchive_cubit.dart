import 'package:admin/features/gestion_comptes/etudiant/cubit/desarchive_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/repo/etudiant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesarchiveCubit extends Cubit<desarchiveEtudiantState> {
  final EtudiantRepo _repo;
   DesarchiveCubit(this._repo) : super(desarcheiveEtudiantInitial());
   Future<void> desarcheuveEtudiant(String authId) async {
    emit(desarcheiveEtudiantLoading());
     final result = await _repo.desarchiveEtudiant(authId);
    result.fold(
      (error) => emit(desarcheiveEtudiantError(error)),
      (_) => emit(desarcheiveEtudiantSuccess()),
    );
  }
}

