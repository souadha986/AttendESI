import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scolarite/core/assets/images.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/planning/cubit/planning_cubit.dart';
import 'package:scolarite/features/planning/cubit/planning_state.dart';
import 'package:scolarite/features/planning/models/planning_models.dart';
import 'package:scolarite/features/planning/widget/planning_table.dart';
import 'package:scolarite/features/profile/cubit/profile_cubit.dart';
import 'package:scolarite/features/profile/cubit/profile_state.dart';
import 'package:scolarite/features/profile/models/profile_model.dart';
import 'package:scolarite/features/planning/cubit/exam_cubit.dart';
import 'package:scolarite/features/planning/cubit/exam_state.dart';
import 'package:scolarite/features/planning/widget/exam_table.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  String selectedNiveau = '';
  String selectedType = "Emploi du Temps";
  List<String> types = ["Emploi du Temps", "Examens"];
  List<String> niveauxAutorises = [];

  NormalPlanning? planningNormal;
  ExamPlanning? examPlanning;
  ProfileModel? profile;

  String? _globalError;

  void _setError(String message) {
    if (_globalError != null) return;
    setState(() => _globalError = message);
  }

  void _clearError() {
    if (_globalError == null) return;
    setState(() => _globalError = null);
  }

  void _retry() {
    _clearError();
    context.read<ProfileCubit>().refreshProfile();
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileErrorState) {
      _globalError = state.error;
    }
    context.read<ProfileCubit>().refreshProfile();
  }

  String get initialNiveau {
    if (profile != null) {
      final niveaux = profile!.niveauxAutorises ?? [];
      if (niveaux.isEmpty) return '1CS';
      if (profile!.cycleResponsable?.toUpperCase() == 'SUPERIEUR') {
        return niveaux.firstWhere(
          (n) => n.contains('1CS'),
          orElse: () => niveaux.first,
        );
      } else if (profile!.cycleResponsable?.toLowerCase().contains(
            'preparatoire',
          ) ??
          false || niveaux.any((n) => n.contains('CPI'))) {
        return niveaux.firstWhere(
          (n) => n.contains('1CPI'),
          orElse: () => niveaux.first,
        );
      }
      return niveaux.first;
    }
    return '';
  }

  Widget _buildDropdown({
    required String title,
    required String value,
    required List<String> items,
    required double width,
    Function(String?)? onChanged,
  }) {
    final safeValue = items.isEmpty
        ? ''
        : (items.contains(value) ? value : items.first);

    return Column(
      children: [
        Text(title, style: AppStyles.grey67Bold),
        HeightSpace(8),
        Container(
          width: width,
          height: 55.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: onChanged != null
                ? const Color(0xffF0F6FC)
                : const Color.fromARGB(255, 235, 237, 238),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonFormField<String>(
            borderRadius: BorderRadius.circular(22.r),
            dropdownColor: const Color(0xffF0F7FE),
            value: safeValue,
            onChanged: onChanged,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            decoration: const InputDecoration(border: InputBorder.none),
            items: items
                .toSet()
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Center(child: Text(e, style: AppStyles.grey82Bold)),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final niveauxList = niveauxAutorises.isEmpty ? [''] : niveauxAutorises;
    final safeSelected = niveauxList.isEmpty
        ? '1CS'
        : (niveauxList.contains(selectedNiveau)
              ? selectedNiveau
              : niveauxList.first);

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileErrorState) {
              _setError(state.error);
            } else if (state is ProfileSuccessState) {
              _clearError();
              setState(() {
                profile = state.profile;
                niveauxAutorises = profile!.niveauxAutorises ?? [];
                selectedNiveau = niveauxAutorises.isEmpty
                    ? '1CS'
                    : niveauxAutorises.first;
              });
              if (selectedType == "Emploi du Temps") {
                context.read<PlanningCubit>().getPlanning(
                  niveau: selectedNiveau,
                );
              }
            }
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: Image.asset(Images.group, fit: BoxFit.fill)),
            Padding(
              padding: EdgeInsets.only(top: 26.h, right: 50.w, left: 50.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Planning", style: AppStyles.blueBBw800),
                  HeightSpace(60),
                  SizedBox(width: double.infinity),

                  Expanded(
                    child: _globalError != null
                        ? _ErrorState(message: _globalError!, onRetry: _retry)
                        : _buildBody(safeSelected, niveauxList),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(String safeSelected, List<String> niveauxList) {
    return Column(
      children: [
        Row(
          children: [
            _buildDropdown(
              title: "Niveau",
              value: safeSelected,
              items: niveauxList,
              width: 160.w,
              onChanged: selectedType == "Emploi du Temps"
                  ? (val) {
                      setState(() => selectedNiveau = val!);
                      context.read<PlanningCubit>().getPlanning(niveau: val!);
                    }
                  : null,
            ),
            WidthSpace(30),
            _buildDropdown(
              title: "Type de Planning",
              value: selectedType,
              items: types,
              width: 230.w,
              onChanged: (val) {
                setState(() => selectedType = val!);
                if (selectedType == "Examens") {
                  context.read<ExamCubit>().getExamens();
                } else {
                  context.read<PlanningCubit>().getPlanning(
                    niveau: selectedNiveau,
                  );
                }
              },
            ),
          ],
        ),

        HeightSpace(20),

        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff123A7A)),
                borderRadius: BorderRadius.circular(26.r),
                color: const Color(0xFFA9C5E1),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 50.w, top: 30.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedType == "Emploi du Temps"
                            ? "Emploi du Temps - $selectedNiveau"
                            : "Examens",
                        style: AppStyles.blueDBw800.copyWith(
                          color: const Color(0xff213656),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xff123A7A)),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20.w,
                        right: 20.w,
                        top: 10.h,
                        bottom: 5.h,
                      ),
                      child: selectedType == "Emploi du Temps"
                          ? BlocConsumer<PlanningCubit, PlanningState>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                if (state is PlanningLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xff6095E8),
                                    ),
                                  );
                                }
                                if (state is PlanningSuccess) {
                                  planningNormal = state.planning;
                                  final hasData =
                                      planningNormal != null &&
                                      planningNormal!
                                              .emploiDuTemps
                                              ?.niveaux?[selectedNiveau]
                                              ?.specialites !=
                                          null &&
                                      planningNormal!
                                          .emploiDuTemps!
                                          .niveaux![selectedNiveau]!
                                          .specialites!
                                          .isNotEmpty;

                                  return hasData
                                      ? PlanningTable(
                                          planning: planningNormal!,
                                          niveau: selectedNiveau,
                                        )
                                      : SizedBox(
                                          height: 580.h,
                                          child: Center(
                                            child: Text(
                                              "Aucune donnée disponible",
                                              style: AppStyles.grey67Bold,
                                            ),
                                          ),
                                        );
                                }
                                return const SizedBox();
                              },
                            )
                          : BlocConsumer<ExamCubit, ExamState>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                if (state is ExamLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xff6095E8),
                                    ),
                                  );
                                }
                                if (state is ExamSuccess) {
                                  examPlanning = state.examPlanning;
                                  final isEmpty =
                                      examPlanning == null ||
                                      examPlanning!.examens == null ||
                                      examPlanning!
                                          .examens!
                                          .isEmpty; // now uses the fixed getter

                                  if (isEmpty) {
                                    return _ErrorState(
                                      message: "Aucune donnée disponible",
                                      onRetry: () => context
                                          .read<ExamCubit>()
                                          .getExamens(),
                                    );
                                  }
                                  return ExamTable(examPlanning: examPlanning!);
                                }
                                if (state is ExamError) {
                                  return _ErrorState(
                                    message: state.message,
                                    onRetry: () =>
                                        context.read<ExamCubit>().getExamens(),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
