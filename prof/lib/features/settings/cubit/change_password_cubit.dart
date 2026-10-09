import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/settings/cubit/change_password_state.dart';
import 'package:prof/features/settings/repo/change_password_api.dart';

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
