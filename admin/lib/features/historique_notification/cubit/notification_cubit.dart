
import 'package:admin/features/historique_notification/cubit/notification_state.dart';
import 'package:admin/features/historique_notification/repo/notification_historique_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:admin/features/historique_notification/model/notification_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetNotificationsCubit extends Cubit<GetNotificationsState> {
  GetNotificationsCubit(this.repo) : super(GetNotificationsInitial());

  final NotificationHistoriqueRepo repo;

  Future<void> getNotifications() async {
    emit(GetNotificationsLoadingState());

    final Either<String, List<NotificationModel>> res =
        await repo.getNotifications();

    res.fold(
      (left) => emit(GetNotificationsErrorState(left)),
      (right) => emit(GetNotificationsSuccessState(right)),
    );
  }
}