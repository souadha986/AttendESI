import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/utils/snack_bar.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/absences/cubit/absences_cubit.dart';
import 'package:scolarite/features/absences/cubit/absences_state.dart';
import 'package:scolarite/features/absences/cubit/absences_validate_cubit.dart';
import 'package:scolarite/features/absences/cubit/absences_validate_state.dart';
import 'package:scolarite/features/absences/models/absence_models.dart';
import 'package:scolarite/features/absences/widgets/buttons.dart';

class MarquerAbsences extends StatefulWidget {
  final VoidCallback onCancel;
  final String situation;
  final VoidCallback onSuccess;

  const MarquerAbsences({
    super.key,
    required this.onCancel,
    required this.situation,
    required this.onSuccess,
  });

  @override
  State<MarquerAbsences> createState() => _MarquerAbsencesState();
}

class _MarquerAbsencesState extends State<MarquerAbsences> {
  Timer? _debounce;

  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _searchController.clear();
    _initialized = false;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AbsencesValidateCubit, AbsencesValidateState>(
      listener: (context, validateState) {
        if (validateState is AbsencesValidateSuccess) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: validateState.message,
            type: AnimatedSnackBarType.success,
          );
          widget.onSuccess();
        }

        if (validateState is AbsencesValidateError) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: validateState.error,
            type: AnimatedSnackBarType.error,
          );
        }
      },
      builder: (context, validateState) {
        // ✅ BlocConsumer ici pour gérer AbsenceError dans le listener
        // et non plus dans le builder
        return BlocConsumer<AbsenceCubit, AbsenceState>(
          listener: (context, state) {
            // ✅ CORRIGÉ : snackbar appelé dans listener, jamais dans builder
            if (state is AbsenceError) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.error,
                type: AnimatedSnackBarType.error,
              );
              // Retour à l'écran filtres
              widget.onCancel();
            }
          },
          builder: (context, state) {
            if (state is AbsenceLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xff6095E8)),
              );
            }

            if (state is AbsenceSuccess) {
              final data = state.data;

              if (!_initialized) {
                students =
                    data.etudiants?.map((e) {
                      return {
                        "nom": e.nom ?? "",
                        "prenom": e.prenom ?? "",
                        "matricule": e.matricule ?? "",
                        "authId": e.authId,
                        "present": e.statut == "PRESENT",
                      };
                    }).toList() ??
                    [];

                filteredStudents = List.from(students);
                _initialized = true;
              }

              return _buildContent(data, validateState);
            }

            // AbsenceInitial ou tout autre état non géré
            return const SizedBox.expand();
          },
        );
      },
    );
  }

  Widget _buildContent(
    AbsenceModels data,
    AbsencesValidateState validateState,
  ) {
    final isLoading = validateState is AbsencesValidateLoading;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Absences", style: AppStyles.blueBBw800),
                HeightSpace(12),
                Text(
                  "   Liste des etudiants",
                  style: AppStyles.black18w500.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                HeightSpace(12),
                Text("       ${data.entete}", style: AppStyles.black45Bold12),
              ],
            ),
            Text(
              DateFormat("EEEE d MMMM yyyy", "fr_FR").format(
                data.examen?.date ?? DateTime.now(),
              ),
              style: AppStyles.grey13w700,
            ),
          ],
        ),

        HeightSpace(30),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 5.h),
          child: Container(
            height: 760.h,
            padding: EdgeInsets.all(30.h),
            decoration: BoxDecoration(
              color: const Color(0xffDCECFF),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xff1351FE), width: 1.w),
            ),
            child: Column(
              children: [
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
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        style: AppStyles.grey13Bold.copyWith(
                          fontSize: 12.sp,
                          color: const Color(0xff454545),
                        ),
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) {
                            _debounce!.cancel();
                          }
                          _debounce = Timer(
                            const Duration(milliseconds: 300),
                            () {
                              setState(() {
                                filteredStudents = students.where((s) {
                                  final fullName =
                                      "${s["nom"]} ${s["prenom"]}".toLowerCase();
                                  final matricule =
                                      s["matricule"].toLowerCase();
                                  return fullName.contains(
                                        value.toLowerCase(),
                                      ) ||
                                      matricule.contains(value.toLowerCase());
                                }).toList();
                              });
                            },
                          );
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search_sharp),
                          hintText: "Rechercher par étudiant",
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        topButton(
                          title: "Tous Present",
                          icon: Icons.person_outline_outlined,
                          onPressed: () {
                            setState(() {
                              for (var s in students) {
                                s["present"] = true;
                              }
                              filteredStudents = List.from(students);
                            });
                          },
                        ),
                        WidthSpace(20),
                        topButton(
                          title: "Tous Absent",
                          icon: Icons.person_off_outlined,
                          onPressed: () {
                            setState(() {
                              for (var s in students) {
                                s["present"] = false;
                              }
                              filteredStudents = List.from(students);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                HeightSpace(50),

                Row(
                  children: [
                    _headerCell("#", 2),
                    _headerCell("Nom", 3),
                    _headerCell("Prénom", 3),
                    _headerCell("Matricule", 3),
                    _headerCell("Statut", 4),
                  ],
                ),

                HeightSpace(12),
                Divider(color: const Color(0xff98BFE5), height: 2.w),

                Expanded(
                  child: filteredStudents.isEmpty
                      ? const Center(child: Text(""))
                      : ListView.builder(
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];
                            return Column(
                              key: ValueKey(student["matricule"]),
                              children: [
                                Row(
                                  children: [
                                    _cell("${index + 1}", 2),
                                    _cell(student["nom"], 3),
                                    _cell(student["prenom"], 3),
                                    _cell(student["matricule"], 3),
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Transform.scale(
                                            scale: 0.75,
                                            child: Switch(
                                              key: ValueKey(
                                                student["matricule"],
                                              ),
                                              activeColor: Colors.white,
                                              activeTrackColor: const Color(
                                                0xffA5D6A7,
                                              ),
                                              inactiveThumbColor: const Color(
                                                0xffEF9A9A,
                                              ),
                                              inactiveTrackColor: Colors.white,
                                              value: student["present"],
                                              onChanged: (val) {
                                                setState(() {
                                                  student["present"] = val;
                                                });
                                              },
                                            ),
                                          ),
                                          WidthSpace(40),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: student["present"]
                                                  ? const Color(0xff90C28E)
                                                  : const Color(0xffCF8686),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              student["present"]
                                                  ? "Present"
                                                  : "Absent",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
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

                HeightSpace(20),

                Row(
                  children: [
                    bottomButton(
                      title: "Annuler",
                      backgroundColor: const Color(0xffFAFCFE),
                      textColor: const Color(0xff123A7A),
                      onPressed: widget.onCancel,
                    ),
                    WidthSpace(20),
                    bottomButton(
                      title: isLoading ? "Validation..." : "Valider",
                      backgroundColor: const Color(0xff1E3A8A),
                      textColor: const Color(0xffFAFCFE),
                      onPressed: isLoading
                          ? () {}
                          : () {
                              final state =
                                  context.read<AbsenceCubit>().state
                                      as AbsenceSuccess;

                              final absents = students
                                  .where((s) => s["present"] == false)
                                  .map((s) => s["authId"])
                                  .toList();

                              final presents = students
                                  .where((s) => s["present"] == true)
                                  .map((s) => s["authId"])
                                  .toList();

                              context
                                  .read<AbsencesValidateCubit>()
                                  .validerAbsences(
                                    situation: widget.situation,
                                    examenId: state.data.examen?.id ?? 0,
                                    absences: List<String>.from(absents),
                                    presences: List<String>.from(presents),
                                  );
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _headerCell(String text, int flex) {
  return Expanded(
    flex: flex,
    child: Center(child: Text(text, style: AppStyles.black3ASemiBold)),
  );
}

Widget _cell(String text, int flex) {
  return Expanded(
    flex: flex,
    child: Center(
      child: Text(
        text,
        style: AppStyles.black16wBold.copyWith(fontSize: 14.sp),
      ),
    ),
  );
}