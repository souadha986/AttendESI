import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/justificatifs/repo/justificatifs_repo.dart';
import 'refus_state.dart';

class RefusCubit extends Cubit<RefusState> {
  final JustificatifsApi api;

  RefusCubit(this.api) : super(RefusInitial());

  Future<void> refuser({
    required int id,
    required String commentaire,
  }) async {
    emit(RefusLoading());

    final result = await api.refuserJustificatif(id, commentaire);

    result.fold(
      (error) {
        emit(RefusError(error));
      },
      (data) {
        emit(RefusSuccess(data));
      },
    );
  }
}