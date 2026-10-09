import 'package:admin/features/tableau_board/model/profil_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final ProfilModel profile;
  ProfileSuccessState(this.profile);
}

class ProfileErrorState extends ProfileState {
  final String error;
  ProfileErrorState(this.error);
}
