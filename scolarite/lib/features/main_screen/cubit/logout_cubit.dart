
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/main_screen/cubit/logout_state.dart';
import 'package:scolarite/features/main_screen/repo/logout_api.dart';

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
