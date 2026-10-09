abstract class ContactAdminState {}

class ContactAdminInitialState extends ContactAdminState {}

class ContactAdminLoadingState extends ContactAdminState {}

class ContactAdminSuccessState extends ContactAdminState {
  final String message;
  ContactAdminSuccessState(this.message);
}

class ContactAdminErrorState extends ContactAdminState {
  final String error;
  ContactAdminErrorState(this.error);
}
