import 'dart:developer';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etudiant/core/assets/images.dart';
import 'package:etudiant/core/navigation/app_routes.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/widgets/Bottons.dart';
import 'package:etudiant/core/widgets/fields.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:etudiant/core/utils/snack_bar.dart';
import 'package:etudiant/features/auth/otp/cubit/otp_cubit.dart';
import 'package:etudiant/features/auth/otp/cubit/otp_state.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPassword({super.key, required this.email, required this.otp});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isloading = false;
  @override
  @override
  void initState() {
    super.initState();
    log("email: ${widget.email}, otp: ${widget.otp}");
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is SuccessState) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.successMessage,
            type: AnimatedSnackBarType.success,
          );
          context.pushNamed(AppRoutes.login);
        } else if (state is ErrorState) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.error,
            type: AnimatedSnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoadingState; // ✅ add this
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HeightSpace(22),
                        SvgPicture.asset(
                          Images.logo,
                          height: 200.h,
                          width: 311.w,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Rénitialiser votre mot de passe",
                            style: AppStyles.gridtext,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        HeightSpace(7),
                        Text(
                          "le mot de passe doit étre différent de l’ancien",
                          style: AppStyles.black15w600,
                          textAlign: TextAlign.center,
                        ),
                        HeightSpace(115),
                        Fields(
                          isPassword: true,
                          title: "Nouveau mot de passe",
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
                          title: "Confirmer le mot de passe",
                          controller: _confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Champs requis";
                            }
                            if (value != _passwordController.text) {
                              return "Les mots de passe ne correspondent pas";
                            }
                            return null;
                          },
                        ),
                        HeightSpace(180),
                        Bottons(
                          isloading: isLoading,
                          title: "continuer",
                          textstyle: AppStyles.white15w700,
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<OtpCubit>().changepassword(
                                widget.email,
                                widget.otp,
                                _passwordController.text,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
