import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/home/cubit/profile_state.dart';
import 'package:prof/features/home/models/profile_model.dart';
import 'package:prof/features/home/repo/home_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.homeRepo) : super(ProfileInitial());

  final HomeRepo homeRepo;

  Future<void> refreshProfile() async {
    emit(ProfileLoadingState());
    final Either<String, ProfileModel> res = await homeRepo.getProfile();
    res.fold(
      (left) {
        emit(ProfileErrorState(left));
      },
      (right) {
        emit(ProfileSuccessState(right));
      },
    );
  }
}
