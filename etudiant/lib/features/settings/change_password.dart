import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:etudiant/core/navigation/app_routes.dart';
import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/utils/snack_bar.dart';
import 'package:etudiant/core/widgets/Bottons.dart';
import 'package:etudiant/core/widgets/fields.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:etudiant/features/settings/cubit/change_password_cubit.dart';
import 'package:etudiant/features/settings/cubit/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().updatePassword(
        currentPassword: _passwordController.text,
        newPassword: _newPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColors.blueColorA),
        title: Text("Changer mot de passe", style: AppStyles.blueA20w700),
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        toolbarHeight: 80.h,
      ),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccessState) {
            ShowSnackBar.showAnimatedSnackDialog(
              context: context,
              message: state.message,
              type: AnimatedSnackBarType.success,
            );
            // Redirect to login after successful password change
            context.go(AppRoutes.login);
          } else if (state is ChangePasswordErrorState) {
            ShowSnackBar.showAnimatedSnackDialog(
              context: context,
              message: state.error,
              type: AnimatedSnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangePasswordLoadingState;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HeightSpace(80),
                        Text(
                          "Changer votre mot de passe",
                          style: AppStyles.black25w700,
                        ),
                        HeightSpace(10),
                        Text(
                          "le mot de passe doit étre différent de l'ancien",
                          style: AppStyles.black15w700.copyWith(
                            fontSize: 13.sp,
                          ),
                        ),
                        HeightSpace(80),
                        Fields(
                          isPassword: true,
                          title: "Ancien mot de passe",
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champs requis";
                            }
                            if (value.length < 8) return "Minimum 8 caractères";
                            return null;
                          },
                        ),
                        HeightSpace(30),
                        Fields(
                          isPassword: true,
                          title: "Nouveau mot de passe",
                          controller: _newPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champs requis";
                            }
                            if (value.length < 8) return "Minimum 8 caractères";
                            if (value == _passwordController.text) {
                              return "Le nouveau mot de passe doit être différent de l'ancien";
                            }
                            return null;
                          },
                        ),
                        HeightSpace(30),
                        Fields(
                          isPassword: true,
                          title: "Confirmer le mot de passe",
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champs requis";
                            }
                            if (value != _newPasswordController.text) {
                              return "Les mots de passe ne correspondent pas";
                            }
                            return null;
                          },
                        ),
                        HeightSpace(180),
                        Bottons(
                          title: "continuer",
                          textstyle: AppStyles.white15w700,
                          onPress: isLoading ? () {} : _onSubmit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
