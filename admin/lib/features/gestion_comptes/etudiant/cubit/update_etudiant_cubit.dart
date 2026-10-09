import 'package:admin/features/gestion_comptes/etudiant/cubit/update_etudiant_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/repo/etudiant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateEtudiantCubit extends Cubit<EtudintupdateState> {
  final EtudiantRepo etudiantRepo;

  UpdateEtudiantCubit(this.etudiantRepo) : super(EtudintupdateInitial());

  Future<void> modifyEtudiant(
    String authId,
    Map<String, dynamic> updatedData,
  ) async {
    emit(EtudintupdateLoading());

    final result = await etudiantRepo.updateEtudiant(authId, updatedData);

    result.fold(
      (error) => emit(EtudintupdateError(error)),
      (success) => emit(EtudiantUpdateSuccess(success)),
    );
  }
}
