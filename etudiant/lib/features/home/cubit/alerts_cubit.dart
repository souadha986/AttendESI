import 'package:etudiant/features/home/cubit/alerts_states.dart';
import 'package:etudiant/features/home/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertCubit extends Cubit<AlertState> {
  final HomeRepo homeRepo;

  AlertCubit(this.homeRepo) : super(AlertInitialState());

  Future<void> getAlerts() async {
    emit(AlertLoadingState());

    final result = await homeRepo.getAlerts();

    result.fold((error) => emit(AlertErrorState(error)), (alerts) {
      if (alerts.isEmpty) {
        emit(AlertEmptyState());
      } else {
        emit(AlertSuccessState(alerts));
      }
    });
  }

  Future<void> markAsRead(int alertId) async {
    final result = await homeRepo.markAlertAsRead(alertId);

    result.fold(
      (error) => null, // silent fail — don't disturb UX
      (_) => emit(AlertMarkedReadState()),
    );
  }
}
