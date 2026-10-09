import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/profile/cubit/profile_state.dart';
import 'package:scolarite/features/profile/models/profile_model.dart';
import 'package:scolarite/features/profile/repo/profile_api.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.profileApi) : super(ProfileInitial());

  final ProfileApi profileApi;

  Future<void> refreshProfile() async {
    emit(ProfileLoadingState());
    final Either<String, ProfileModel> res = await profileApi.getProfile();
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
