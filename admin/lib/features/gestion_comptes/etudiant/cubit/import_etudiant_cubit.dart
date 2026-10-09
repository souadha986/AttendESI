import 'package:admin/features/gestion_comptes/etudiant/cubit/import_etudiant_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/repo/import_etudiant_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportEtudiantCubit extends Cubit<ImportEtudiantState> {
  final ImportEtudiantApi _api;

  ImportEtudiantCubit(this._api) : super(ImportEtudiantInitial());

  Future<void> importEtudiants({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    emit(ImportEtudiantLoading());
    final result = await _api.importEtudiants(
      fileName: fileName,
      fileBytes: fileBytes,
    );
    result.fold(
      (error) => emit(ImportEtudiantError(error)),
      (model) => emit(ImportEtudiantSuccess(model)),
    );
  }
}