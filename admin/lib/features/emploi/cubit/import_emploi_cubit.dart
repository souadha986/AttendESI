import 'package:admin/features/emploi/cubit/import_emploi_state.dart';
import 'package:admin/features/emploi/repo/import_emploi_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportEmploiCubit extends Cubit<ImportEmploiState> {
  final ImportEmploiApi _api;

  ImportEmploiCubit(this._api) : super(ImportEmploiInitial());

  Future<void> importEmploi({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    emit(ImportEmploiLoading());
    final result = await _api.importEmploi(
      fileName: fileName,
      fileBytes: fileBytes,
    );
    result.fold(
      (error) => emit(ImportEmploiError(error)),
      (model) => emit(ImportEmploiSuccess(model)),
    );
  }
}