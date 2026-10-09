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
import 'package:prof/features/etudiant/cubit/envoyer_test_cubit.dart';
import 'package:prof/features/etudiant/cubit/envoyer_test_state.dart';

import 'package:prof/features/etudiant/message_test/widget/test_stepper.dart';

class EnvoyerMessageTest4 extends StatefulWidget {
  final String matiereId;
  final String salle;
  final String niveau;
  final String specialite;
  final List<int> groupe;

  const EnvoyerMessageTest4({
    super.key,
    required this.matiereId,
    required this.salle,
    required this.niveau,
    required this.specialite,
    required this.groupe,
  });

  @override
  State<EnvoyerMessageTest4> createState() => _EnvoyerMessageTest4State();
}

class _EnvoyerMessageTest4State extends State<EnvoyerMessageTest4> {
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController heurefinController = TextEditingController();
  final TextEditingController heuredbeutController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    heurefinController.dispose();
    heuredbeutController.dispose();
    super.dispose();
  }

  String _formatDate(String date) => date.replaceAll('/', '-');

  @override
  Widget build(BuildContext context) {
    return BlocListener<EnvoyerTestCubit, EnvoyerTestState>(
      listener: (context, state) {
        if (state is EnvoyerTestLoading) {
          setState(() {
            isloading = true;
          });
        }
        if (state is EnvoyerTestSuccess) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: "Test envoyé avec succès.",
            type: AnimatedSnackBarType.success,
          );
          context.pushNamed(AppRoutes.mainScreen);
        }
        if (state is EnvoyerTestError) {
          setState(() {
            isloading = false;
          });
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.error,
            type: AnimatedSnackBarType.error,
          );
        }
      },
      child: Scaffold(
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
              child: const TestStepper(currentStep: 4),
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeightSpace(30),
                        Text(
                          "Titre",
                          style: AppStyles.blueA15w500.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        HeightSpace(10),
                        Fields(
                          controller: titleController,
                          validator: (val) => val == null || val.isEmpty
                              ? "Veuillez ajouter un titre."
                              : null,
                          isPassword: false,
                          title: "titre",
                        ),

                        HeightSpace(30),
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
                        Text(
                          "l'heure de début:",
                          style: AppStyles.blueA15w500.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        HeightSpace(10),
                        Fields(
                          controller: heuredbeutController,
                          validator: (val) {
                            if (val == null || val.isEmpty) return "hh:mm";
                            final timeRegExp = RegExp(
                              r"^([01]\d|2[0-3]):([0-5]\d)$",
                            );
                            if (!timeRegExp.hasMatch(val)) {
                              return "Format invalide (hh:mm)";
                            }
                            return null;
                          },
                          isPassword: false,
                          title: "HH:mm",
                        ),

                        HeightSpace(20),
                        Text(
                          "l'heure de fin",
                          style: AppStyles.blueA15w500.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        HeightSpace(10),
                        Fields(
                          controller: heurefinController,
                          validator: (val) {
                            if (val == null || val.isEmpty) return "hh:mm";
                            final timeRegExp = RegExp(
                              r"^([01]\d|2[0-3]):([0-5]\d)$",
                            );
                            if (!timeRegExp.hasMatch(val)) {
                              return "Format invalide (hh:mm)";
                            }
                            return null;
                          },
                          isPassword: false,
                          title: "HH:mm",
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.w,
                    vertical: 16.h,
                  ),
                  child: BlocBuilder<EnvoyerTestCubit, EnvoyerTestState>(
                    builder: (context, state) {
                      return isloading
                          ? Bottons(onPress: () {}, isloading: true)
                          : Bottons(
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<EnvoyerTestCubit>().envoyerTest(
                                    titre: titleController.text.trim(),
                                    niveau: widget.niveau,
                                    specialite: widget.specialite,
                                    groupe: widget.groupe,
                                    matiereId:
                                        int.tryParse(widget.matiereId) ?? 0,
                                    date: _formatDate(
                                      dateController.text.trim(),
                                    ),
                                    heureDebut: heuredbeutController.text
                                        .trim(),
                                    heureFin: heurefinController.text.trim(),
                                    salle: widget.salle,
                                  );
                                }
                              },
                              title: "Envoyer",
                              textstyle: AppStyles.white15w700,
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
