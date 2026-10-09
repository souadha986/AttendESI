import 'package:admin/features/parametre/cubit/import_matieres_state.dart';
import 'package:admin/features/parametre/repo/import_matieres_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportMatieresCubit extends Cubit<ImportMatieresState> {
  final ImportMatieresApi _api;

  ImportMatieresCubit(this._api) : super(ImportMatieresInitial());

  Future<void> importMatieres({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    emit(ImportMatieresLoading());
    final result = await _api.importMatieres(
      fileName: fileName,
      fileBytes: fileBytes,
    );
    result.fold(
      (error) => emit(ImportMatieresError(error)),
      (model) => emit(ImportMatieresSuccess(model)),
    );
  }
}