import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:etudiant/core/assets/images.dart';
import 'package:etudiant/core/navigation/app_routes.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/utils/snack_bar.dart';
import 'package:etudiant/core/widgets/Bottons.dart';
import 'package:etudiant/core/widgets/fields.dart';
import 'package:etudiant/core/widgets/outlined_bottom.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:etudiant/features/auth/otp/cubit/otp_cubit.dart';
import 'package:etudiant/features/auth/otp/cubit/otp_state.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool isloading = false;

  @override
  void dispose() {
    _emailController.dispose();
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
          context.pushNamed(AppRoutes.otpcode, extra: _emailController.text);
        } else if (state is ErrorState) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.error,
            type: AnimatedSnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        final isloading = state is LoadingState;

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 22.h),
                      SvgPicture.asset(
                        Images.logo,
                        height: 200.h,
                        width: 311.w,
                      ),
                      Text("Mot de passe oublié ?", style: AppStyles.gridtext),
                      SizedBox(height: 32.h),
                      Text(
                        "Entrer votre adresse e-mail pour rénitialiser votre mot de passe",
                        style: AppStyles.black15w600,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 60.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Email", style: AppStyles.black13w500),
                      ),
                      SizedBox(height: 9.h),
                      Fields(
                        isPassword: false,
                        title: "email@esi-sba.dz",
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez entrer votre email";
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@esi-sba\.dz$',
                          ).hasMatch(value)) {
                            return "L'email doit se terminer par @esi-sba.dz";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 214.h),
                      Bottons(
                        isloading: isloading,
                        title: "Continuer",
                        textstyle: AppStyles.white15w700,
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<OtpCubit>().sendOtp(
                              _emailController.text,
                            );
                          }
                        },
                      ),
                      HeightSpace(21),
                      myOutlinedBottom(
                        title: "Annuler",
                        onPress: () {
                          context.pushNamed(AppRoutes.login);
                        },
                      ),
                    ],
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
