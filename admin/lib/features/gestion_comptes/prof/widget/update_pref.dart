import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/core/widgets/Bottons.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/liste_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/update_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/update_prof_state.dart';
import 'package:admin/features/gestion_comptes/prof/models/prof_model.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Automatically inserts dashes: 12072005 → 12-07-2005
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll('-', '');
    final trimmed = digitsOnly.length > 8
        ? digitsOnly.substring(0, 8)
        : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < trimmed.length; i++) {
      buffer.write(trimmed[i]);
      if (i == 1 || i == 3) buffer.write('-'); // dd-MM-yyyy
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ModifierProfDialog extends StatefulWidget {
  final ProfModel model;
  const ModifierProfDialog({super.key, required this.model});

  @override
  State<ModifierProfDialog> createState() => _ModifierProfDialogState();
}

class _ModifierProfDialogState extends State<ModifierProfDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomCtrl;
  late final TextEditingController _prenomCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _dateCtrl;
  late final TextEditingController _wilayaCtrl;
  late final TextEditingController _descriptionCtrl;

  /// Converts "yyyy-MM-dd..." (from API) → "dd-MM-yyyy" for display.
  String _isoToDisplay(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final d = DateTime.parse(date);
      final dd = d.day.toString().padLeft(2, '0');
      final mm = d.month.toString().padLeft(2, '0');
      final yyyy = d.year.toString();
      return '$dd-$mm-$yyyy';
    } catch (_) {}
    return '';
  }

  /// Converts "dd-MM-yyyy" → "yyyy-MM-ddT00:00:00.000Z" for Prisma.
  String _displayToIso8601(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[1]}-${parts[0]}T00:00:00.000Z';
      }
    } catch (_) {}
    return date;
  }

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.model.nom ?? '');
    _prenomCtrl = TextEditingController(text: widget.model.prenom ?? '');
    _emailCtrl = TextEditingController(text: widget.model.email ?? '');
    _wilayaCtrl = TextEditingController(text: widget.model.willayaNaiss ?? '');
    _descriptionCtrl = TextEditingController(
      text: widget.model.description ?? '',
    );
    _dateCtrl = TextEditingController(
      text: _isoToDisplay(widget.model.dateNaissance?.toIso8601String()),
    );
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _dateCtrl.dispose();
    _wilayaCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Modification Enseignant",
            style: AppStyles.black18w500.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.black),
          ),
        ],
      ),
      content: SizedBox(
        width: 550.w,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _buildField("Nom", _nomCtrl)),
                    WidthSpace(20),
                    Expanded(child: _buildField("Prénom", _prenomCtrl)),
                  ],
                ),
                HeightSpace(18),

                Row(
                  children: [
                    Expanded(child: _buildField("Email", _emailCtrl)),
                    WidthSpace(20),
                    Expanded(
                      child: _buildField(
                        "Date de naissance",
                        _dateCtrl,
                        isDate: true,
                      ),
                    ),
                  ],
                ),
                HeightSpace(18),

                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        "Wilaya de naissance",
                        _wilayaCtrl,
                        isRequired: false,
                      ),
                    ),
                    WidthSpace(20),
                    Expanded(
                      child: _buildField(
                        "Description",
                        _descriptionCtrl,
                        isRequired: false,
                      ),
                    ),
                  ],
                ),
                HeightSpace(20),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: EdgeInsets.only(bottom: 20.h),
      actions: [
        Center(
          child: BlocConsumer<UpdateProfCubit, ProfupdateState>(
            listener: (context, state) {
              if (state is ProfUpdateSuccess) {
                Navigator.pop(context);
                context.read<ProfCubit>().loadProfs();
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: state.message,
                  type: AnimatedSnackBarType.success,
                );
              }
              if (state is ProfupdateError) {
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: state.message,
                  type: AnimatedSnackBarType.error,
                );
              }
            },
            builder: (context, state) {
              return Bottons(
                onPress: () {
                  if (_formKey.currentState!.validate()) {
                    final Map<String, dynamic> data = {
                      "nom": _nomCtrl.text.trim(),
                      "prenom": _prenomCtrl.text.trim(),
                      "email": _emailCtrl.text.trim(),
                      "date_naissance": _displayToIso8601(
                        _dateCtrl.text.trim(),
                      ),
                      "willaya_naiss": _wilayaCtrl.text.trim(),
                      "description": _descriptionCtrl.text.trim(),
                    };

                    context.read<UpdateProfCubit>().modifyProf(
                      widget.model.authId,
                      data,
                    );
                  }
                },
                isloading: state is ProfupdateLoading,
                title: "Enregistrer",
                style: AppStyles.white20w700.copyWith(fontSize: 15.sp),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    bool isDate = false,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.black18w500.copyWith(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        HeightSpace(6),
        TextFormField(
          controller: ctrl,
          cursorColor: AppColors.blueColorE,
          keyboardType: isDate ? TextInputType.number : TextInputType.text,
          inputFormatters: isDate ? [_DateInputFormatter()] : null,
          validator: (value) {
            if (!isRequired) return null;

            if (value == null || value.trim().isEmpty) {
              return "Champ obligatoire";
            }

            if (label == "Email") {
              if (!value.endsWith("@esi-sba.dz")) {
                return "Email doit finir par @esi-sba.dz";
              }
            }

            if (label == "Date de naissance") {
              final regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
              if (!regex.hasMatch(value)) return "Format dd-mm-yyyy";

              final parts = value.split('-');
              final day = int.tryParse(parts[0]) ?? 0;
              final month = int.tryParse(parts[1]) ?? 0;
              final year = int.tryParse(parts[2]) ?? 0;

              if (month < 1 || month > 12) return 'Mois invalide';
              if (day < 1 || day > 31) return 'Jour invalide';

              final date = DateTime(year, month, day);
              if (date.isAfter(DateTime.now())) return 'Date dans le futur';
            }

            return null;
          },
          decoration: InputDecoration(
            isDense: true,
            hintText: isDate ? 'dd-mm-yyyy' : null,
            hintStyle: isDate
                ? TextStyle(color: Colors.grey.shade400, fontSize: 13.sp)
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(color: AppColors.blackColor, width: 1.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
