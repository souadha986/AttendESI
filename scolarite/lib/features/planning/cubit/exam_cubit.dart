import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/planning/cubit/exam_state.dart';
import 'package:scolarite/features/planning/models/planning_models.dart';
import 'package:scolarite/features/planning/repo/planning_repo.dart';

class ExamCubit extends Cubit<ExamState> {
  ExamCubit(this.planningApi) : super(ExamInitial());

  final PlanningApi planningApi;

  Future<void> getExamens() async {
    emit(ExamLoading());

    final Either<String, ExamPlanning> res =
        await planningApi.getExamens();

    res.fold(
      (left) {
        emit(ExamError(left));
      },
      (right) {
        emit(ExamSuccess(right));
      },
    );
  }
}