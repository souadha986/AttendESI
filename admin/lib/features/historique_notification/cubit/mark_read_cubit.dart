
import 'package:admin/features/historique_notification/cubit/mark_red_state.dart';
import 'package:admin/features/historique_notification/model/notification_model.dart';

import 'package:admin/features/historique_notification/repo/notification_historique_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarkAsReadCubit extends Cubit<MarkAsReadState> {
  MarkAsReadCubit(this.repo) : super(MarkAsReadInitial());

  final NotificationHistoriqueRepo repo;

  Future<void> markAsRead(int id) async {
    emit(MarkAsReadLoadingState());

    final Either<String, NotificationDetailModel> res =
        await repo.markAsRead(id);

    res.fold(
      (left) => emit(MarkAsReadErrorState(left)),
      (right) => emit(MarkAsReadSuccessState(right)),
    );
  }
}