import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/utils/snack_bar.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/absences/widgets/buttons.dart';
import 'package:scolarite/features/modifier_absences/cubit/absence_modif_cubit.dart';
import 'package:scolarite/features/modifier_absences/cubit/modifier_cubit.dart';
import 'package:scolarite/features/modifier_absences/cubit/modifier_state.dart';
import 'package:scolarite/features/modifier_absences/models/absence_modif_models.dart';

class ModifierAbsencesDetail extends StatefulWidget {
  final VoidCallback onCancel;
  final ModifListeModel data;
  final int? absenceId;

  const ModifierAbsencesDetail({
    super.key,
    required this.data,
    required this.onCancel,
    this.absenceId,
  });

  @override
  State<ModifierAbsencesDetail> createState() => _ModifierAbsencesDetailState();
}

class _ModifierAbsencesDetailState extends State<ModifierAbsencesDetail> {
  List<String> absentsIds = [];
  List<String> presentsIds = [];
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    students = widget.data.etudiants!
        .map(
          (e) => {
            "nom": e.nom,
            "prenom": e.prenom,
            "authId": e.authId,
            "present": e.statut == "PRESENT",
          },
        )
        .toList();

    for (var s in students) {
      final id = s["authId"] ?? "";
      if (s["present"] == true) {
        presentsIds.add(id);
      } else {
        absentsIds.add(id);
      }
    }
    filteredStudents = students;
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStudents = students;
      } else {
        filteredStudents = students.where((student) {
          final fullName =
              "${student["nom"]} ${student["prenom"]}".toLowerCase();
          return fullName.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header TOUJOURS VISIBLE ─────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Modification ", style: AppStyles.blueBBw800),
                HeightSpace(12),
                Text(
                  "   Liste des etudiants",
                  style: AppStyles.black18w500.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                HeightSpace(12),
                Text(
                  "           ${widget.data.niveau}-${widget.data.salle}-${widget.data.module}",
                  style: AppStyles.black45Bold12,
                ),
              ],
            ),
            Text(
              widget.data.date != null
                  ? DateFormat('yyyy-MM-dd').format(widget.data.date!)
                  : '',
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
                // SEARCH + BUTTONS
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
                        onChanged: _filterStudents,
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        style: AppStyles.grey13Bold.copyWith(
                          fontSize: 12.sp,
                          color: const Color(0xff454545),
                        ),
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
                              absentsIds.clear();
                              presentsIds.clear();
                              for (var s in students) {
                                s["present"] = true;
                                presentsIds.add(s["authId"] ?? "");
                              }
                            });
                          },
                        ),
                        WidthSpace(20),
                        topButton(
                          title: "Tous Absent",
                          icon: Icons.person_off_outlined,
                          onPressed: () {
                            setState(() {
                              absentsIds.clear();
                              presentsIds.clear();
                              for (var s in students) {
                                s["present"] = false;
                                absentsIds.add(s["authId"] ?? "");
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                HeightSpace(50),

                // HEADER TABLE
                Row(
                  children: [
                    _headerCell("#", 2),
                    _headerCell("Nom", 3),
                    _headerCell("Prénom", 3),
                    _headerCell("Statut", 4),
                  ],
                ),

                HeightSpace(12),
                Divider(color: const Color(0xff98BFE5), height: 2.w),

                // CONTENU variable : empty OU liste
                Expanded(
                  child: filteredStudents.isEmpty
                      ? _EmptyState()
                      : ListView.builder(
                          itemCount: filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = filteredStudents[index];
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    _cell("${index + 1}", 2),
                                    _cell(student["nom"], 3),
                                    _cell(student["prenom"], 3),
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Transform.scale(
                                            scale: 0.75,
                                            child: Switch(
                                              padding: const EdgeInsets.all(6),
                                              value: student["present"],
                                              onChanged: (val) {
                                                setState(() {
                                                  student["present"] = val;
                                                  final id =
                                                      student["authId"] ?? "";
                                                  if (val) {
                                                    presentsIds.add(id);
                                                    absentsIds.remove(id);
                                                  } else {
                                                    absentsIds.add(id);
                                                    presentsIds.remove(id);
                                                  }
                                                });
                                              },
                                              activeColor: Colors.white,
                                              activeTrackColor:
                                                  const Color(0xffA5D6A7),
                                              inactiveThumbColor:
                                                  const Color(0xffEF9A9A),
                                              inactiveTrackColor: Colors.white,
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

                // BUTTONS BOTTOM
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    bottomButton(
                      title: "Annuler",
                      backgroundColor: const Color(0xffFAFCFE),
                      textColor: const Color(0xff123A7A),
                      onPressed: widget.onCancel,
                    ),
                    WidthSpace(20),
                    BlocConsumer<ModifierCubit, ModifierState>(
                      listener: (context, state) {
                        if (state is ModifierErrorState) {
                          ShowSnackBar.showAnimatedSnackDialog(
                            context: context,
                            message: state.error,
                            type: AnimatedSnackBarType.error,
                          );
                        }
                        if (state is ModifierSuccessState) {
                          ShowSnackBar.showAnimatedSnackDialog(
                            context: context,
                            message:
                                state.data.message ?? "Modification réussie",
                            type: AnimatedSnackBarType.success,
                          );
                          context.read<AbsenceModifCubit>().getAbsences();
                          widget.onCancel();
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is ModifierLoadingState;
                        return bottomButton(
                          title: isLoading ? "Modification..." : "Modifier",
                          icon: Icons.check,
                          onPressed: isLoading
                              ? () {}
                              : () {
                                  context
                                      .read<ModifierCubit>()
                                      .modifierAbsences(
                                        absenceId: widget.absenceId ?? 0,
                                        body: ModifAbsence(
                                          absences: absentsIds,
                                          presences: presentsIds,
                                        ),
                                      );
                                },
                          backgroundColor: const Color(0xff6095E8),
                          textColor: Colors.white,
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
            "Aucun étudiant trouvé",
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