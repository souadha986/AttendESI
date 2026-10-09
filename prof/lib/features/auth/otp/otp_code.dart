import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:prof/core/assets/images.dart';
import 'package:prof/core/navigation/app_routes.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/utils/snack_bar.dart';
import 'package:prof/core/widgets/Bottons.dart';
import 'package:prof/core/widgets/spacing.dart';
import 'package:prof/features/auth/otp/cubit/otp_cubit.dart';
import 'package:prof/features/auth/otp/cubit/otp_state.dart';
import 'package:pinput/pinput.dart';

class OtpCode extends StatefulWidget {
  final String email;
  const OtpCode({super.key, required this.email});

  @override
  State<OtpCode> createState() => _OtpCodeState();
}

class _OtpCodeState extends State<OtpCode> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Styling the OTP boxes
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: const Color(0xFF0F6AFA),
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE4EEFA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF0F6AFA).withOpacity(0.4)),
      ),
    );

    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is SuccessState) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.successMessage,
            type: AnimatedSnackBarType.success,
          );
          // Navigate to reset password page
          context.push(
            '${AppRoutes.resetpassword}?email=${widget.email}&otp=${pinController.text}',
          );
        }
        if (state is ResendOtpSuccessState) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.message,
            type: AnimatedSnackBarType.success,
          );
          // Navigate to reset password page
        } else if (state is ErrorState) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.error,
            type: AnimatedSnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HeightSpace(22),
                      SvgPicture.asset(
                        Images.logo,
                        height: 200.h,
                        width: 311.w,
                      ),
                      Text(
                        "Entrer code de vérification",
                        style: AppStyles.gridtext,
                      ),
                      HeightSpace(32),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Nous avons envoyé le code à ",
                              style: AppStyles.black15w600,
                            ),
                            TextSpan(
                              text: widget.email,
                              style: AppStyles.black15w600.copyWith(
                                color: const Color(0XFF828282),
                              ),
                            ),
                          ],
                        ),
                      ),
                      HeightSpace(62),
                      // Pinput widget
                      Pinput(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        length: 6,
                        controller: pinController,
                        focusNode: focusNode,
                        defaultPinTheme: defaultPinTheme,
                        separatorBuilder: (index) => SizedBox(width: 20.w),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(
                              color: const Color(0xFF0F6AFA),
                              width: 2,
                            ),
                          ),
                        ),
                        onCompleted: (pin) {
                          log("OTP Entered: $pin" as num);
                        },
                      ),
                      const HeightSpace(302),
                      Bottons(
                        title: "Vérifier",
                        textstyle: AppStyles.white15w700,
                        onPress: () {
                          context.read<OtpCubit>().verifyOtp(
                            widget.email,
                            pinController.text,
                          );
                        },
                      ),
                      const HeightSpace(15),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            LinearGradient(
                              colors: [Color(0xFF125CFD), Color(0xFF06A5F1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: " Vous n’avez pas reçu de code ? ",
                                style: AppStyles.black15w600,
                              ),
                              TextSpan(
                                text: "Renvoyer le code",
                                style: AppStyles.gridtext.copyWith(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.read<OtpCubit>().resendOtp(
                                      widget.email,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
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
