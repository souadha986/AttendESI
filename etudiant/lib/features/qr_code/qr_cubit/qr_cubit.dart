import 'package:etudiant/features/qr_code/model/qr_model.dart';
import 'package:etudiant/features/qr_code/qr_cubit/qr_state.dart';
import 'package:etudiant/features/qr_code/repo/qr_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QrcodeCubit extends Cubit<QrcodeState> {
  final QrcodeRepo repo;

  QrcodeCubit(this.repo) : super(QrcodeInitial());

  Future<void> submitScan(int seanceId) async {
    emit(QrcodeLoading());
    try {
      final model = ScanRequestModel(seanceId: seanceId);

      final result = await repo.scanQr(model);

      result.fold(
        (error) => emit(QrcodeError(error)),
        (message) => emit(QrcodeSuccess(message)),
      );
    } catch (e) {
      emit(QrcodeError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}
