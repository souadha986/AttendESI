import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/dashboard/models/dashboard_models.dart';
import 'package:scolarite/features/dashboard/repo/dashboard_repo.dart';
import 'cards_state.dart';

class CardsCubit extends Cubit<CardsState> {
  CardsCubit(this.dashboardRepo) : super(CardsInitial());

  final DashboardRepo dashboardRepo;

  Future<void> getDashboard() async {
    emit(CardsLoadingState());

    final Either<String, CardsModel> res =
        await dashboardRepo.getDashboard();

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