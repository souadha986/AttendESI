import 'package:scolarite/features/absences/models/absence_models.dart';


abstract class FiltreState {}

class FiltreInitial extends FiltreState {}

class FiltreLoading extends FiltreState {}

class FiltreSuccess extends FiltreState {
  final FiltreModel filtres;
  FiltreSuccess(this.filtres);
}

class FiltreError extends FiltreState {
  final String error;
  FiltreError(this.error);
}