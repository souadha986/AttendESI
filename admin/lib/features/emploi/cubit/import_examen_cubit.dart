import 'package:admin/features/emploi/cubit/import_examen_state.dart';
import 'package:admin/features/emploi/repo/import_examen_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportExamenCubit extends Cubit<ImportExamenState> {
  final ImportExamenApi _api;

  ImportExamenCubit(this._api) : super(ImportExamenInitial());

  Future<void> importExamenEmd({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    emit(ImportExamenEmdLoading());
    final result = await _api.importExamenEmd(
      fileName: fileName,
      fileBytes: fileBytes,
    );
    result.fold(
      (error) => emit(ImportExamenEmdError(error)),
      (model) => emit(ImportExamenEmdSuccess(model)),
    );
  }

  Future<void> importExamenRemplacement({
    required String fileName,
    required List<int> fileBytes,
  }) async {
    emit(ImportExamenRemplacementLoading());
    final result = await _api.importExamenRemplacement(
      fileName: fileName,
      fileBytes: fileBytes,
    );
    result.fold(
      (error) => emit(ImportExamenRemplacementError(error)),
      (model) => emit(ImportExamenRemplacementSuccess(model)),
    );
  }
}