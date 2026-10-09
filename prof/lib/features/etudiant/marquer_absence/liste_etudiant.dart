import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
import 'package:prof/features/etudiant/module/etudiant.dart';
import 'package:prof/features/etudiant/marquer_absence/widgets/student_card.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class ListeEtudiant extends StatefulWidget {
  final String time;
  final String niveau;
  final String specialite;
  final String groupe;
  final int moduleId;
  final String moduleName;

  const ListeEtudiant({
    super.key,
    required this.time,
    required this.niveau,
    required this.specialite,
    required this.groupe,
    required this.moduleId,
    required this.moduleName,
  });

  @override
  State<ListeEtudiant> createState() => _ListeEtudiantState();
}

class _ListeEtudiantState extends State<ListeEtudiant> {
  Map<String, String?> attendance = {};

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<EtudiantCubit>().getEtudiants(
      matiereId: widget.moduleId,
      niveau: widget.niveau,
      specialite: widget.specialite,
      groupe: widget.groupe,
    );
  }

  void _initAttendance(List<Etudiant> etudiants) {
    for (var etudiant in etudiants) {
      attendance.putIfAbsent(etudiant.authId, () => null);
    }
  }

  void _submit(List<Etudiant> etudiants) {
    final absents = attendance.entries
        .where((e) => e.value == 'A')
        .map((e) => e.key)
        .toList();

    final presents = attendance.entries
        .where((e) => e.value == 'P')
        .map((e) => e.key)
        .toList();

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    context.read<MarquerAbsenceCubit>().submitAbsences(
      time: widget.time,
      matiereId: widget.moduleId,
      date: today,
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

  bool _allMarked(List<Etudiant> etudiants) {
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
                if (state is EtudiantLoaded) {
                  setState(() => _initAttendance(state.etudiants));
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
                            : state is EtudiantLoaded
                            ? state.etudiants.isEmpty
                                  ? _buildEmptyState()
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: state.etudiants.length,
                                      itemBuilder: (context, index) {
                                        final etudiant = state.etudiants[index];
                                        return StudentCard(
                                          fullname:
                                              "${etudiant.nom} ${etudiant.prenom}",
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
                                if (state is! EtudiantLoaded) return;
                                if (!_allMarked(state.etudiants)) {
                                  ShowSnackBar.showAnimatedSnackDialog(
                                    context: context,
                                    message:
                                        "Veuillez vérifier tous les étudiants.",
                                    type: AnimatedSnackBarType.error,
                                  );
                                  return;
                                }
                                _submit(state.etudiants);
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
