import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:etudiant/features/settings/cubit/logout_state.dart';
import 'package:etudiant/features/settings/repo/logout_api.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this.logoutApi) : super(LogoutInitialState());

  final LogoutApi logoutApi;
  Future<void> logout() async {
    emit(LogoutLoadingState());
    final res = await logoutApi.logout();
    res.fold(
      (left) {
        emit(LogoutErrorState(left));
      },
      (right) {
        emit(LogoutSuccessState(right));
      },
    );
  }
}
