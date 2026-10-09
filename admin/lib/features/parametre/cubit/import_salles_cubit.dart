import 'package:admin/features/parametre/cubit/import_salles_state.dart';
import 'package:admin/features/parametre/repo/import_salles_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportSallesCubit extends Cubit<ImportSallesState> {
  final ImportSallesApi _api;

  ImportSallesCubit(this._api) : super(ImportSallesInitial());

  Future<void> importSalles({
    required String fileName,
    required List<int> fileBytes,  // bytes au lieu de path
  }) async {
    emit(ImportSallesLoading());
    final result = await _api.importSalles(
      fileName: fileName,
      fileBytes: fileBytes,
    );
    result.fold(
      (error) => emit(ImportSallesError(error)),
      (model) => emit(ImportSallesSuccess(model)),
    );
  }
}