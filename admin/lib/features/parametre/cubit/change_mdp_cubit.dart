import 'package:admin/features/parametre/cubit/change_mdp_state.dart';
import 'package:admin/features/parametre/repo/change_mdp_api.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this.changePasswordApi)
    : super(ChangePasswordInitialState());

  final ChangePasswordApi changePasswordApi;

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoadingState());

    final Either<String, String> res = await changePasswordApi.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    res.fold(
      (left) {
        emit(ChangePasswordErrorState(left));
      },
      (right) {
        emit(ChangePasswordSuccessState(right));
      },
    );
  }
}
