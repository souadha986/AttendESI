import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:scolarite/core/assets/images.dart';
import 'package:scolarite/core/utils/snack_bar.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/justificatifs/cubit/justificatif_cubit.dart';
import 'package:scolarite/features/justificatifs/cubit/refus_cubit.dart';
import 'package:scolarite/features/justificatifs/cubit/refus_state.dart';
import 'package:scolarite/features/justificatifs/cubit/valider_cubit.dart';
import 'package:scolarite/features/justificatifs/cubit/valider_state.dart';
import 'package:scolarite/features/justificatifs/models/justificatifs_model.dart';
import 'package:url_launcher/url_launcher.dart';

class JustificatifDetail extends StatefulWidget {
  final JustificatifDetails justificatif;

  const JustificatifDetail({super.key, required this.justificatif});

  @override
  State<JustificatifDetail> createState() => _JustificatifDetailState();
}

class _JustificatifDetailState extends State<JustificatifDetail> {
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    Future<void> openFile(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {}
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ValiderCubit, ValiderState>(
          listener: (context, state) {
            if (state is ValiderSuccess) {
              Navigator.pop(context);

              context.read<JustificatifsCubit>().fetchAllJustificatifs();

              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: "Justificatif validé avec succès!",
                type: AnimatedSnackBarType.success,
              );
            }

            if (state is ValiderError) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            }
          },
        ),

        BlocListener<RefusCubit, RefusState>(
          listener: (context, state) {
            if (state is RefusSuccess) {
              Navigator.pop(context);

              context.read<JustificatifsCubit>().fetchAllJustificatifs();

              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: "Justificatif refusé avec succès!",
                type: AnimatedSnackBarType.success,
              );
            }

            if (state is RefusError) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            }
          },
        ),
      ],
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 600.w,
          height: 1800.h,
          decoration: BoxDecoration(
            color: Color(0xffF0F7FE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xff454545)),
          ),
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: EdgeInsets.all(50.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Détails du justificatif",
                      style: GoogleFonts.poppins(
                        color: Color(0xff3A3A3A),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              /// BODY
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Column(
                    children: [
                      HeightSpace(20),

                      /// INFOS ETUDIANT
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffD8EAFF),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _card(
                          title: "Informations de l'étudiant",
                          showMaladeIcon:
                              widget.justificatif.etudiant?.maladieChronique ??
                              false,
                          child: Column(
                            children: [
                              _row(
                                "Nom complet :",
                                widget.justificatif.etudiant?.nomComplet ?? "",
                              ),
                              _row(
                                "Email :",
                                widget.justificatif.etudiant?.email ?? "",
                              ),
                              _row(
                                "Niveau :",
                                widget.justificatif.etudiant?.niveau ?? "",
                              ),
                            ],
                          ),
                        ),
                      ),

                      HeightSpace(40),

                      /// DETAILS ABSENCE
                      _card(
                        title: "Détails de l'absence",
                        child: Column(
                          children: [
                            _row(
                              "Module :",
                              widget.justificatif.absence?.modules?.join(
                                    "\n",
                                  ) ??
                                  "",
                            ),
                            _row(
                              "Type :",
                              widget.justificatif.absence?.type ?? "",
                            ),
                            _row(
                              "Date de début d'absence :",
                              formatDate(
                                widget.justificatif.absence?.dateAbsenceDebut,
                              ),
                            ),
                            _row(
                              "date de fin d'absence :",
                              formatDate(
                                widget.justificatif.absence?.dateAbsenceFin,
                              ),
                            ),
                            _row(
                              "Date soumission :",
                              formatDate(
                                widget.justificatif.absence?.dateSoumission,
                              ),
                            ),
                          ],
                        ),
                      ),

                      HeightSpace(40),

                      /// DESCRIPTION
                      _card(
                        title: "Description",
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Text(
                            widget.justificatif.description ?? "",
                            style: GoogleFonts.poppins(
                              color: Color(0xff3A3A3A),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      HeightSpace(40),

                      /// DOCUMENT
                      _card(
                        title: "Document justificatif",
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 16.h),
                            child: Container(
                              height: 250.h,
                              width: 350.w,
                              decoration: BoxDecoration(
                                color: Color(0xffE9F1F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xff454545),
                                  width: 0.5.w,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () => openFile(
                                  widget.justificatif.documentUrl ?? "",
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.description_outlined,
                                        color: Color(0xffFB1C1C),
                                        size: 50.sp,
                                      ),
                                      HeightSpace(20),
                                      Text(
                                        "Voir le document",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          color: Color(0xff3873D2),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      HeightSpace(40),

                      /// COMMENTAIRE
                      _card(
                        title: "Commentaire",
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _commentController,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Le commentaire est obligatoire pour refuser.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Ajouter un commentaire...",
                              filled: true,
                              fillColor: Color(0xffF0F7FE),
                              border: OutlineInputBorder(
                                gapPadding: 10.w,
                                borderRadius: BorderRadius.circular(20.r),
                                borderSide: BorderSide(
                                  color: Color(0xff454545),
                                  width: 0.5.w,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                borderSide: BorderSide(
                                  color: Color(0xff1351FE),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      HeightSpace(40),
                    ],
                  ),
                ),
              ),

              /// FOOTER
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BlocBuilder<RefusCubit, RefusState>(
                      builder: (context, state) {
                        final isLoading = state is RefusLoading;

                        return SizedBox(
                          width: 250.w,
                          height: 70.h,
                          child: OutlinedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<RefusCubit>().refuser(
                                        id: widget.justificatif.id!,
                                        commentaire: _commentController.text,
                                      );
                                    }
                                  },
                            icon: isLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.red,
                                    ),
                                  )
                                : Icon(
                                    Icons.cancel,
                                    size: 20.sp,
                                    color: const Color(0xffEB6E6F),
                                  ),
                            label: Text(
                              isLoading ? "Refus..." : "Refuser",
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xffEB6E6F),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<ValiderCubit, ValiderState>(
                      builder: (context, state) {
                        final isLoading = state is ValiderLoading;

                        return SizedBox(
                          width: 250.w,
                          height: 70.h,
                          child: ElevatedButton.icon(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.read<ValiderCubit>().valider(
                                      widget.justificatif.id!,
                                    );
                                  },
                            icon: isLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    Icons.check_rounded,
                                    size: 20.sp,
                                    color: Colors.white,
                                  ),
                            label: Text(
                              isLoading ? "Validation..." : "Valider",
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4EC670),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CARD
  Widget _card({
    required String title,
    required Widget child,
    bool showMaladeIcon = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Color(0xff454545), width: 0.5.w),
        color: Color(0xffF0F7FE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Color(0xff3A3A3A),
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showMaladeIcon)
                Image.asset(Images.malade, width: 50.w, height: 50.h),
            ],
          ),
          HeightSpace(10),
          child,
        ],
      ),
    );
  }

  /// ROW
  Widget _row(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Color(0xff3A3A3A),
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Color(0xff3A3A3A),
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
