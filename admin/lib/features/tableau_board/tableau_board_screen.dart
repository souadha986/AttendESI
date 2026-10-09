import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/main_screen/widget/custom_app_bar.dart';
import 'package:admin/features/tableau_board/cubit/cards_cubit.dart';
import 'package:admin/features/tableau_board/cubit/cards_state.dart';
import 'package:admin/features/tableau_board/cubit/chart_cubit.dart';
import 'package:admin/features/tableau_board/cubit/chart_state.dart';
import 'package:admin/features/tableau_board/cubit/niveau_cubit.dart';
import 'package:admin/features/tableau_board/cubit/profile_cubit.dart';
import 'package:admin/features/tableau_board/cubit/profile_state.dart';
import 'package:admin/features/tableau_board/cubit/specialite_cubit.dart';
import 'package:admin/features/tableau_board/widget/bar_chart.dart';
import 'package:admin/features/tableau_board/widget/chart_shimmer.dart';
import 'package:admin/features/tableau_board/widget/dashboard_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class TableauBoardScreen extends StatefulWidget {
  final Function(String adminName) onProfileTap;
  const TableauBoardScreen({super.key, required this.onProfileTap});

  @override
  State<TableauBoardScreen> createState() => _TableauBoardScreenState();
}

class _TableauBoardScreenState extends State<TableauBoardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(126.h),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final bool isLoading = state is ProfileLoadingState;

              final String name = state is ProfileSuccessState
                  ? state.profile.nomComplet ?? "Admin"
                  : "Admin";
              return CustomAppBar(
                title: "Tableau de Bord",
                onProfileTap: () {
                  widget.onProfileTap(name);
                },
                userName: isLoading ? null : name,
                isLoading: isLoading,
                showProfileSection: true,
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeightSpace(10),

              BlocBuilder<CardsCubit, CardsState>(
                builder: (context, state) {
                  /// LOADING
                  if (state is CardsLoadingState) {
                    return ShimmerEffect(
                      baseColor: const Color(0xFFDCE8F7),
                      highlightColor: const Color(0xFFBFD4F2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) => Container(
                            width: 220.w,
                            height: 180.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCE8F7),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  /// ERROR
                  if (state is CardsErrorState) {
                    return ErrorS(
                      message: state.error,
                      onRetry: () {
                        context.read<ProfileCubit>().refreshProfile();
                        context.read<CardsCubit>().refreshCards();
                        context.read<NiveauCubit>().getNiveaux();
                        context.read<SpecialiteCubit>().getSpecialites();
                        context.read<ChartCubit>().getChart(
                          niveau: "1CPI",
                          specialite: null,
                        );
                      },
                    );
                  }

                  /// SUCCESS
                  if (state is CardsSuccessState) {
                    final stats = state.cards.stats;

                    if (stats == null) {
                      return const SizedBox();
                    }

                    return DashboardCards(stats: stats);
                  }

                  return const SizedBox();
                },
              ),

              HeightSpace(50),
              BlocConsumer<ChartCubit, ChartState>(
                listener: (context, state) {
                  if (state is ChartError) {}
                },
                builder: (context, state) {
                  if (state is ChartLoading) {
                    return const ChartShimmer();
                  }

                  if (state is ChartSuccess) {
                    return AbsencesBarChart(data: state.chart);
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorS extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorS({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Column(
        children: [
          HeightSpace(100),
          Center(
            child: Container(
              width: 250.w,
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0969BB).withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 42.sp,
                    color: Colors.red.withOpacity(0.7),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppStyles.grey20w500.copyWith(
                      color: const Color(0xFF828282),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0969BB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
