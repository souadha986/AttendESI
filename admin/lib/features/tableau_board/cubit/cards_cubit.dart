import 'package:admin/features/tableau_board/cubit/cards_state.dart';
import 'package:admin/features/tableau_board/model/tableau_bord_model.dart';
import 'package:admin/features/tableau_board/repo/tableau_bord_api.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CardsCubit extends Cubit<CardsState> {
  CardsCubit(this.tableauBordApi) : super(CardsInitial());

  final TableauBordApi tableauBordApi;

  Future<void> refreshCards() async {
    emit(CardsLoadingState());

    final Either<String, CardsModel> res =
        await tableauBordApi.getTableauBord();

    res.fold(
      (left) {
        emit(CardsErrorState(left));
      },
      (right) {
        emit(CardsSuccessState(right));
      },
    );
  }
}