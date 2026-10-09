import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:prof/core/assets/images.dart';
import 'package:prof/core/navigation/app_routes.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/utils/service_locator.dart';
import 'package:prof/core/utils/snack_bar.dart';
import 'package:prof/core/widgets/Bottons.dart';
import 'package:prof/core/widgets/outlined_bottom.dart';
import 'package:prof/core/widgets/spacing.dart';
import 'package:prof/features/settings/cubit/logout_cubit.dart';
import 'package:prof/features/settings/cubit/logout_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Paramètre", style: AppStyles.blueA20w700),
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        toolbarHeight: 80.h,
        automaticallyImplyLeading: false,
      ),
      body: BlocProvider<LogoutCubit>(
        create: (context) => sl<LogoutCubit>(),
        child: BlocConsumer<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.message,
                type: AnimatedSnackBarType.success,
              );
              context.goNamed(AppRoutes.login);
            }
            if (state is LogoutErrorState) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.error,
                type: AnimatedSnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 33.w),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Images.settingsPicture,
                          width: 300.w,
                          height: 240.h,
                        ),
                        HeightSpace(50),
                        Bottons(
                          title: "Changer le mot de passe",
                          textstyle: AppStyles.white15w700,
                          onPress: () {
                            context.pushNamed(AppRoutes.changePassword);
                          },
                        ),
                        HeightSpace(20),
                        Bottons(
                          title: "Contacter Admin",
                          textstyle: AppStyles.white15w700,
                          onPress: () {
                            context.pushNamed(AppRoutes.contactAdmin);
                          },
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: myOutlinedBottom(
                      title: "Deconnexion",
                      isloading: state is LogoutLoadingState,
                      onPress: () {
                        context.read<LogoutCubit>().logout();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
