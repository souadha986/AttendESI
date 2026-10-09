import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/etudiant/cubit/groupe_state.dart';

import 'package:prof/features/etudiant/repo/marquer_absence_api.dart';

class GroupeCubit extends Cubit<GroupeState> {
  final MarquerAbsenceApi repo;
  GroupeCubit(this.repo) : super(Groupeinitailstate());
  Future<void> getgroupes({
    required String specialite,
    required String niveau,
  }) async {
    emit(GroupeLoading());
    final Either<String, List<String>> res = await repo.fetchGroupe(
      niveau: niveau,
      specialite: specialite,
    );
    res.fold(
      (left) => emit(GroupeError(left)),
      (right) => emit(GroupeLoaded(right)),
    );
  }
}
