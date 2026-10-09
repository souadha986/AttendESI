import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:etudiant/core/assets/images.dart';
import 'package:etudiant/core/navigation/app_routes.dart';
import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/utils/snack_bar.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:etudiant/features/home/cubit/absence_cubit.dart';
import 'package:etudiant/features/home/cubit/absence_state.dart';
import 'package:etudiant/features/home/cubit/alerts_cubit.dart';
import 'package:etudiant/features/home/cubit/alerts_states.dart';
import 'package:etudiant/features/home/cubit/profile_cubit.dart';
import 'package:etudiant/features/home/cubit/profile_state.dart';
import 'package:etudiant/features/home/widgets/absence_module_card.dart';
import 'package:etudiant/features/home/widgets/alertes_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    final profileState = context.read<ProfileCubit>().state;
    if (profileState is! ProfileSuccessState) {
      context.read<ProfileCubit>().refreshProfile();
    }

    final absenceState = context.read<AbsenceCubit>().state;
    if (absenceState is! AbsenceSuccessState) {
      context.read<AbsenceCubit>().getAbsences();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertCubit>().getAlerts();
    });
  }

  Future<void> _refreshAbsences() async {
    await context.read<AbsenceCubit>().getAbsences();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlertCubit, AlertState>(
      listener: (context, state) {
        if (state is AlertSuccessState) {
          AlertPopup.show(context, state.alerts);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is ProfileErrorState) {
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: state.error,
                  type: AnimatedSnackBarType.error,
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is ProfileLoadingState;
              final profile = state is ProfileSuccessState
                  ? state.profile
                  : null;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: [
                        isLoading
                            ? _ShimmerCircle(radius: 24.r)
                            : InkWell(
                                onTap: () {
                                  if (profile == null) return;
                                  context.push(
                                    AppRoutes.profileScreen,
                                    extra: {
                                      'nom': profile.nom,
                                      'prenom': profile.prenom,
                                      'willayaNaiss': profile.willayaNaiss,
                                      'dateNaissance': profile.dateNaissance,
                                      'situation': profile.situation,
                                      'groupe': profile.groupe,
                                      'specialite': profile.specialite,
                                    },
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 24.r,
                                  backgroundColor: const Color(0xFFDDE6F5),
                                  child: Image.asset(Images.profile),
                                ),
                              ),
                        WidthSpace(12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isLoading
                                ? _ShimmerBox(width: 130.w, height: 14.h)
                                : Text(
                                    profile != null
                                        ? "${profile.prenom} ${profile.nom}"
                                        : "---",
                                    style: AppStyles.black15w600.copyWith(
                                      color: const Color(0xFF123A7A),
                                    ),
                                  ),
                            HeightSpace(4),
                            isLoading
                                ? Padding(
                                    padding: EdgeInsets.only(top: 4.h),
                                    child: _ShimmerBox(
                                      width: 80.w,
                                      height: 12.h,
                                    ),
                                  )
                                : Text(
                                    profile != null
                                        ? "groupe:${profile.groupe}"
                                        : "---",
                                    style: AppStyles.grey14w600,
                                  ),
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            context.push(AppRoutes.notification);
                          },
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                size: 28.sp,
                                color: AppColors.blueColorA,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 19.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F7FC),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Aujourd'huit:",
                            style: AppStyles.black15w600.copyWith(
                              fontSize: 20.sp,
                            ),
                          ),
                          HeightSpace(2),
                          Text(
                            DateFormat(
                              "EEEE, dd MMMM",
                              "fr_FR",
                            ).format(DateTime.now()),
                            style: AppStyles.grey16w500,
                          ),
                        ],
                      ),
                    ),
                  ),

                  HeightSpace(14),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Taux d'absence par module:",
                        style: AppStyles.black15w700.copyWith(fontSize: 16.sp),
                      ),
                    ),
                  ),

                  HeightSpace(10),

                  Expanded(
                    child: BlocConsumer<AbsenceCubit, AbsenceState>(
                      listener: (context, absenceState) {
                        if (absenceState is AbsenceErrorState) {
                          ShowSnackBar.showAnimatedSnackDialog(
                            context: context,
                            message: absenceState.error,
                            type: AnimatedSnackBarType.error,
                          );
                        }
                      },
                      builder: (context, absenceState) {
                        if (absenceState is AbsenceLoadingState) {
                          return GridView.builder(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                              bottom: 100.h,
                            ),
                            itemCount: 8,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12.w,
                                  mainAxisSpacing: 12.h,
                                  childAspectRatio: 1.2,
                                ),
                            itemBuilder: (context, index) {
                              return ShimmerEffect(
                                baseColor: AppColors.lightGreyColor,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        final modules = absenceState is AbsenceSuccessState
                            ? absenceState.modules
                            : [];

                        return RefreshIndicator(
                          color: AppColors.blueColorE,
                          backgroundColor: Colors.white,
                          onRefresh: _refreshAbsences,
                          child: Stack(
                            children: [
                              GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                padding: EdgeInsets.only(
                                  left: 20.w,
                                  right: 20.w,
                                  bottom: 100.h,
                                ),
                                itemCount: modules.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12.w,
                                      mainAxisSpacing: 12.h,
                                      childAspectRatio: 1.2,
                                    ),
                                itemBuilder: (context, index) {
                                  final module = modules[index];
                                  return ModuleAbsenceCard(
                                    moduleName: module.matiere,
                                    totalAbsencePercent: module.tauxTotal,
                                    justifiedPercent: module.tauxJustifie,
                                    isExclu: module.is_exclus,
                                  );
                                },
                              ),

                              Positioned(
                                bottom: 16.h,
                                right: 20.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _LegendItem(
                                        color: const Color(0xFF9DD4FF),
                                        label: "Total Absences",
                                      ),
                                      SizedBox(height: 6.h),
                                      _LegendItem(
                                        color: const Color(0xFF3796E2),
                                        label: "Absences justifiée",
                                      ),
                                      SizedBox(height: 6.h),
                                      _LegendItem(
                                        color: const Color(0xFFF56764),
                                        label: "3 absences ou plus",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  final double radius;
  const _ShimmerCircle({required this.radius});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      baseColor: AppColors.lightGreyColor,
      highlightColor: AppColors.lightGreyColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.lightGreyColor,
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  const _ShimmerBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      baseColor: AppColors.lightGreyColor,
      highlightColor: AppColors.lightGreyColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        WidthSpace(8),
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: Colors.black87),
        ),
      ],
    );
  }
}
