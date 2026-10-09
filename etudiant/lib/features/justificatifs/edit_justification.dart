import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/utils/service_locator.dart';
import 'package:etudiant/core/utils/snack_bar.dart';
import 'package:etudiant/core/widgets/Bottons.dart';
import 'package:etudiant/core/widgets/fields.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:etudiant/features/justificatifs/cubit/update_cubit.dart';
import 'package:etudiant/features/justificatifs/cubit/update_state.dart';
import 'package:etudiant/features/justificatifs/repo/justificatis_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';

class ModifierJustificatifScreen extends StatefulWidget {
  final String id;
  final List<int> matiereIds;
  final String datedebutAbsence;
  final String datefinAbsence;
  final String typeJustification;
  final String raisonAbsence;
  final String? existingFilePath;

  const ModifierJustificatifScreen({
    super.key,
    required this.id,
    required this.matiereIds,
    required this.datedebutAbsence,
    required this.datefinAbsence,
    required this.typeJustification,
    required this.raisonAbsence,
    this.existingFilePath,
  });

  @override
  State<ModifierJustificatifScreen> createState() =>
      _ModifierJustificatifScreenState();
}

class _ModifierJustificatifScreenState
    extends State<ModifierJustificatifScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController datedebutController = TextEditingController();
  final TextEditingController datefinController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  Map<int, String> matieresMap = {};
  List<int> selectedMatiereIds = [];
  bool _formSubmitted = false;

  String? selectedType;
  String? selectedFileName;
  String? selectedFilePath;
  bool isFileChanged = false;

  // Helper method to convert date format
  String _convertToApiDateFormat(String dateStr) {
    // Convert from DD/MM/YYYY to YYYY-MM-DD
    final parts = dateStr.split('/');
    if (parts.length != 3) return dateStr;
    return "${parts[2]}-${parts[1]}-${parts[0]}";
  }

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing values
    datedebutController.text = widget.datedebutAbsence;
    datefinController.text = widget.datefinAbsence;
    reasonController.text = widget.raisonAbsence;
    selectedType = widget.typeJustification;
    selectedMatiereIds = List.from(
      widget.matiereIds,
    ); // This stores the current selections

    // Load matieres
    sl<JustificatifsRepo>().getMatieres().then(
      (data) => setState(() => matieresMap = data),
    );
  }

  @override
  void dispose() {
    datedebutController.dispose();
    datefinController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  DateTime? _parseDate(String input) {
    try {
      final parts = input.split('/');
      return DateTime(
        int.parse(parts[2]), // year
        int.parse(parts[1]), // month
        int.parse(parts[0]), // day
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateCubit, UpdateState>(
      listener: (context, state) {
        if (state is UpdateErrorState) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.error,
            type: AnimatedSnackBarType.error,
          );
        } else if (state is UpdateSuccessState) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: 'Justificatif modifié avec succès.',
            type: AnimatedSnackBarType.success,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Modifier le justificatif",
              style: AppStyles.blueA20w700,
            ),
            centerTitle: true,
            backgroundColor: AppColors.greyColor,
            elevation: 0,
            toolbarHeight: 80.h,
            automaticallyImplyLeading: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeightSpace(20),

                    _buildLabel("Selectionner une matière:"),
                    _buildMultiSelectMatieres(),
                    if (_formSubmitted && selectedMatiereIds.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 6.h, left: 12.w),
                        child: Text(
                          "Veuillez sélectionner au moins une matière",
                          style: TextStyle(color: Colors.red, fontSize: 12.sp),
                        ),
                      ),

                    HeightSpace(18),

                    _buildLabel("La date de début de l'absence:"),
                    Fields(
                      controller: datedebutController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Veuillez entrer une date";
                        }
                        final dateRegExp = RegExp(
                          r"^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$",
                        );
                        if (!dateRegExp.hasMatch(val)) {
                          return "Format invalide (JJ/mm/aaaa)";
                        }
                        return null;
                      },
                      isPassword: false,
                      width: 390.w,
                      title: "JJ/mm/aaaa",
                      titleStyle: AppStyles.grey14w600.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),

                    HeightSpace(18),

                    _buildLabel("La date de fin de l'absence"),
                    Fields(
                      controller: datefinController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Veuillez entrer une date";
                        }

                        final dateRegExp = RegExp(
                          r"^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$",
                        );

                        if (!dateRegExp.hasMatch(val)) {
                          return "Format invalide (JJ/mm/aaaa)";
                        }

                        final debut = _parseDate(datedebutController.text);
                        final fin = _parseDate(val);

                        if (debut != null && fin != null) {
                          if (fin.isBefore(debut)) {
                            return "La date de fin ne peut pas être avant la date de début";
                          }
                        }

                        return null;
                      },
                      isPassword: false,
                      width: 390.w,
                      title: "JJ/mm/aaaa",
                      titleStyle: AppStyles.grey14w600.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),

                    HeightSpace(18),

                    _buildLabel("Type de justification:"),
                    _buildDropdown(
                      items: ["Séance normal", "Test", "Examen"],
                      titre: "--Choisis un type de justification--",
                      value: selectedType,
                      onChanged: (val) => setState(() => selectedType = val),
                      validator: (val) => val == null ? "Champ requis" : null,
                    ),

                    HeightSpace(20),

                    _buildLabel("Raison de l'Absence:"),
                    Fields(
                      controller: reasonController,
                      validator: (val) => (val == null || val.isEmpty)
                          ? "Veuillez expliquer la raison"
                          : null,
                      isPassword: false,
                      width: 390.w,
                      title: "Expliquer la raison de votre absence...",
                      titleStyle: AppStyles.grey14w600.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                      maxLines: 4,
                    ),

                    HeightSpace(18),

                    _buildLabel("Télécharger un document:"),
                    _buildUploadBox(),

                    HeightSpace(30),

                    state is UpdateLoadingState
                        ? Bottons(isloading: true, onPress: () {})
                        : Bottons(
                            textstyle: AppStyles.white15w700.copyWith(
                              fontSize: 15.sp,
                            ),
                            title: "Modifier le justificatif",
                            onPress: () {
                              setState(() => _formSubmitted = true);

                              if (_formKey.currentState!.validate()) {
                                if (selectedMatiereIds.isEmpty) {
                                  ShowSnackBar.showAnimatedSnackDialog(
                                    context: context,
                                    message:
                                        "Veuillez sélectionner au moins une matière",
                                    type: AnimatedSnackBarType.error,
                                  );
                                  return;
                                }

                                if (selectedFilePath == null &&
                                    !isFileChanged &&
                                    widget.existingFilePath == null) {
                                  ShowSnackBar.showAnimatedSnackDialog(
                                    context: context,
                                    message:
                                        "Veuillez télécharger un document justificatif",
                                    type: AnimatedSnackBarType.error,
                                  );
                                  return;
                                }

                                context.read<UpdateCubit>().updateJustification(
                                  id: widget.id,
                                  matiere: selectedMatiereIds,
                                  datedebutAbsence: _convertToApiDateFormat(
                                    datedebutController.text,
                                  ),
                                  datefinAbsence: _convertToApiDateFormat(
                                    datefinController.text,
                                  ),
                                  typeJustification: selectedType!,
                                  raison: reasonController.text,
                                  filePath: selectedFilePath!,
                                );
                              }
                            },
                          ),

                    HeightSpace(20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Text(text, style: AppStyles.blueA15w500),
    );
  }

  Widget _buildMultiSelectMatieres() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.greyColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _formSubmitted && selectedMatiereIds.isEmpty
              ? Colors.red
              : Colors.transparent,
          width: 1.2,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: matieresMap.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                "Chargement des matières...",
                style: AppStyles.grey14w600.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
            )
          : SizedBox(
              height: 200.h,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedMatiereIds.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
                        child: Text(
                          "--Choisir une ou plusieurs matières--",
                          style: AppStyles.grey14w600.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ...matieresMap.entries.map((entry) {
                      final isSelected = selectedMatiereIds.contains(entry.key);
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          entry.value,
                          style: AppStyles.grey14w600.copyWith(
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        value: isSelected,
                        activeColor: AppColors.blueColorA,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              selectedMatiereIds.add(entry.key);
                            } else {
                              selectedMatiereIds.remove(entry.key);
                            }
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    required String titre,
    required Function(String?) onChanged,
    String? value,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      icon: Icon(Icons.arrow_drop_down, color: AppColors.blueColorA),
      dropdownColor: AppColors.greyColor,
      isExpanded: false,
      alignment: AlignmentDirectional.centerStart,
      borderRadius: BorderRadius.circular(20.r),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.greyColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(height: 0),
      ),
      hint: Text(
        titre,
        style: AppStyles.grey14w600.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: SizedBox(
                width: 150.w,
                child: Text(
                  e,
                  style: AppStyles.grey14w600.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildUploadBox() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.any,
        );
        if (result != null && result.files.isNotEmpty) {
          setState(() {
            selectedFileName = result.files.single.name;
            selectedFilePath = result.files.single.path;
            isFileChanged = true;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.sp),
        decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: (selectedFileName != null || widget.existingFilePath != null)
                ? AppColors.blueColorA
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.file_upload_outlined,
              color: AppColors.blueColorE,
              size: 28.sp,
            ),
            HeightSpace(8),
            Text(
              selectedFileName ??
                  (widget.existingFilePath != null
                      ? "Fichier existant (cliquer pour modifier)"
                      : "Cliquer pour télécharger"),
              style: AppStyles.blueA15w500,
              textAlign: TextAlign.center,
            ),
            HeightSpace(4),
            Text(
              "Tous les types de fichiers sont acceptés",
              style: AppStyles.grey14w600,
            ),
          ],
        ),
      ),
    );
  }
}
