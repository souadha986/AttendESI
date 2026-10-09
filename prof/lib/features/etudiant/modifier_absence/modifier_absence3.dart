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
import 'package:prof/features/etudiant/modifier_absence/widgets/modifier_stepper.dart';
import 'package:prof/features/etudiant/module/module.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class ModifierAbsence3 extends StatefulWidget {
  final String niveau;
  final String specialite;
  final String groupe;

  const ModifierAbsence3({
    super.key,
    required this.niveau,
    required this.specialite,
    required this.groupe,
  });

  @override
  State<ModifierAbsence3> createState() => _ModifierAbsence3State();
}

class _ModifierAbsence3State extends State<ModifierAbsence3> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  Module? selectedModule;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<ModuleCubit>().getmodule(
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

  Widget _buildDateTimeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeightSpace(40),

        Text(
          "Date",
          style: AppStyles.blueA15w500.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        HeightSpace(10),
        Fields(
          controller: dateController,
          validator: (val) {
            if (val == null || val.isEmpty) return "aaaa/mm/jj";
            final dateRegExp = RegExp(
              r"^\d{4}/(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$",
            );
            if (!dateRegExp.hasMatch(val)) {
              return "Format invalide (aaaa/mm/jj)";
            }
            return null;
          },
          isPassword: false,

          title: "aaaa/mm/jj",
        ),

        HeightSpace(20),

        /// HEURE
        Text(
          "Heure",
          style: AppStyles.blueA15w500.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        HeightSpace(10),
        Fields(
          controller: timeController,
          validator: (val) {
            if (val == null || val.isEmpty) return "hh:mm";
            final timeRegExp = RegExp(r"^([01]\d|2[0-3]):([0-5]\d)$");
            if (!timeRegExp.hasMatch(val)) {
              return "Format invalide (hh:mm)";
            }
            return null;
          },
          isPassword: false,

          title: "HH:mm",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        centerTitle: true,
        title: Text("Modifier les Absences", style: AppStyles.blueA20w700),
        toolbarHeight: 209.h,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: const ModifierStepper(currentStep: 3),
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
                            if (state is ModuleLoading) {
                              return _buildShimmerCheckboxList();
                            }

                            if (state is ModuleLoaded) {
                              if (state.modules.isEmpty) {
                                return Center(
                                  child: Text(
                                    "Pas de modules disponibles",
                                    style: AppStyles.black15w600,
                                  ),
                                );
                              }

                              return Column(
                                children: [
                                  _buildCheckboxList(
                                    items: state.modules,
                                    selectedValue: selectedModule,
                                    onChanged: (val) =>
                                        setState(() => selectedModule = val),
                                  ),

                                  /// 👇 ICI les champs apparaissent seulement après chargement
                                  _buildDateTimeFields(),
                                ],
                              );
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

              /// BUTTON
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Bottons(
                  title: "Suivant",
                  textstyle: AppStyles.white15w700,
                  onPress: () {
                    if (selectedModule == null) {
                      ShowSnackBar.showAnimatedSnackDialog(
                        context: context,
                        message: "Veuillez sélectionner un module",
                        type: AnimatedSnackBarType.error,
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      context.pushNamed(
                        AppRoutes.listeetudiantmodifier,
                        extra: {
                          'moduleId': selectedModule!.id.toString(),
                          'moduleName': selectedModule!.nomMatiere,
                          'niveau': widget.niveau,
                          'specialite': widget.specialite,
                          'groupe': widget.groupe,
                          'date': dateController.text,
                          'heure': timeController.text,
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
