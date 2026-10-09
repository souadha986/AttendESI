import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scolarite/core/assets/images.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/contact_admin/widgets/custom_button.dart';
import 'package:scolarite/features/contact_admin/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scolarite/features/contact_admin/cubit/contact_admin_cubit.dart';
import 'package:scolarite/features/contact_admin/cubit/contact_admin_state.dart';
import 'package:scolarite/features/contact_admin/repo/contact_admin_repo.dart';
import 'package:scolarite/core/utils/service_locator.dart';

class ContactAdminScreen extends StatefulWidget {
  const ContactAdminScreen({super.key});

  @override
  State<ContactAdminScreen> createState() => _ContactAdminScreenState();
}

class _ContactAdminScreenState extends State<ContactAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final objetController = TextEditingController();
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactAdminCubit(sl<ContactAdminRepo>()),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: Image.asset(Images.group, fit: BoxFit.fill)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 26.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Contacter Admin", style: AppStyles.blueBBw800),
                  HeightSpace(100),
                  Expanded(
                    child: BlocConsumer<ContactAdminCubit, ContactAdminState>(
                      listener: (context, state) {
                        if (state is ContactAdminSuccess) {
                          AnimatedSnackBar.material(
                            state.message,
                            type: AnimatedSnackBarType.success,
                          ).show(context);

                          objetController.clear();
                          messageController.clear();
                        }

                        if (state is ContactAdminError) {
                          AnimatedSnackBar.material(
                            state.error,
                            type: AnimatedSnackBarType.error,
                          ).show(context);
                        }
                      },
                      builder: (context, state) {
                        return Center(
                          child: Container(
                            width: 550.w,
                            decoration: BoxDecoration(
                              color: Color(0xffE6F2FF),
                              border: Border.all(
                                color: const Color(0xff1351FE),
                              ),
                              borderRadius: BorderRadius.circular(26.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20.sp),
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Envoyer un message",
                                        style: AppStyles.black3ASemiBold
                                            .copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),

                                      HeightSpace(50),

                                      CustomTextField(
                                        label: "Objet",
                                        hint: "Ex: Impossible de ......",
                                        controller: objetController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "L'objet est obligatoire";
                                          }
                                          if (value.length < 5) {
                                            return "Objet trop court";
                                          }
                                          return null;
                                        },
                                      ),

                                      HeightSpace(60),

                                      CustomTextField(
                                        label: "Message",
                                        hint: "Décrivez votre problème ici...",
                                        controller: messageController,
                                        maxLines: 5,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Le message est obligatoire";
                                          }
                                          if (value.length < 10) {
                                            return "Message trop court";
                                          }
                                          return null;
                                        },
                                      ),

                                      HeightSpace(100),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CustomButton(
                                            text: "Annuler",
                                            onPressed: () {
                                              objetController.clear();
                                              messageController.clear();
                                            },
                                            backgroundColor: Color(0xFFFAFCFE),
                                            textColor: Color(0xFF1E3A8A),
                                          ),
                                          CustomButton(
                                            text: state is ContactAdminLoading
                                                ? ""
                                                : "Envoyer",
                                            onPressed:
                                                state is ContactAdminLoading
                                                ? null
                                                : () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      context
                                                          .read<
                                                            ContactAdminCubit
                                                          >()
                                                          .sendMessage(
                                                            sujet:
                                                                objetController
                                                                    .text
                                                                    .trim(),
                                                            description:
                                                                messageController
                                                                    .text
                                                                    .trim(),
                                                          );
                                                    }
                                                  },
                                            backgroundColor: Color(0xFF1E3A8A),
                                            textColor: Colors.white,
                                            icon: state is ContactAdminLoading
                                                ? null
                                                : Icons.check,
                                            child: state is ContactAdminLoading
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
