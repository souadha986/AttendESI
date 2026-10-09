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
import 'package:prof/features/etudiant/cubit/remplacement_cubit.dart';
import 'package:prof/features/etudiant/cubit/remplacement_state.dart';
import 'package:prof/features/etudiant/message_test/widget/test_stepper.dart';

class MessageRemplacement4 extends StatefulWidget {
  final String dateAbsence;
  final String matiereId;
  final String salle;
  final String niveau;
  final String specialite;
  final List<int> groupe;
  final String dateRemplacement;
  final String heuredebut;
  final String heurefin;

  const MessageRemplacement4({
    super.key,
    required this.dateRemplacement,
    required this.heurefin,
    required this.heuredebut,
    required this.dateAbsence,
    required this.matiereId,
    required this.salle,
    required this.niveau,
    required this.specialite,
    required this.groupe,
  });

  @override
  State<MessageRemplacement4> createState() => _MessageRemplacement4State();
}

class _MessageRemplacement4State extends State<MessageRemplacement4> {
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;
  final TextEditingController titleController = TextEditingController();
  List<String> authid = [];

  @override
  void initState() {
    super.initState();
    context.read<EligibleAbsentsCubit>().getlisterempacement(
      matiereId: widget.matiereId,
      dateAbsence: widget.dateAbsence,
      niveau: widget.niveau,
      specialite: widget.specialite,
      groupe: widget.groupe,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  String _formatDate(String date) => date.replaceAll('/', '-');

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ✅ Listener 1: handles EnvoyerTest side effects (loading, success, error)
        BlocListener<EnvoyerTestCubit, EnvoyerTestState>(
          listener: (context, state) {
            if (state is EnvoyerTestLoading) {
              setState(() => isloading = true);
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
              setState(() => isloading = false);
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.error,
                type: AnimatedSnackBarType.error,
              );
            }
          },
        ),
        // ✅ Listener 2: safely updates authid outside the build phase
        BlocListener<EligibleAbsentsCubit, RemplacementState>(
          listener: (context, state) {
            if (state is EligibleAbsentsSuccess) {
              setState(() {
                authid = state.students
                    .map((s) => s.authId.toString())
                    .toList();
              });
            }
          },
        ),
      ],
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
                        HeightSpace(20),
                        Text(
                          "Envoyer à:",
                          style: AppStyles.blueA15w500.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        HeightSpace(10),
                        // ✅ BlocBuilder only handles UI — no setState here
                        BlocBuilder<EligibleAbsentsCubit, RemplacementState>(
                          builder: (context, state) {
                            if (state is EligibleAbsentsLoading) {
                              return _buildDisplayList(
                                items: [],
                                titre: "loading......",
                                isLoading: true,
                              );
                            } else if (state is EligibleAbsentsSuccess) {
                              if (state.students.isEmpty) {
                                return _buildDisplayList(
                                  items: [],
                                  titre: "Aucun étudiant concerné",
                                  isLoading: false,
                                );
                              }
                              final names = state.students
                                  .map((s) => "${s.nom} ${s.prenom}")
                                  .toList();
                              // ✅ No setState here anymore — authid is updated via BlocListener above
                              return _buildDisplayList(
                                items: names,
                                titre: "liste des etudiants",
                              );
                            } else if (state is EligibleAbsentsError) {
                              return _buildDisplayList(
                                items: [],
                                titre: "Erreur de chargement",
                                isLoading: false,
                              );
                            }
                            return _buildDisplayList(
                              items: [],
                              titre: "liste des etudiants",
                            );
                          },
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
                                  if (authid.isEmpty) {
                                    ShowSnackBar.showAnimatedSnackDialog(
                                      context: context,
                                      message: "Aucun étudiant concerné",
                                      type: AnimatedSnackBarType.error,
                                    );
                                  } else {
                                    context
                                        .read<EnvoyerTestCubit>()
                                        .envoyerTestRemplacement(
                                          authids: authid,
                                          dateRemplacement:
                                              widget.dateRemplacement,
                                          titre: titleController.text.trim(),
                                          niveau: widget.niveau,
                                          specialite: widget.specialite,
                                          groupe: widget.groupe,
                                          matiereId:
                                              int.tryParse(widget.matiereId) ??
                                              0,
                                          dateAbsence: _formatDate(
                                            widget.dateAbsence,
                                          ),
                                          heureDebut: widget.heuredebut,
                                          heureFin: widget.heurefin,
                                          salle: widget.salle,
                                        );
                                  }
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

  Widget _buildDisplayList({
    required List<String> items,
    required String titre,
    bool isLoading = false,
  }) {
    bool canExpand = items.isNotEmpty && !isLoading;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: canExpand ? null : Colors.transparent,
          highlightColor: canExpand ? null : Colors.transparent,
        ),
        child: ExpansionTile(
          enabled: canExpand,
          title: Text(
            titre,
            style: AppStyles.grey14w600.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
          trailing: canExpand
              ? Icon(Icons.arrow_drop_down, color: AppColors.blueColorA)
              : const SizedBox.shrink(),
          children: items
              .map(
                (item) => ListTile(
                  title: Text(
                    item,
                    style: AppStyles.grey14w600.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
