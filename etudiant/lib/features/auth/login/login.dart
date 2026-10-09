import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:etudiant/core/widgets/loading.dart';
import 'package:etudiant/features/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:etudiant/features/auth/login/cubit/auth_cubit.dart';
import 'package:etudiant/features/auth/login/cubit/auth_state.dart';

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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SystemNavigator.pop();
      },
      canPop: false,
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is ErrorState) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.error,
                type: AnimatedSnackBarType.error,
              );
            }
            if (state is SuccessState) {
              // 1. S'abonner aux thèmes de sa promo (ex: "2cs_isi")
              // On utilise les données qui viennent de ton nouvel objet AuthTokens
              final String studentTopic =
                  '${state.tokens.niveau}_${state.tokens.specialite}_${state.tokens.groupe}';
              NotificationService.subscribeToTopic(studentTopic);

              // 2. Envoyer son FCM Token personnel au serveur
              // Pour que le serveur puisse lui envoyer des messages individuels
              NotificationService.uploadTokenToBackend();

              // 3. Afficher le succès et naviguer
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: "Connexion réussie !",
                type: AnimatedSnackBarType.success,
              );

              context.goNamed(AppRoutes.mainScreen);
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Loading();
            }

            return SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF0276FE), Color(0xFF00B4EE)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 58.h,
                      left: 0,
                      right: 0,
                      child: Text(
                        'Bienvenue!',
                        textAlign: TextAlign.center,
                        style: AppStyles.white24w600,
                      ),
                    ),
                    Positioned(
                      top: 150.h,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    Images.logo,
                                    height: 239.h,
                                    width: 329.w,
                                  ),
                                  HeightSpace(27),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Email",
                                      style: AppStyles.black13w500,
                                    ),
                                  ),
                                  HeightSpace(9),
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
                                  HeightSpace(30),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Mot de passe",
                                      style: AppStyles.black13w500,
                                    ),
                                  ),
                                  HeightSpace(9),
                                  Fields(
                                    isPassword: true,
                                    title: "entrer votre mot de passe",
                                    controller: _passwordController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Mot de passe requis";
                                      }
                                      if (value.length < 8) {
                                        return "Trop court (min 8)";
                                      }
                                      return null;
                                    },
                                  ),
                                  HeightSpace(39),
                                  InkWell(
                                    onTap: () {
                                      context.pushNamed(
                                        AppRoutes.forgetpassword,
                                      );
                                    },
                                    child: Text(
                                      "Mot de passe oublié ?",
                                      style: AppStyles.black15w600.copyWith(
                                        fontSize: 14.sp,
                                        color: const Color(0xFF357AE9),
                                      ),
                                    ),
                                  ),
                                  HeightSpace(80),
                                  Bottons(
                                    title: "Se connecter",
                                    textstyle: AppStyles.white15w700,
                                    onPress: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthCubit>().login(
                                          _emailController.text,
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
