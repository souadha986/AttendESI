import 'package:dartz/dartz.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/notifications/cubit/notification_state.dart';
import 'package:prof/features/notifications/model/notification_model.dart';
import 'package:prof/features/notifications/repo/notification_repo.dart';

class NotificationsCubit extends Cubit<NotificationState> {
  final NotificationRepo repo;
  NotificationsCubit(this.repo) : super(NotificationInitial());
  Future<void> getNotifications() async {
    emit(NotificationLoading());
    final Either<String, List<NotificationModel>> res = await repo
        .fectchnotifications();

    res.fold(
      (left) => emit(NotificationError(left)),
      (right) => emit(NotificationLoaded(right)),
    );
  }
}
