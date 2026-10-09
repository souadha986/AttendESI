import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/widgets/spacing.dart';
import 'package:prof/features/planning/cubit/remplacement_cubit.dart';
import 'package:prof/features/planning/cubit/remplacement_state.dart';
import 'package:prof/features/planning/cubit/seance_normale_cubit.dart';
import 'package:prof/features/planning/cubit/seance_normal_state.dart';
import 'package:prof/features/planning/cubit/examen_cubit.dart';
import 'package:prof/features/planning/cubit/examen_state.dart';
import 'package:prof/features/planning/widget/planningerrors.dart';

import 'package:prof/features/planning/widget/exams_card.dart';
import 'package:prof/features/planning/widget/normal_card.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class Planning extends StatefulWidget {
  const Planning({super.key});

  @override
  State<Planning> createState() => _PlanningState();
}

class _PlanningState extends State<Planning> {
  @override
  void initState() {
    super.initState();
    context.read<SeanceNormaleCubit>().getAbsences();
    context.read<ExamenCubit>().getExamen();
    context.read<RemplacementCubit>().getExamenRemplacement();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Emploi du temp", style: AppStyles.blueA20w700),
          centerTitle: true,
          backgroundColor: AppColors.greyColor,
          elevation: 0,
          toolbarHeight: 80.h,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              HeightSpace(20),
              _buildTabBarLayout(),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildNormalList(),
                    _buildExamenList(),
                    _buildRemplList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarLayout() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        indicatorColor: const Color(0xFF0F6BFA),
        indicatorWeight: 2.h,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.black87,
        unselectedLabelColor: const Color(0xFF454545),
        labelStyle: AppStyles.black15w700,
        tabs: const [
          Tab(text: "Normal"),
          Tab(text: "Examen"),
          Tab(text: "Rempl"),
        ],
      ),
    );
  }

  Widget _buildNormalList() {
    return BlocBuilder<SeanceNormaleCubit, SeanceNormaleState>(
      builder: (context, state) {
        if (state is NormalPlanningLoading) return _buildShimmerList();

        if (state is NormalPlanningError) {
          return Planningerrors(
            title1: "Une erreur est survenue",
            title2: "Veuillez vérifier votre connexion et réessayer",
          );
        }

        if (state is NormalPlanningSuccess) {
          if (state.planning.isEmpty) {
            return Planningerrors(
              title1: "Aucune séance",
              title2: "Vous n'avez pas de séances normales planifiées.",
            );
          }
          return RefreshIndicator(
            backgroundColor: AppColors.whiteColor,
            color: const Color(0xFF0F6BFA),
            onRefresh: () async {
              context.read<SeanceNormaleCubit>().getAbsences();
            },
            child: ListView.builder(
              padding: EdgeInsets.only(top: 36.h),
              itemCount: state.planning.length,
              itemBuilder: (context, index) {
                final dayData = state.planning[index];
                return NormalCard(day: dayData.jour, sessions: dayData.seances);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildExamenList() {
    return BlocBuilder<ExamenCubit, ExamenState>(
      builder: (context, state) {
        if (state is ExamenLoading) return _buildShimmerList();

        if (state is ExamenError) {
          return Planningerrors(
            title1: "Une erreur est survenue",
            title2: "Veuillez vérifier votre connexion et réessayer",
          );
        }

        if (state is ExamenSuccess) {
          if (state.exams.isEmpty) {
            return Planningerrors(
              title1: "Aucun examen",
              title2: "Aucun examen n'est planifié pour le moment.",
            );
          }
          return RefreshIndicator(
            backgroundColor: AppColors.whiteColor,
            color: const Color(0xFF0F6BFA),
            onRefresh: () async {
              context.read<ExamenCubit>().getExamen();
            },
            child: ListView.builder(
              padding: EdgeInsets.only(top: 36.h),
              itemCount: state.exams.length,
              itemBuilder: (context, index) {
                final examDay = state.exams[index];
                return ExamenCard(
                  day: examDay.jour,
                  date: DateFormat('dd/MM/yyyy').format(examDay.date),
                  sessions: examDay.activites,
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildRemplList() {
    return BlocBuilder<RemplacementCubit, RemplacementState1>(
      builder: (context, state) {
        if (state is RemplacementLoading) return _buildShimmerList();

        if (state is RemplacementError) {
          return Planningerrors(
            title1: "Une erreur est survenue",
            title2: "Veuillez vérifier votre connexion et réessayer",
          );
        }

        if (state is RemplacementSuccess) {
          if (state.exams.isEmpty) {
            return Planningerrors(
              title1: "Aucun examen",
              title2: "Aucun examen n'est planifié pour le moment.",
            );
          }
          return RefreshIndicator(
            color: const Color(0xFF0F6BFA),
            backgroundColor: AppColors.whiteColor,
            onRefresh: () async {
              context.read<RemplacementCubit>().getExamenRemplacement();
            },
            child: ListView.builder(
              padding: EdgeInsets.only(top: 36.h),
              itemCount: state.exams.length,
              itemBuilder: (context, index) {
                final examDay = state.exams[index];
                return ExamenCard(
                  day: examDay.jour,
                  date: DateFormat('dd/MM/yyyy').format(examDay.date),
                  sessions: examDay.activites,
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 15.h, top: 15.h),
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
}
