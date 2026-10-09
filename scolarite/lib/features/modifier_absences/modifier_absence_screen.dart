import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scolarite/core/assets/images.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/utils/snack_bar.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/absences/widgets/buttons.dart';
import 'package:scolarite/features/modifier_absences/cubit/absence_modif_cubit.dart';
import 'package:scolarite/features/modifier_absences/cubit/absence_modif_state.dart';
import 'package:scolarite/features/modifier_absences/cubit/modif_liste_cubit.dart';
import 'package:scolarite/features/modifier_absences/cubit/modif_liste_state.dart';
import 'package:scolarite/features/modifier_absences/modifier_absences_detail.dart';

class ModifierAbsenceScreen extends StatefulWidget {
  const ModifierAbsenceScreen({super.key});

  @override
  State<ModifierAbsenceScreen> createState() => _ModifierAbsenceScreenState();
}

class _ModifierAbsenceScreenState extends State<ModifierAbsenceScreen> {
  bool isFirstLoad = true;

  String? _globalError;
  VoidCallback? _retryCallback;

  void _setError(String message, VoidCallback retry) {
    if (_globalError != null) return;
    setState(() {
      _globalError = message;
      _retryCallback = retry;
    });
  }

  void _clearError() {
    if (_globalError == null) return;
    setState(() {
      _globalError = null;
      _retryCallback = null;
    });
  }

  void _retryAll() {
    _clearError();
    context.read<AbsenceModifCubit>().getAbsences();
  }

  @override
  void initState() {
    super.initState();
    context.read<AbsenceModifCubit>().getAbsences();
  }

  void _filterBySalle(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAbsences = absences;
      } else {
        filteredAbsences = absences.where((item) {
          return item["salle"].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
      }
    });
  }

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredAbsences = [];
  List<Map<String, dynamic>> absences = [];

  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat("EEEE d MMMM yyyy", "fr_FR").format(now);
  }

  String selectedView = "list";
  Map<String, dynamic>? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(Images.group, fit: BoxFit.fill)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 26.h),
            child: selectedView == "list"
                ? MultiBlocListener(
                    listeners: [
                      BlocListener<AbsenceModifCubit, AbsenceModifState>(
                        listener: (context, state) {
                          if (state is AbsenceModifErrorState) {
                            _setError(state.error, _retryAll);
                          } else if (state is AbsenceModifSuccessState) {
                            _clearError();
                          }
                        },
                      ),
                      BlocListener<ModifListeCubit, ModifListeState>(
                        listener: (context, state) {
                          if (state is ModifListeErrorState) {
                            ShowSnackBar.showAnimatedSnackDialog(
                              context: context,
                              message: state.error,
                              type: AnimatedSnackBarType.error,
                            );
                          }
                        },
                      ),
                    ],
                    child: Column(
                      children: [
                        // ── Header TOUJOURS VISIBLE ─────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Historique de ce jour",
                                  style: AppStyles.blueBBw800,
                                ),
                                HeightSpace(10),
                                Text(
                                  "     Modification des absences",
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

                        HeightSpace(30),

                        // ── Body : erreur OU tableau ────────────────
                        Expanded(
                          child: _globalError != null
                              ? _ErrorState(
                                  message: _globalError!,
                                  onRetry: _retryCallback!,
                                )
                              : _buildTableBody(),
                        ),
                      ],
                    ),
                  )
                : BlocConsumer<ModifListeCubit, ModifListeState>(
                    listener: (context, state) {
                      if (state is ModifListeErrorState) {
                        ShowSnackBar.showAnimatedSnackDialog(
                          context: context,
                          message: state.error,
                          type: AnimatedSnackBarType.error,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is ModifListeLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff6095E8),
                          ),
                        );
                      }
                      if (state is ModifListeSuccessState) {
                        return ModifierAbsencesDetail(
                          data: state.data,
                          absenceId: state.data.absenceId,
                          onCancel: () {
                            setState(() => selectedView = "list");
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableBody() {
    return BlocBuilder<AbsenceModifCubit, AbsenceModifState>(
      builder: (context, state) {
        if (state is AbsenceModifLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff6095E8)),
          );
        }

        if (state is AbsenceModifSuccessState) {
          final data = state.data;
          absences = (data.absences ?? [])
              .map(
                (e) => {
                  "absenceId": e.absenceId,
                  "salle": e.salle,
                  "niveau": e.niveau,
                  "module": e.module,
                  "effectif": e.effectif,
                  "absent": e.nbAbsents,
                },
              )
              .toList();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_searchController.text.isEmpty) {
              setState(() => filteredAbsences = absences);
            } else {
              _filterBySalle(_searchController.text);
            }
          });

          return _buildTableShell();
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildTableShell() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 5.h),
      child: Container(
        height: 790.h,
        padding: EdgeInsets.all(30.h),
        decoration: BoxDecoration(
          color: const Color(0xffDCECFF),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xff1351FE), width: 1.w),
        ),
        child: Column(
          children: [
            // SEARCH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50.h,
                  width: 300.w,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(54.r),
                  ),
                  child: TextField(
                    onChanged: _filterBySalle,
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_sharp),
                      hintText: "Rechercher par Salle/Amphi",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),

            HeightSpace(50),

            // HEADER TABLE
            Row(
              children: [
                _headerCell("Salle/Amphi", 2),
                _headerCell("Niveau", 2),
                _headerCell("Module", 3),
                _headerCell("Effectif", 2),
                _headerCell("Absent", 2),
                _headerCell("Action", 2),
              ],
            ),

            HeightSpace(12),

            Divider(color: const Color(0xff98BFE5), height: 2.w),

            // CONTENU variable : empty OU liste
            Expanded(
              child: filteredAbsences.isEmpty
                  ? _EmptyState()
                  : ListView.builder(
                      itemCount: filteredAbsences.length,
                      itemBuilder: (context, index) {
                        final item = filteredAbsences[index];
                        return Column(
                          children: [
                            HeightSpace(10),
                            Row(
                              children: [
                                _cell(item["salle"], 2),
                                _cell(item["niveau"], 2),
                                _cell(item["module"], 3),
                                _cell(
                                  "${item["effectif"]}",
                                  2,
                                  color: const Color(0xff0969BB),
                                ),
                                _cell(
                                  "${item["absent"]}",
                                  2,
                                  color: const Color(0xffCF8686),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: bottomButton(
                                      title: 'Modifier',
                                      icon: Icons.edit_outlined,
                                      onPressed: () {
                                        final absenceId = item["absenceId"];
                                        context
                                            .read<ModifListeCubit>()
                                            .getModifListe(absenceId);
                                        setState(() => selectedView = "detail");
                                      },
                                      backgroundColor: const Color(0xffD3CE88),
                                      textColor: const Color(0xff3A3A3A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.blue.shade100),
                          ],
                        );
                      },
                    ),
            ),
          ],
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: const Color(0xFF828282).withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            "Aucune absence trouvée",
            style: AppStyles.grey20w500.copyWith(
              color: const Color(0xFF828282),
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _headerCell(String text, int flex) {
  return Expanded(
    flex: flex,
    child: Center(
      child: Text(
        text,
        style: AppStyles.black3ASemiBold.copyWith(fontWeight: FontWeight.w900),
      ),
    ),
  );
}

Widget _cell(String text, int flex, {Color? color}) {
  return Expanded(
    flex: flex,
    child: Center(
      child: Text(
        text,
        style: AppStyles.black16wBold.copyWith(
          fontSize: 14.sp,
          color: color ?? const Color(0xff454545),
        ),
      ),
    ),
  );
}
