
import 'package:scolarite/features/dashboard/models/dashboard_models.dart';

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