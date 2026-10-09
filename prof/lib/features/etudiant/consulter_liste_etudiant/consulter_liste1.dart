import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prof/core/navigation/app_routes.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/utils/snack_bar.dart';
import 'package:prof/core/widgets/Bottons.dart';
import 'package:prof/core/widgets/spacing.dart';
import 'package:prof/features/etudiant/marquer_absence/widgets/my_stepper.dart';
import 'package:prof/features/etudiant/cubit/niveau_cubit.dart';
import 'package:prof/features/etudiant/cubit/niveau_state.dart';
import 'package:prof/features/etudiant/cubit/specialite_cubit.dart';
import 'package:prof/features/etudiant/cubit/specialite_state.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class ConsulterListe1 extends StatefulWidget {
  const ConsulterListe1({super.key});
  @override
  State<ConsulterListe1> createState() => _ConsulterListe1State();
}

class _ConsulterListe1State extends State<ConsulterListe1> {
  String? selectedNiveau;
  String? selectedSpecialite;
  bool hasSpecialite = false;

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  void _fetchAll() {
    context.read<NiveauCubit>().getniveaux();
    context.read<SpecialiteCubit>().getniveaux();
  }

  Widget _buildShimmerCheckboxList() {
    return Column(
      children: List.generate(3, (index) {
        return ShimmerEffect(
          baseColor: const Color(0xFFDDE8F5),
          highlightColor: Colors.white,
          child: Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            margin: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE4EEFA),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCheckboxList({
    required List<String> items,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      children: items.map((item) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE4EEFA),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: CheckboxListTile(
            title: Text(item, style: AppStyles.black15w600),
            value: selectedValue == item,
            onChanged: (bool? value) {
              onChanged(value == true ? item : null);
            },
            activeColor: AppColors.blueColorA,
            checkColor: Colors.white,
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: EdgeInsets.zero,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("Consulter la liste", style: AppStyles.blueA20w700),
        toolbarHeight: 209.h,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: const MyStepper(currentStep: 1),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColors.blueColorA,
                onRefresh: () async => _fetchAll(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeightSpace(30),

                      // ── Niveau Section ──────────────────────────────────
                      Text(
                        "Niveau",
                        style: AppStyles.blueA15w500.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      HeightSpace(10),
                      BlocConsumer<NiveauCubit, NiveauState>(
                        listener: (context, state) {
                          if (state is NiveauError) {
                            ShowSnackBar.showAnimatedSnackDialog(
                              context: context,
                              message: state.error,
                              type: AnimatedSnackBarType.error,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is NiveauLoading) {
                            return _buildShimmerCheckboxList();
                          } else if (state is NiveauLoaded) {
                            if (state.niveaux.isEmpty) {
                              return SizedBox(
                                height: 300.h,
                                child: Center(
                                  child: Text(
                                    "Pas de niveaux pour vous\npour le moment.",
                                    style: AppStyles.black15w600,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return _buildCheckboxList(
                              items: state.niveaux,
                              selectedValue: selectedNiveau,
                              onChanged: (val) =>
                                  setState(() => selectedNiveau = val),
                            );
                          }
                          return _buildShimmerCheckboxList();
                        },
                      ),

                      BlocBuilder<NiveauCubit, NiveauState>(
                        builder: (context, niveauState) {
                          if (niveauState is! NiveauLoaded ||
                              niveauState.niveaux.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return BlocBuilder<SpecialiteCubit, SpecialiteState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HeightSpace(24),
                                  Text(
                                    "Spécialité:",
                                    style: AppStyles.blueA15w500.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  HeightSpace(10),
                                  BlocConsumer<
                                    SpecialiteCubit,
                                    SpecialiteState
                                  >(
                                    listener: (context, state) {
                                      if (state is SpecialiteError) {
                                        ShowSnackBar.showAnimatedSnackDialog(
                                          context: context,
                                          message: state.error,
                                          type: AnimatedSnackBarType.error,
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is SpecialiteLoading) {
                                        return _buildShimmerCheckboxList();
                                      } else if (state is SpecialiteLoaded) {
                                        return _buildCheckboxList(
                                          items: state.specialities,
                                          selectedValue: selectedSpecialite,
                                          onChanged: (val) => setState(
                                            () => selectedSpecialite = val,
                                          ),
                                        );
                                      }
                                      return _buildShimmerCheckboxList();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      HeightSpace(30),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 16.h),
              child: Bottons(
                onPress: () {
                  if (selectedNiveau == null) {
                    ShowSnackBar.showAnimatedSnackDialog(
                      context: context,
                      message:
                          "Veuillez sélectionner un élément dans la liste des niveaux.",
                      type: AnimatedSnackBarType.error,
                    );
                    return;
                  }
                  context.pushNamed(
                    AppRoutes.consulterliste2,
                    extra: {
                      'niveau': selectedNiveau!,
                      'specialite': selectedSpecialite ?? "NULL",
                    },
                  );
                },
                title: "Suivant",
                textstyle: AppStyles.white15w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
