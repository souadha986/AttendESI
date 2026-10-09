import 'package:admin/features/emploi/cubit/emploi_state.dart';
import 'package:admin/features/emploi/repo/emploi_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmploiCubit extends Cubit<EmploiState> {
  EmploiCubit(this.emploiApi) : super(EmploiInitial());

  final EmploiApi emploiApi;

  Future<void> loadNormalSchedule(String niveau) async {
    emit(EmploiNormalLoadingState());
    final res = await emploiApi.getNormalSchedule(niveau);
    res.fold(
      (error) => emit(EmploiNormalErrorState(error)),
      (data)  => emit(EmploiNormalSuccessState(data)),
    );
  }

  Future<void> loadExamens(String niveau) async {
    emit(EmploiExamenLoadingState());
    final res = await emploiApi.getExamens(niveau);
    res.fold(
      (error) => emit(EmploiExamenErrorState(error)),
      (data)  => emit(EmploiExamenSuccessState(data)),
    );
  }

 Future<void> loadRemplacement(String niveau) async {
  emit(EmploiRemplacementLoadingState());
  final res = await emploiApi.getRemplacement(niveau);
  res.fold(
    (error) => emit(EmploiRemplacementErrorState(error)),
    (data) => emit(EmploiRemplacementSuccessState(data)), 
  );
}

  /// Call this when the user switches tabs or selects a new year level.
  /// Loads the appropriate data based on the active mode.
  Future<void> loadByMode({
    required String niveau,
    required String mode, // 'normal' | 'examen' | 'remplacement'
  }) async {
    switch (mode) {
      case 'normal':
        await loadNormalSchedule(niveau);
        break;
      case 'examen':
        await loadExamens(niveau);
        break;
      case 'remplacement':
        await loadRemplacement(niveau);
        break;
    }
  }
}