import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prof/features/auth/otp/cubit/otp_state.dart';

import 'package:prof/features/auth/otp/repo/otp_api.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this.authApi) : super(InitialState());

  final OtpApi authApi;

  Future<void> sendOtp(String email) async {
    emit(LoadingState()); // Better than InitialState when logging in

    final Either<String, String> res = await authApi.sendOtp(email: email);
    res.fold(
      (left) {
        emit(ErrorState(left));
      },
      (right) {
        emit(SuccessState(right));
      },
    );
  }

  Future<void> resendOtp(String email) async {
    emit(LoadingState()); // Better than InitialState when logging in

    final Either<String, String> res = await authApi.resendOtp(email: email);
    res.fold(
      (left) {
        emit(ErrorState(left));
      },
      (right) {
        emit(ResendOtpSuccessState(right));
      },
    );
  }

  Future<void> changepassword(
    String email,
    String otp,
    String newpassword,
  ) async {
    emit(LoadingState()); // Better than InitialState when logging in

    final Either<String, String> res = await authApi.changepassword(
      email: email,
      otp: otp,
      newPassword: newpassword,
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

  Future<void> verifyOtp(String email, String otp) async {
    emit(LoadingState()); // Better than InitialState when logging in

    final Either<String, String> res = await authApi.verifyOtp(
      email: email,
      otp: otp,
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
}
