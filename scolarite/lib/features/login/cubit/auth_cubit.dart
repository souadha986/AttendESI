
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/login/cubit/auth_state.dart';
import 'package:scolarite/features/login/repo/auth_api.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authApi) : super(InitialState());

  final AuthApi authApi;

  Future<void> login(String email, String password) async {
    emit(LoadingState()); // Better than InitialState when logging in

    final Either<String, String> res = await authApi.login(
      email: email,
      password: password,
    );
    res.fold(
      (left) {
        emit(ErrorState(left));
      },
      (right) {
        emit(SuccessState(right));
      },
    );
  }

  // void logout() {
  //   sl<SecureStorage>().removeToken();
  // }
}
