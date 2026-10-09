import 'package:dartz/dartz.dart';
import 'package:etudiant/features/auth/login/models/auth_tokens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etudiant/features/auth/login/cubit/auth_state.dart';

import 'package:etudiant/features/auth/login/repo/auth_api.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authApi) : super(InitialState());

  final AuthApi authApi;

  Future<void> login(String email, String password) async {
    emit(LoadingState());

    // ✅ On attend maintenant un objet AuthTokens au lieu d'un String
    final Either<String, AuthTokens> res = await authApi.login(
      email: email,
      password: password,
    );

    res.fold(
      (left) => emit(ErrorState(left)),
      (right) => emit(
        SuccessState(right),
      ), // 'right' est maintenant un objet AuthTokens
    );
  }
}
