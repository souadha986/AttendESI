import 'package:admin/features/gestion_comptes/prof/cubit/cubit/import_prof_state.dart';
import 'package:admin/features/gestion_comptes/prof/repo/import_prof_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportProfCubit extends Cubit<ImportProfState> {
  final ImportProfApi _api;

  ImportProfCubit(this._api) : super(ImportProfInitial());

  Future<void> importProfesseurs({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    emit(ImportProfLoading());
    final result = await _api.importProfesseurs(
      fileName: fileName,
      fileBytes: fileBytes,
    );
    result.fold(
      (error) => emit(ImportProfError(error)),
      (model) => emit(ImportProfSuccess(model)),
    );
  }
}