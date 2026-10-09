import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/justificatifs/cubit/justificatif_state.dart';
import 'package:scolarite/features/justificatifs/models/justificatifs_model.dart';
import 'package:scolarite/features/justificatifs/repo/justificatifs_repo.dart';

class JustificatifsCubit extends Cubit<JustificatifsState> {
  JustificatifsCubit(this.justificatifsApi)
      : super(JustificatifsInitial());

  final JustificatifsApi justificatifsApi;

  ///GET ALL
  Future<void> fetchAllJustificatifs() async {
    emit(JustificatifsLoadingState());

    final Either<String, List<JustificatifsModel>> res =
        await justificatifsApi.getAllJustificatifs();

    res.fold(
      (error) => emit(JustificatifsErrorState(error)),
      (data) => emit(JustificatifsSuccessState(data)),
    );
  }

  /// SEARCH
  Future<void> searchJustificatifs(String query) async {
    emit(JustificatifsLoadingState());

    final Either<String, List<JustificatifsModel>> res =
        await justificatifsApi.searchJustificatifs(query);

    res.fold(
      (error) => emit(JustificatifsErrorState(error)),
      (data) => emit(JustificatifsSuccessState(data)),
    );
  }
}