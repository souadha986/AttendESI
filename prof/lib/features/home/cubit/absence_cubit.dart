import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/home/cubit/prof_stats_state.dart';
import 'package:prof/features/home/repo/home_repo.dart';

class AbsenceCubit extends Cubit<ProfStatsState> {
  final HomeRepo homeRepo;
  AbsenceCubit(this.homeRepo) : super(ProfStatsInitial());
  Future<void> getAbsences() async {
    emit(ProfStatsLoading());
    final result = await homeRepo.getAbsences();
    result.fold(
      (error) => emit(ProfStatsError(error)),
      (modules) => emit(ProfStatsSuccess(modules)),
    );
  }
}
