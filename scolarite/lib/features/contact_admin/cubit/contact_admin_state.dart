abstract class ContactAdminState {}

class ContactAdminInitial extends ContactAdminState {}

class ContactAdminLoading extends ContactAdminState {}

class ContactAdminSuccess extends ContactAdminState {
  final String message;
  ContactAdminSuccess(this.message);
}

class ContactAdminError extends ContactAdminState {
  final String error;
  ContactAdminError(this.error);
}