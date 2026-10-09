import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:scolarite/core/assets/images.dart';
import 'package:scolarite/core/navigation/app_routes.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/styling/gradient_text.dart';
import 'package:scolarite/core/utils/snack_bar.dart';
import 'package:scolarite/core/widgets/bottons.dart';
import 'package:scolarite/core/widgets/fields.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/login/cubit/auth_cubit.dart';
import 'package:scolarite/features/login/cubit/auth_state.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SuccessState) {
            context.go(AppRoutes.mainscreen);
          }
          if (state is ErrorState) {
            ShowSnackBar.showAnimatedSnackDialog(
              context: context,
              message: state.error,
              type: AnimatedSnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is LoadingState;

          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(
                  Images.logo,
                  fit: BoxFit.fill,
                  height: double.infinity,
                ),
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 102.w, right: 102.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeightSpace(135),
                        Center(child: GradientText("Bienvenue !")),
                        const HeightSpace(146),

                        Text('Email', style: AppStyles.black18w500),
                        const HeightSpace(10),

                        Fields(
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
                          isPassword: false,
                        ),
                        const HeightSpace(30),

                        Text('Mot de passe', style: AppStyles.black18w500),
                        const HeightSpace(10),

                        Fields(
                          isPassword: true,
                          title: "entrer votre mot de passe",
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Mot de passe requis";
                            }
                            if (value.length < 8) return "Trop court (min 8)";
                            return null;
                          },
                        ),

                        const HeightSpace(161),

                        Center(
                          child: isLoading
                              ? Bottons(onPress: () {}, isloading: true)
                              : Bottons(
                                  onPress: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().login(
                                        _emailController.text.trim(),
                                        _passwordController.text,
                                      );
                                    }
                                  },
                                  title: "Se connecter",
                                  style: AppStyles.white20w700,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
