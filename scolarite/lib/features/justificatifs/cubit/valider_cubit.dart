import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/justificatifs/repo/justificatifs_repo.dart';

import 'valider_state.dart';

class ValiderCubit extends Cubit<ValiderState> {
  final JustificatifsApi api;

  ValiderCubit(this.api) : super(ValiderInitial());

  Future<void> valider(int id) async {
    emit(ValiderLoading());

    final result = await api.validerJustificatif(id);

    result.fold(
      (error) {
        emit(ValiderError(error));
      },
      (data) {
        emit(ValiderSuccess(data));
      },
    );
  }
}