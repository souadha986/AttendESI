import 'package:etudiant/features/home/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etudiant/features/home/cubit/absence_state.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  final HomeRepo homeRepo;
  AbsenceCubit(this.homeRepo) : super(AbsenceInitial());
  Future<void> getAbsences() async {
    emit(AbsenceLoadingState());
    final result = await homeRepo.getAbsences();
    result.fold(
      (error) => emit(AbsenceErrorState(error)),
      (modules) => emit(AbsenceSuccessState(modules)),
    );
  }
}
