import 'package:admin/features/tableau_board/model/tableau_bord_model.dart';


abstract class CardsState {}

class CardsInitial extends CardsState {}

class CardsLoadingState extends CardsState {}

class CardsSuccessState extends CardsState {
  final CardsModel cards;
  CardsSuccessState(this.cards);
}

class CardsErrorState extends CardsState {
  final String error;
  CardsErrorState(this.error);
}