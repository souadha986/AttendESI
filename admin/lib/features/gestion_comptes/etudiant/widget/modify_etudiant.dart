import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/core/widgets/Bottons.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/liste_etudiant_cubit.dart';

import 'package:admin/features/gestion_comptes/etudiant/models/etudiant_model.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/update_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/update_etudiant_state.dart';

/// Automatically inserts dashes so the user types: 12072005 → 12-07-2005
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll('-', '');

    // Limit to 8 digits (ddmmyyyy)
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

class ModifierEtudiantDialog extends StatefulWidget {
  final EtudiantModel model;
  const ModifierEtudiantDialog({super.key, required this.model});

  @override
  State<ModifierEtudiantDialog> createState() => _ModifierEtudiantDialogState();
}

class _ModifierEtudiantDialogState extends State<ModifierEtudiantDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomCtrl,
      _prenomCtrl,
      _emailCtrl,
      _dateCtrl,
      _matriculeCtrl,
      _wilayaCtrl,
      _niveauCtrl,
      _groupeCtrl,
      _specialiteCtrl;

  late bool _isMalade;

  @override
  void initState() {
    super.initState();

    _nomCtrl = TextEditingController(text: widget.model.nom);
    _prenomCtrl = TextEditingController(text: widget.model.prenom);
    _emailCtrl = TextEditingController(text: widget.model.email);
    // model.dateNaissance comes as "yyyy-MM-dd", display as "dd-MM-yyyy"
    _dateCtrl = TextEditingController(
      text: widget.model.dateNaissance != null
          ? _isoToDisplay(widget.model.dateNaissance!)
          : '',
    );
    _matriculeCtrl = TextEditingController(text: widget.model.matricule);
    _wilayaCtrl = TextEditingController(text: widget.model.wilaya);
    _niveauCtrl = TextEditingController(text: widget.model.niveau);
    _specialiteCtrl = TextEditingController(text: widget.model.specialite);
    _groupeCtrl = TextEditingController(text: widget.model.groupe.toString());

    _isMalade = widget.model.maladieCr;
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _dateCtrl.dispose();
    _matriculeCtrl.dispose();
    _wilayaCtrl.dispose();
    _niveauCtrl.dispose();
    _specialiteCtrl.dispose();
    _groupeCtrl.dispose();
    super.dispose();
  }

  /// Converts "yyyy-MM-dd" (from API) → "dd-MM-yyyy" (for display).
  String _isoToDisplay(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3 && parts[0].length == 4) {
        return '${parts[2]}-${parts[1]}-${parts[0]}';
      }
    } catch (_) {}
    return date;
  }

  /// Converts "dd-MM-yyyy" (user input) → "yyyy-MM-ddT00:00:00.000Z" for Prisma.
  String _displayToIso8601(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        final dd = parts[0];
        final mm = parts[1];
        final yyyy = parts[2];
        return '${yyyy}-${mm}-${dd}T00:00:00.000Z';
      }
    } catch (_) {}
    return date;
  }

  /// Validates that the string is a real calendar date in dd-MM-yyyy format.
  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) return 'Ce champ est obligatoire';

    final regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!regex.hasMatch(value)) return 'Format invalide : dd-mm-yyyy';

    try {
      final parts = value.split('-');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      if (month < 1 || month > 12) return 'Mois invalide';
      if (day < 1 || day > 31) return 'Jour invalide';

      final date = DateTime(year, month, day);
      if (date.isAfter(DateTime.now())) return 'Date dans le futur';
    } catch (_) {
      return 'Date invalide';
    }

    return null;
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
            "Modification",
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
                    Expanded(child: _buildField("Matricule", _matriculeCtrl)),
                    WidthSpace(20),
                    Expanded(child: _buildField("Niveau", _niveauCtrl)),
                  ],
                ),
                HeightSpace(18),

                Row(
                  children: [
                    Expanded(
                      child: _buildField("Wilaya de naissance", _wilayaCtrl),
                    ),
                    WidthSpace(20),
                    Expanded(child: _buildField("Groupe", _groupeCtrl)),
                  ],
                ),
                HeightSpace(18),

                _buildField("Spécialité", _specialiteCtrl),
                HeightSpace(20),

                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _isMalade,
                        activeColor: const Color(0xFF0084FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        onChanged: (v) => setState(() => _isMalade = v!),
                      ),
                    ),
                    WidthSpace(10),
                    Text(
                      "Maladie chronique déclarée",
                      style: AppStyles.black18w500.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: EdgeInsets.only(bottom: 20.h),
      actions: [
        Center(
          child: BlocConsumer<UpdateEtudiantCubit, EtudintupdateState>(
            listener: (context, state) {
              if (state is EtudiantUpdateSuccess) {
                Navigator.pop(context);
                context.read<EtudiantCubit>().loadEtudiants();
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: state.message,
                  type: AnimatedSnackBarType.success,
                );
              }

              if (state is EtudintupdateError) {
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
                    final data = {
                      "nom": _nomCtrl.text.trim(),
                      "prenom": _prenomCtrl.text.trim(),
                      "email": _emailCtrl.text.trim(),
                      "dateNaissance": _displayToIso8601(_dateCtrl.text.trim()),
                      "niveau": _niveauCtrl.text.trim(),
                      "specialite": _specialiteCtrl.text.trim(),
                      "groupe": int.tryParse(_groupeCtrl.text.trim()),
                      "matricule": _matriculeCtrl.text.trim(),
                      "willayaNaiss": _wilayaCtrl.text.trim(),
                      "maladeCr": _isMalade,
                    };

                    context.read<UpdateEtudiantCubit>().modifyEtudiant(
                      widget.model.authId!,
                      data,
                    );
                  }
                },
                isloading: state is EtudintupdateLoading,
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
          validator: isDate ? _validateDate : null,
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
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(color: AppColors.blackColor, width: 1.w),
            ),
          ),
        ),
      ],
    );
  }
}
