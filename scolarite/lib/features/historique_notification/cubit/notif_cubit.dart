import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/historique_notification/cubit/notif_state.dart';
import 'package:scolarite/features/historique_notification/models/notif_models.dart';
import 'package:scolarite/features/historique_notification/repo/notif_repo.dart';


class NotifCubit extends Cubit<NotifState> {
  NotifCubit(this.notifApi) : super(NotifInitial());

  final NotifApi notifApi;

  Future<void> getNotifications() async {
    emit(NotifLoadingState());

    final Either<String, NotifModel> res =
        await notifApi.getNotifications();

    res.fold(
      (left) {
        emit(NotifErrorState(left));
      },
      (right) {
        emit(NotifSuccessState(right));
      },
    );
  }
}