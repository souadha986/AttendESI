import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scolarite/core/assets/images.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/utils/service_locator.dart';
import 'package:scolarite/core/utils/snack_bar.dart';
import 'package:scolarite/core/widgets/bottons.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/absences/cubit/absences_cubit.dart';
import 'package:scolarite/features/absences/cubit/absences_state.dart';
import 'package:scolarite/features/absences/cubit/absences_validate_cubit.dart';
import 'package:scolarite/features/absences/cubit/filtre_cubit.dart';
import 'package:scolarite/features/absences/cubit/filtre_state.dart';
import 'package:scolarite/features/absences/marque_absences.dart';
import 'package:scolarite/features/absences/models/absence_models.dart';
import 'package:scolarite/features/absences/repo/absences_repo.dart';
import 'package:scolarite/features/absences/widgets/custom_dropdown.dart';

class AbsencesScreen extends StatefulWidget {
  const AbsencesScreen({super.key});

  @override
  State<AbsencesScreen> createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  bool showStudents = false;

  String? _filtreError;

  void _setFiltreError(String message) {
    if (_filtreError != null) return;
    setState(() => _filtreError = message);
  }

  void _clearFiltreError() {
    if (_filtreError == null) return;
    setState(() => _filtreError = null);
  }

  void _retryFiltre() {
    _clearFiltreError();
    context.read<FiltreCubit>().getFiltres();
  }

  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat("EEEE d MMMM yyyy", "fr_FR").format(now);
  }

  String? niveau;
  String? module;
  String? salle;
  String? specialite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(Images.group, fit: BoxFit.fill)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 26.h),
            child: showStudents
                ? BlocProvider(
                    create: (context) =>
                        AbsencesValidateCubit(sl<AbsenceApi>()),
                    child: MarquerAbsences(
                      onCancel: () => setState(() => showStudents = false),
                      onSuccess: () => setState(() => showStudents = false),
                      situation: niveau!,
                    ),
                  )
                : MultiBlocListener(
                    listeners: [
                      BlocListener<AbsenceCubit, AbsenceState>(
                        listener: (context, state) {
                          if (state is AbsenceSuccess) {
                            setState(() => showStudents = true);
                          }
                          if (state is AbsenceError) {
                            ShowSnackBar.showAnimatedSnackDialog(
                              context: context,
                              message: state.error,
                              type: AnimatedSnackBarType.error,
                            );
                          }
                        },
                      ),

                      BlocListener<FiltreCubit, FiltreState>(
                        listener: (context, state) {
                          if (state is FiltreError) {
                            _setFiltreError(state.error);
                          } else if (state is FiltreSuccess) {
                            _clearFiltreError();
                          }
                        },
                      ),
                    ],
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Absences", style: AppStyles.blueBBw800),
                                HeightSpace(12),
                                Text(
                                  "   Sélection de l'examen",
                                  style: AppStyles.black18w500.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              getFormattedDate(),
                              style: AppStyles.grey13w700,
                            ),
                          ],
                        ),

                        HeightSpace(50),

                        Expanded(
                          child: _filtreError != null
                              ? _ErrorState(
                                  message: _filtreError!,
                                  onRetry: _retryFiltre,
                                )
                              : _buildBody(),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<FiltreCubit, FiltreState>(
      builder: (context, state) {
        if (state is FiltreLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff6095E8)),
          );
        }

        if (state is FiltreSuccess) {
          final filtres = state.filtres;
          final niveauxList = filtres.niveaux ?? [];

          niveau ??= niveauxList.isNotEmpty ? niveauxList.first : null;

          final modulesList =
              filtres.matieresByNiveau?[niveau]
                  ?.map((e) => e.nom ?? "")
                  .toList() ??
              [];
          final sallesList = filtres.salles ?? [];
          final specialitesList = filtres.specialitesByNiveau?[niveau] ?? [];

          module ??= modulesList.isNotEmpty ? modulesList.first : null;
          salle ??= sallesList.isNotEmpty ? sallesList.first : null;
          specialite ??= specialitesList.isNotEmpty
              ? specialitesList.first
              : null;

          return _buildFiltersPageWithData(
            filtres,
            niveauxList,
            modulesList,
            sallesList,
            specialitesList,
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildFiltersPageWithData(
    FiltreModel filtres,
    List<String> niveauxList,
    List<String> modulesList,
    List<String> sallesList,
    List<String> specialitesList,
  ) {
    return Center(
      child: Container(
        height: 750.h,
        width: 750.w,
        decoration: BoxDecoration(
          color: const Color(0xffDCECFF),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xff1351FE), width: 1.w),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(Images.filter, width: 100.w, height: 100.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Filtres de l'examen", style: AppStyles.blueBBw800),
                      HeightSpace(10),
                      Text(
                        "Sélectionnez les critères pour afficher la liste des étudiants",
                        style: AppStyles.grey67Bold,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: Color(0xff98BFE5)),
              HeightSpace(60),

              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      title: "Niveau",
                      value: niveauxList.contains(niveau) ? niveau : null,
                      items: niveauxList,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            niveau = val;
                            module = null;
                            specialite = null;
                          });
                        }
                      },
                      enabled: true,
                    ),
                  ),
                  Expanded(
                    child: CustomDropdown(
                      title: "Module",
                      value: modulesList.contains(module) ? module : null,
                      items: modulesList,
                      onChanged: (val) {
                        if (val != null) setState(() => module = val);
                      },
                      enabled: true,
                    ),
                  ),
                ],
              ),

              HeightSpace(70),

              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      title: "Salle/Amphi",
                      value: sallesList.contains(salle) ? salle : null,
                      items: sallesList,
                      onChanged: (val) {
                        if (val != null) setState(() => salle = val);
                      },
                      enabled: true,
                    ),
                  ),
                  Expanded(
                    child: CustomDropdown(
                      title: "Spécialité",
                      value: specialitesList.contains(specialite)
                          ? specialite
                          : null,
                      items: specialitesList,
                      hint: specialitesList.isEmpty
                          ? "Pas de spécialité pour ce niveau"
                          : "Sélectionner une spécialité",
                      enabled: specialitesList.isNotEmpty,
                      onChanged: (val) {
                        if (val != null) setState(() => specialite = val);
                      },
                    ),
                  ),
                ],
              ),

              HeightSpace(100),

              Center(
                child: Bottons(
                  title: 'Afficher les etudiants',
                  onPress: () {
                    final matiere = filtres.matieresByNiveau?[niveau]
                        ?.cast<MatieresByNiveau?>()
                        .firstWhere(
                          (e) => e?.nom == module,
                          orElse: () => null,
                        );

                    if (matiere == null) {
                      // Afficher une erreur à l'utilisateur
                      ShowSnackBar.showAnimatedSnackDialog(
                        context: context,
                        message: "Veuillez sélectionner un module valide.",
                        type: AnimatedSnackBarType.error,
                      );
                      return;
                    }

                    context.read<AbsenceCubit>().getEtudiantsAbsence(
                      situation: niveau!,
                      matiereId: matiere.id?.toString() ?? "",
                      salle: salle!,
                      date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
                      specialite: specialite,
                    );
                  },
                  radius: 22.r,
                  width: 250.w,
                  style: AppStyles.white20w700.copyWith(fontSize: 16.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250.w,
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0969BB).withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 42.sp,
              color: Colors.red.withOpacity(0.7),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.grey20w500.copyWith(
                color: const Color(0xFF828282),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6095E8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
