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
import 'package:prof/core/widgets/spacing.dart';
import 'package:prof/features/etudiant/cubit/etudiant_cubit.dart';
import 'package:prof/features/etudiant/cubit/etudiant_state.dart';
import 'package:prof/features/etudiant/cubit/marquer_absence_cubit.dart';
import 'package:prof/features/etudiant/cubit/marquer_absence_state.dart';
import 'package:prof/features/etudiant/module/etudiant_modifier.dart';
import 'package:prof/features/etudiant/marquer_absence/widgets/student_card.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class ListeModifier extends StatefulWidget {
  final String niveau;
  final String specialite;
  final String groupe;
  final String moduleId;
  final String moduleName;
  final String date;
  final String heure;

  const ListeModifier({
    super.key,
    required this.heure,
    required this.niveau,
    required this.specialite,
    required this.groupe,
    required this.moduleId,
    required this.moduleName,
    required this.date,
  });

  @override
  State<ListeModifier> createState() => _ListeModifierState();
}

class _ListeModifierState extends State<ListeModifier> {
  Map<String, String?> attendance = {};
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    _initialized = false;
    context.read<EtudiantCubit>().getEtudiantsModifies(
      heure: widget.heure,
      niveau: widget.niveau,
      specialite: widget.specialite,
      groupe: widget.groupe,
      matiereid: widget.moduleId,
      date: widget.date,
    );
  }

  void _initAttendance(List<EtudiantModifier> etudiants) {
    if (_initialized) return; // skip on rebuilds, only run once per fetch
    _initialized = true;

    attendance.clear(); // safe to clear — only happens on fresh fetch
    for (var etudiant in etudiants) {
      final status = etudiant.status.toUpperCase();
      if (status == 'ABSENT' || status == 'A') {
        attendance[etudiant.authId] = 'A';
      } else if (status == 'PRESENT' || status == 'P') {
        attendance[etudiant.authId] = 'P';
      } else {
        // INDEFINI or any unknown value — leave as null so professor must pick
        attendance[etudiant.authId] = null;
      }
    }
  }

  void _submit(List<EtudiantModifier> etudiants) {
    final absents = attendance.entries
        .where((e) => e.value == 'A')
        .map((e) => e.key)
        .toList();

    final presents = attendance.entries
        .where((e) => e.value == 'P')
        .map((e) => e.key)
        .toList();

    context.read<MarquerAbsenceCubit>().modifierAbsence(
      heure: widget.heure,
      matiereId: int.tryParse(widget.moduleId) ?? 0,
      date: widget.date,
      niveau: widget.niveau,
      specialite: widget.specialite,
      groupe: int.tryParse(widget.groupe) ?? 0,
      absents: absents,
      presents: presents,
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: List.generate(6, (index) {
        return ShimmerEffect(
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
        );
      }),
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
              SizedBox(height: 16.h),
              TextButton.icon(
                onPressed: _fetch,
                icon: Icon(Icons.refresh, color: AppColors.blueColorA),
                label: Text("Réessayer", style: AppStyles.blueA15w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _allMarked(List<EtudiantModifier> etudiants) {
    return etudiants.every((e) => attendance[e.authId] != null);
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des étudiants", style: AppStyles.blueA20w700),
        centerTitle: true,
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        toolbarHeight: 80.h,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: BlocListener<MarquerAbsenceCubit, MarquerAbsenceState>(
            listener: (context, marquerState) {
              if (marquerState is MarquerAbsenceLoading) {
                setState(() {
                  loading = true;
                });
              }
              if (marquerState is MarquerAbsenceSuccess) {
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: "Absences enregistrées avec succès.",
                  type: AnimatedSnackBarType.success,
                );
                context.pushReplacement(AppRoutes.mainScreen);
              }
              if (marquerState is MarquerAbsenceError) {
                setState(() {
                  loading = false;
                });
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: marquerState.error,
                  type: AnimatedSnackBarType.error,
                );
              }
            },
            child: BlocConsumer<EtudiantCubit, EtudiantState>(
              listener: (context, state) {
                if (state is EtudiantError) {
                  ShowSnackBar.showAnimatedSnackDialog(
                    context: context,
                    message: state.error,
                    type: AnimatedSnackBarType.error,
                  );
                }
                if (state is EtudiantModifierLoaded) {
                  setState(() => _initAttendance(state.etudiant));
                }
              },
              builder: (context, state) {
                return Column(
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
                      child: RefreshIndicator(
                        color: AppColors.blueColorA,
                        onRefresh: () async => _fetch(),
                        child: state is EtudiantLoading
                            ? SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: _buildShimmer(),
                              )
                            : state is EtudiantModifierLoaded
                            ? state.etudiant.isEmpty
                                  ? _buildEmptyState()
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: state.etudiant.length,
                                      itemBuilder: (context, index) {
                                        final etudiant = state.etudiant[index];
                                        return StudentCard(
                                          fullname: etudiant.nomComplet,
                                          matricule: etudiant.matricule,
                                          status: attendance[etudiant.authId],
                                          onSelect: (value) {
                                            setState(() {
                                              attendance[etudiant.authId] =
                                                  value;
                                            });
                                          },
                                        );
                                      },
                                    )
                            : SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: _buildShimmer(),
                              ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: loading
                          ? Bottons(isloading: true, onPress: () {})
                          : Bottons(
                              onPress: () {
                                if (state is! EtudiantModifierLoaded) return;
                                if (!_allMarked(state.etudiant)) {
                                  ShowSnackBar.showAnimatedSnackDialog(
                                    context: context,
                                    message:
                                        "Veuillez vérifier tous les étudiants.",
                                    type: AnimatedSnackBarType.error,
                                  );
                                  return;
                                }
                                _submit(state.etudiant);
                              },
                              title: "Enregistrer",
                              textstyle: AppStyles.white15w700,
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
