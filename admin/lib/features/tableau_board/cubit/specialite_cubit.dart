import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:admin/features/tableau_board/repo/tableau_bord_api.dart';

import 'specialite_state.dart';

class SpecialiteCubit extends Cubit<SpecialiteState> {
  SpecialiteCubit(this.api) : super(SpecialiteInitial());

  final TableauBordApi api;

  Future<void> getSpecialites() async {
    emit(SpecialiteLoading());

    final Either<String, List<String>> result =
        await api.getSpecialites();

    result.fold(
      (error) => emit(SpecialiteError(error)),
      (data) => emit(SpecialiteSuccess(data)),
    );
  }
}