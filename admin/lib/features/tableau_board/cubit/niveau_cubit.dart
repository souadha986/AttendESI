import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:admin/features/tableau_board/repo/tableau_bord_api.dart';

import 'niveau_state.dart';

class NiveauCubit extends Cubit<NiveauState> {
  NiveauCubit(this.api) : super(NiveauInitial());

  final TableauBordApi api;

  Future<void> getNiveaux() async {
    emit(NiveauLoading());

    final Either<String, List<String>> result =
        await api.getNiveaux();

    result.fold(
      (error) => emit(NiveauError(error)),
      (data) => emit(NiveauSuccess(data)),
    );
  }
}