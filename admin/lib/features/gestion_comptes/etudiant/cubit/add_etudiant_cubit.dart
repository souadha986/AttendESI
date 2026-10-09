import 'package:admin/features/gestion_comptes/etudiant/cubit/add_etudiant_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/repo/etudiant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEtudiantCubit extends Cubit<AddEtudiantState> {
  final EtudiantRepo _repo;

  AddEtudiantCubit(this._repo) : super(AddEtudiantInitial());

  Future<void> addEtudiant(Map<String, dynamic> data) async {
    emit(AddEtudiantLoading());
    final result = await _repo.addetudiant(data); // ✅ change this
    result.fold(
      (error) => emit(AddEtudiantError(error)),
      (success) => emit(AddEtudiantSuccess(success)),
    );
  }
}
