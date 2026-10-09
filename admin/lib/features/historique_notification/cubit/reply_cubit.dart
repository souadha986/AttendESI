import 'package:admin/features/historique_notification/cubit/reply_state.dart';
import 'package:admin/features/historique_notification/model/notification_model.dart';
import 'package:admin/features/historique_notification/repo/notification_historique_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendNotificationCubit extends Cubit<SendNotificationState> {
  SendNotificationCubit(this.repo) : super(SendNotificationInitial());

  final NotificationHistoriqueRepo repo;

  Future<void> sendNotification({
    required String targetAuthId,
    required String titre,
    required String message,
  }) async {
    emit(SendNotificationLoadingState());

    final Either<String, SendNotificationResponseModel> res =
        await repo.sendPersonalNotification(
      targetAuthId: targetAuthId,
      titre: titre,
      message: message,
    );

    res.fold(
      (left) => emit(SendNotificationErrorState(left)),
      (right) => emit(SendNotificationSuccessState(right)),
    );
  }
}