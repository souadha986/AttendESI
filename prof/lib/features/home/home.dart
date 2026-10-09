import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prof/core/assets/images.dart';
import 'package:prof/core/navigation/app_routes.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/utils/snack_bar.dart';
import 'package:prof/core/widgets/spacing.dart';
import 'package:prof/features/home/cubit/absence_cubit.dart';
import 'package:prof/features/home/cubit/profile_cubit.dart';
import 'package:prof/features/home/cubit/profile_state.dart';
import 'package:prof/features/home/cubit/prof_stats_state.dart';
import 'package:prof/features/home/widgets/absence_module_card.dart';
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

    // Ensure providers are called after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is! ProfileSuccessState) {
        context.read<ProfileCubit>().refreshProfile();
      }
      context.read<AbsenceCubit>().getAbsences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          builder: (context, profileState) {
            final isProfileLoading = profileState is ProfileLoadingState;
            final profile = profileState is ProfileSuccessState
                ? profileState.profile
                : null;

            return Column(
              children: [
                // ── Header ──────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    children: [
                      isProfileLoading
                          ? const _ShimmerCircle(radius: 24)
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
                                    'description': profile.description,
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
                      isProfileLoading
                          ? _ShimmerBox(width: 130.w, height: 14.h)
                          : Text(
                              profile != null
                                  ? "${profile.prenom} ${profile.nom}"
                                  : "---",
                              style: AppStyles.black15w600.copyWith(
                                color: const Color(0xFF123A7A),
                              ),
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

                // ── Date card (Fixed: No longer waiting for Cubit) ──
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
                          "Aujourd'hui:",
                          style: AppStyles.black15w600.copyWith(
                            fontSize: 20.sp,
                          ),
                        ),
                        HeightSpace(2),
                        Text(
                          DateFormat(
                            'EEEE d MMMM yyyy',
                            'fr_FR',
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
                      "Taux de présence:",
                      style: AppStyles.black15w700.copyWith(fontSize: 16.sp),
                    ),
                  ),
                ),
                HeightSpace(20),

                // ── Stats list with Stack for floating Legend ────────
                Expanded(
                  child: Stack(
                    children: [
                      BlocConsumer<AbsenceCubit, ProfStatsState>(
                        listener: (context, state) {
                          if (state is ProfStatsError) {
                            ShowSnackBar.showAnimatedSnackDialog(
                              context: context,
                              message: state.error,
                              type: AnimatedSnackBarType.error,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is ProfStatsLoading ||
                              state is ProfStatsInitial) {
                            return _buildShimmerList();
                          }

                          final modules = state is ProfStatsSuccess
                              ? state.stats.statistics
                              : [];

                          return RefreshIndicator(
                            color: AppColors.blueColorA,
                            backgroundColor: AppColors.whiteColor,
                            onRefresh: () =>
                                context.read<AbsenceCubit>().getAbsences(),
                            child: modules.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.fromLTRB(
                                      25.w,
                                      0,
                                      25.w,
                                      80.h,
                                    ), // Bottom padding for Legend
                                    itemCount: modules.length,
                                    itemBuilder: (context, index) {
                                      final module = modules[index];
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 18.h),
                                        child: ModuleAbsenceCard(
                                          moduleName: module.title,
                                          totalAbsencePercent:
                                              module.totalAbsence,
                                          justifiedPercent:
                                              module.justifiedAbsence,
                                          niveau: module.level,
                                          specialite: module.specialite,
                                          groupe: module.group,
                                        ),
                                      );
                                    },
                                  ),
                          );
                        },
                      ),

                      // ── Floating Legend Box ────────────────────────
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
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _LegendItem(
                                color: Color(0xFF9DD4FF),
                                label: "Total Absences",
                              ),
                              HeightSpace(6),
                              const _LegendItem(
                                color: Color(0xFF3796E2),
                                label: "Absences justifiée",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Helper UI Methods ──────────────────────────────────────────────

  Widget _buildShimmerList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 18.h),
        child: ShimmerEffect(
          baseColor: const Color(0xFFDDE8F5),
          highlightColor: Colors.white,
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE4EEFA),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 400.h,
          child: Center(
            child: Text(
              "Aucune statistique disponible.",
              style: AppStyles.black15w600,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
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
      highlightColor: Colors.white,
      child: CircleAvatar(
        radius: radius.r,
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
      highlightColor: Colors.white,
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
