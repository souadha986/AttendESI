import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/utils/snack_bar.dart';
import 'package:etudiant/core/widgets/Bottons.dart';
import 'package:etudiant/core/widgets/fields.dart';
import 'package:etudiant/core/widgets/outlined_bottom.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:etudiant/features/settings/cubit/contact_admin_cubit.dart';
import 'package:etudiant/features/settings/cubit/contact_admin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ContactAdmin extends StatefulWidget {
  const ContactAdmin({super.key});

  @override
  State<ContactAdmin> createState() => _ContactAdminState();
}

class _ContactAdminState extends State<ContactAdmin> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    subjectController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _clearFields() {
    subjectController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColors.blueColorA),
        title: Text("Contacter Admin", style: AppStyles.blueA20w700),
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        toolbarHeight: 80.h,
      ),
      body: BlocConsumer<ContactAdminCubit, ContactAdminState>(
        listener: (context, state) {
          if (state is ContactAdminErrorState) {
            ShowSnackBar.showAnimatedSnackDialog(
              context: context,
              message: state.error,
              type: AnimatedSnackBarType.error,
            );
          }
          if (state is ContactAdminSuccessState) {
            ShowSnackBar.showAnimatedSnackDialog(
              context: context,
              message: state.message,
              type: AnimatedSnackBarType.success,
            );
            _clearFields();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HeightSpace(40),
                      Text("  Sujet:", style: AppStyles.black13w500),
                      HeightSpace(9),
                      Fields(
                        title: "Résumer votre problème en une phrase...",
                        isPassword: false,
                        titleStyle: AppStyles.grey16w500,
                        controller: subjectController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ce champ est requis";
                          }
                          if (value.length < 5) {
                            return "Le sujet doit contenir au moins 5 caractères";
                          }
                          if (value.length > 100) {
                            return "Le sujet ne doit pas dépasser 100 caractères";
                          }
                          return null;
                        },
                      ),
                      HeightSpace(40),
                      Text("  Description:", style: AppStyles.black13w500),
                      HeightSpace(9),
                      Fields(
                        title: "Décrire votre situation en détail...",
                        isPassword: false,
                        controller: descriptionController,
                        maxLines: 8,
                        titleStyle: AppStyles.grey16w500,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ce champ est requis";
                          }
                          if (value.length < 20) {
                            return "La description doit contenir au moins 20 caractères";
                          }
                          if (value.length > 1000) {
                            return "La description ne doit pas dépasser 1000 caractères";
                          }
                          return null;
                        },
                      ),
                      HeightSpace(150),
                      Bottons(
                        title: state is ContactAdminLoadingState
                            ? "Envoi en cours..."
                            : "Envoyer la demande",
                        textstyle: AppStyles.white15w700,
                        radius: 20.r,
                        onPress: state is ContactAdminLoadingState
                            ? () {}
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ContactAdminCubit>().sendMessage(
                                    sujet: subjectController.text,
                                    description: descriptionController.text,
                                  );
                                }
                              },
                      ),
                      HeightSpace(25),
                      myOutlinedBottom(
                        onPress: () {
                          _clearFields();
                          context.pop();
                        },
                        title: "Annuler",
                        radius: 20.r,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
