import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/utils/snack_bar.dart';
import 'package:prof/core/widgets/Bottons.dart';
import 'package:prof/core/widgets/spacing.dart';
import 'package:prof/features/etudiant/consulter_liste_etudiant/widgets/information_card.dart';
import 'package:prof/features/etudiant/cubit/liste_etudiant_cubit.dart';
import 'package:prof/features/etudiant/cubit/liste_etudiant_state.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class ListeEtudiant3 extends StatefulWidget {
  final String niveau;
  final String specialite;
  final String groupe;
  final String matiereId;

  const ListeEtudiant3({
    super.key,
    required this.niveau,
    required this.specialite,
    required this.groupe,
    required this.matiereId,
  });

  @override
  State<ListeEtudiant3> createState() => _ListeEtudiant3State();
}

class _ListeEtudiant3State extends State<ListeEtudiant3> {
  @override
  void initState() {
    super.initState();
    context.read<ListeEtudiantCubit>().getEtudiantsaveccompteurs(
      niveau: widget.niveau,
      specialite: widget.specialite,
      groupe: widget.groupe,
      matiereId: widget.matiereId,
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => ShimmerEffect(
        baseColor: const Color(0xFFDDE8F5),
        highlightColor: Colors.white,
        child: Container(
          height: 70.h,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE4EEFA),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 500.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Aucun étudiant trouvé\npour ce groupe.",
                style: AppStyles.black15w600,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des étudiants", style: AppStyles.blueA20w700),
        centerTitle: true,
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        toolbarHeight: 80.h,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeightSpace(38),
              Text(
                "Liste des étudiants:",
                style: AppStyles.blueA15w500.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              HeightSpace(20),
              Expanded(
                child: BlocConsumer<ListeEtudiantCubit, ListeEtudiantState>(
                  listener: (context, state) {
                    if (state is ListeEtudiantError) {
                      ShowSnackBar.showAnimatedSnackDialog(
                        context: context,
                        message: state.message,
                        type: AnimatedSnackBarType.error,
                      );
                    }
                    if (state is ExportError) {
                      ShowSnackBar.showAnimatedSnackDialog(
                        context: context,
                        message: state.message,
                        type: AnimatedSnackBarType.error,
                      );
                    }
                    if (state is ExportSuccess) {
                      ShowSnackBar.showAnimatedSnackDialog(
                        context: context,
                        message: "Excel exporté avec succès!",
                        type: AnimatedSnackBarType.success,
                      );
                    }
                  },
                  builder: (context, state) {
                    final students = context
                        .read<ListeEtudiantCubit>()
                        .cachedStudents;

                    // Show shimmer while loading and no cached data
                    if (state is ListeEtudiantLoading && students.isEmpty) {
                      return _buildShimmer();
                    }

                    // ✅ Show empty state when not loading and list is empty
                    if (students.isEmpty && state is! ListeEtudiantLoading) {
                      return _buildEmptyState();
                    }

                    return Stack(
                      children: [
                        // The Student List
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final s = students[index];
                            return InformationCard(
                              issick: s.maladeCr,
                              fullname: s.nomComplet,
                              matricule: s.matricule,
                              nabsence: s.totalAbsences.toString(),
                              npresence: s.totalPresences.toString(),
                              njustifies: s.absencesJustifiees.toString(),
                            );
                          },
                        ),

                        // The Export Loader overlay
                        if (state is ExportLoading)
                          Container(
                            color: Colors.white.withOpacity(0.6),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(
                                    color: Colors.blue,
                                  ),
                                  HeightSpace(15),
                                  Text(
                                    "Exportation en cours...",
                                    style: AppStyles.blueA15w500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: BlocBuilder<ListeEtudiantCubit, ListeEtudiantState>(
                  builder: (context, state) {
                    bool loading = state is ExportLoading;
                    return Bottons(
                      onPress: loading
                          ? () {}
                          : () {
                              context.read<ListeEtudiantCubit>().exportToExcel(
                                niveau: widget.niveau,
                                specialite: widget.specialite,
                                groupe: widget.groupe,
                                matiereId: widget.matiereId,
                              );
                            },
                      title: loading ? "Patientez..." : "Exporter",
                      textstyle: AppStyles.white15w700,
                    );
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
