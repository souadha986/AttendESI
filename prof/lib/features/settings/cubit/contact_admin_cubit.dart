import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/features/settings/cubit/contact_admin_state.dart';
import 'package:prof/features/settings/repo/contact_admin_api.dart';

class ContactAdminCubit extends Cubit<ContactAdminState> {
  ContactAdminCubit(this.contactAdminApi) : super(ContactAdminInitialState());

  final ContactAdminApi contactAdminApi;

  Future<void> sendMessage({
    required String sujet,
    required String description,
  }) async {
    emit(ContactAdminLoadingState());

    final Either<String, String> res = await contactAdminApi.sendMessage(
      sujet: sujet,
      description: description,
    );

    res.fold(
      (left) {
        emit(ContactAdminErrorState(left));
      },
      (right) {
        emit(ContactAdminSuccessState(right));
      },
    );
  }
}
