import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/justificatifs/cubit/datails_state.dart';
import 'package:scolarite/features/justificatifs/models/justificatifs_model.dart';
import 'package:scolarite/features/justificatifs/repo/justificatifs_repo.dart';

class JustificatifDetailsCubit extends Cubit<JustificatifDetailsState> {
  JustificatifDetailsCubit(this.justificatifsApi)
      : super(JustificatifDetailsInitial());

  final JustificatifsApi justificatifsApi;

  /// GET DETAILS
  Future<void> fetchJustificatifDetails(int id) async {
    emit(JustificatifDetailsLoadingState());

    final Either<String, JustificatifDetails> res =
        await justificatifsApi.getJustificatifDetails(id);

    res.fold(
      (error) => emit(JustificatifDetailsErrorState(error)),
      (data) => emit(JustificatifDetailsSuccessState(data)),
    );
  }
}