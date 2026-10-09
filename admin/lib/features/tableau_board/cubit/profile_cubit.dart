
import 'package:admin/features/tableau_board/cubit/profile_state.dart';
import 'package:admin/features/tableau_board/model/profil_model.dart';
import 'package:admin/features/tableau_board/repo/profile_api.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.profileApi) : super(ProfileInitial());

  final ProfilApi profileApi;

  Future<void> refreshProfile() async {
    emit(ProfileLoadingState());
    final Either<String, ProfilModel> res = await profileApi.getProfile();
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

