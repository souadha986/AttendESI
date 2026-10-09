import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_admin_state.dart';
import '../repo/contact_admin_repo.dart';


class ContactAdminCubit extends Cubit<ContactAdminState> {
  final ContactAdminRepo contactAdminRepo;

  ContactAdminCubit(this.contactAdminRepo) : super(ContactAdminInitial());

  Future<void> sendMessage({
    required String sujet,
    required String description,
   
  }) async {
    emit(ContactAdminLoading());

    final Either<String, String> res = await contactAdminRepo.sendMessage(
      sujet: sujet,
      description: description,
 
    );

    res.fold(
      (left) => emit(ContactAdminError(left)),
      (right) => emit(ContactAdminSuccess(right)),
    );
  }
}