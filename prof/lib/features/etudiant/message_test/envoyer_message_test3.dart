import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prof/core/navigation/app_routes.dart';

import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/utils/snack_bar.dart';
import 'package:prof/core/widgets/Bottons.dart';
import 'package:prof/core/widgets/fields.dart';
import 'package:prof/core/widgets/spacing.dart';
import 'package:prof/features/etudiant/cubit/module_cubit.dart';
import 'package:prof/features/etudiant/cubit/module_state.dart';

import 'package:prof/features/etudiant/message_test/widget/test_stepper.dart';
import 'package:prof/features/etudiant/module/module.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class EnvoyerMessageTest3 extends StatefulWidget {
  final String niveau;
  final String specialite;
  final List<String> groupe;

  const EnvoyerMessageTest3({
    super.key,
    required this.niveau,
    required this.specialite,
    required this.groupe,
  });

  @override
  State<EnvoyerMessageTest3> createState() => _EnvoyerMessageTest3State();
}

class _EnvoyerMessageTest3State extends State<EnvoyerMessageTest3> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController salleController = TextEditingController();
  Module? selectedModule;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<ModuleCubit>().getmoduletest(
      niveau: widget.niveau,
      specialite: widget.specialite,
      groupe: widget.groupe,
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

  Widget _buildCheckboxList({
    required List<Module> items,
    required Module? selectedValue,
    required ValueChanged<Module?> onChanged,
  }) {
    return Column(
      children: items.map((module) {
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
            title: Text(module.nomMatiere, style: AppStyles.black15w600),
            value: selectedValue?.id == module.id,
            onChanged: (bool? value) {
              onChanged(value == true ? module : null);
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
            child: const TestStepper(currentStep: 3),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                          "Module",
                          style: AppStyles.blueA15w500.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        HeightSpace(10),
                        BlocConsumer<ModuleCubit, ModuleState>(
                          listener: (context, state) {
                            if (state is ModuleError) {
                              ShowSnackBar.showAnimatedSnackDialog(
                                context: context,
                                message: state.error,
                                type: AnimatedSnackBarType.error,
                              );
                            }
                          },
                          builder: (context, state) {
                            Widget modulesWidget;
                            Widget? timeField;

                            if (state is ModuleLoading) {
                              modulesWidget = _buildShimmerCheckboxList();
                              timeField = null; // hide until loaded
                            } else if (state is ModuleLoaded) {
                              if (state.modules.isEmpty) {
                                modulesWidget = SizedBox(
                                  height: 500.h,
                                  child: Center(
                                    child: Text(
                                      "Pas de modules pour vous\npour le moment.",
                                      style: AppStyles.black15w600,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                                timeField = null;
                              } else {
                                modulesWidget = _buildCheckboxList(
                                  items: state.modules,
                                  selectedValue: selectedModule,
                                  onChanged: (val) =>
                                      setState(() => selectedModule = val),
                                );

                                // show time field **only after modules loaded**
                                timeField = Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HeightSpace(40),
                                    Text(
                                      "Salle/Amphi",
                                      style: AppStyles.blueA15w500.copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    HeightSpace(10),
                                    Fields(
                                      controller: salleController,
                                      validator: (val) {
                                        if (val == null || val.isEmpty)
                                          return "Veuillez entrer la salle / l’amphi.";
                                        return null;
                                      },
                                      isPassword: false,
                                      width: 390.w,
                                      title: "Salle/Amphi",
                                      titleStyle: AppStyles.grey14w600.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            } else {
                              modulesWidget = _buildShimmerCheckboxList();
                              timeField = null;
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                modulesWidget,
                                if (timeField != null) timeField,
                              ],
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
                    if (selectedModule == null) {
                      ShowSnackBar.showAnimatedSnackDialog(
                        context: context,
                        message:
                            "Veuillez sélectionner un élément dans la liste.",
                        type: AnimatedSnackBarType.error,
                      );
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      context.pushNamed(
                        AppRoutes.envoyertest4,
                        extra: {
                          'salle': salleController.text,
                          'matiereId': selectedModule!.id.toString(),
                          'niveau': widget.niveau,
                          'groupe': widget.groupe
                              .map((g) => int.tryParse(g) ?? 0)
                              .toList(),
                          'specialite': widget.specialite,
                        },
                      );
                    }
                  },
                  title: "Suivant",
                  textstyle: AppStyles.white15w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
