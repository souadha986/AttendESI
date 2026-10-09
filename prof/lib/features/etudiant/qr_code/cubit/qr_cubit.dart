import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prof/features/etudiant/qr_code/cubit/qr_state.dart';
import 'package:prof/features/etudiant/qr_code/model/qr_model.dart';
import 'package:prof/features/etudiant/qr_code/repo/qr_repo.dart';

class GenerateQrCubit extends Cubit<GenerateQrState> {
  final GenerateQrRepo repo;

  GenerateQrCubit(this.repo) : super(GenerateQrInitial());

  Future<void> generate({
    required int matiereId,
    required int groupe,
    required String niveau,
    required String specialite,
    required String heureDebut,
  }) async {
    emit(GenerateQrLoading());
    try {
      final model = GenerateQrModel(
        matiereId: matiereId,
        groupe: groupe,
        niveau: niveau,
        specialite: specialite,
        heureDebut: heureDebut,
      );

      final result = await repo.generateQr(model);

      result.fold(
        (error) => emit(GenerateQrError(error)),
        (qrData) => emit(GenerateQrSuccess(qrData)),
      );
    } catch (e) {
      emit(GenerateQrError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}
