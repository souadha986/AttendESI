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
import 'package:prof/features/etudiant/cubit/groupe_cubit.dart';
import 'package:prof/features/etudiant/cubit/groupe_state.dart';
import 'package:prof/features/etudiant/message_test/widget/test_stepper.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class EnvoyerMessageTest2 extends StatefulWidget {
  final String niveau;
  final String specialite;

  const EnvoyerMessageTest2({
    super.key,
    required this.niveau,
    required this.specialite,
  });

  @override
  State<EnvoyerMessageTest2> createState() => _EnvoyerMessageTest2State();
}

class _EnvoyerMessageTest2State extends State<EnvoyerMessageTest2> {
  // multi-sélection → Set de String
  final Set<String> selectedGroupes = {};

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<GroupeCubit>().getgroupes(
      niveau: widget.niveau,
      specialite: widget.specialite,
    );
  }

  Widget _buildShimmerCheckboxList() {
    return Column(
      children: List.generate(5, (index) {
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

  Widget _buildCheckboxList({required List<String> items}) {
    return Column(
      children: items.map((item) {
        final isSelected = selectedGroupes.contains(item);
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
            value: isSelected,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedGroupes.add(item);
                } else {
                  selectedGroupes.remove(item);
                }
              });
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
        title: Text("Envoyer message du test", style: AppStyles.blueA20w700),
        toolbarHeight: 209.h,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: const TestStepper(currentStep: 2),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColors.blueColorA,
                onRefresh: () async => _fetch(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeightSpace(30),
                      Text(
                        "Groupe",
                        style: AppStyles.blueA15w500.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      HeightSpace(10),
                      BlocConsumer<GroupeCubit, GroupeState>(
                        listener: (context, state) {
                          if (state is GroupeError) {
                            ShowSnackBar.showAnimatedSnackDialog(
                              context: context,
                              message: state.error,
                              type: AnimatedSnackBarType.error,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is GroupeLoading) {
                            return _buildShimmerCheckboxList();
                          } else if (state is GroupeLoaded) {
                            if (state.groupes.isEmpty) {
                              return SizedBox(
                                height: 500.h,
                                child: Center(
                                  child: Text(
                                    "Pas de groupes pour vous\npour le moment.",
                                    style: AppStyles.black15w600,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return _buildCheckboxList(items: state.groupes);
                          }
                          return _buildShimmerCheckboxList();
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
                  if (selectedGroupes.isEmpty) {
                    ShowSnackBar.showAnimatedSnackDialog(
                      context: context,
                      message: "Veuillez sélectionner au moins un groupe.",
                      type: AnimatedSnackBarType.error,
                    );
                    return;
                  }

                  // convertit Set<String> → List<int> pour l'API
                  final List<String> groupeIds = selectedGroupes.toList();

                  //  .map((g) => int.tryParse(g) ?? 0)
                  //  .where((g) => g != 0)
                  // .toList();

                  context.pushNamed(
                    AppRoutes.envoyertest3,
                    extra: {
                      'niveau': widget.niveau,
                      'specialite': widget.specialite,
                      'groupe': groupeIds, // ← List<int>
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
