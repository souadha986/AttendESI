import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/core/widgets/Bottons.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/liste_etudiant_cubit.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/add_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/add_etudiant_state.dart';

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

class AddEtudiantDialog extends StatefulWidget {
  const AddEtudiantDialog({super.key});

  @override
  State<AddEtudiantDialog> createState() => _AddEtudiantDialogState();
}

class _AddEtudiantDialogState extends State<AddEtudiantDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomCtrl = TextEditingController();
  final TextEditingController _motdepasse = TextEditingController();
  final TextEditingController _prenomCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _matriculeCtrl = TextEditingController();
  final TextEditingController _wilayaCtrl = TextEditingController();
  final TextEditingController _niveauCtrl = TextEditingController();
  final TextEditingController _groupeCtrl = TextEditingController();
  final TextEditingController _specialiteCtrl = TextEditingController();

  bool _isMalade = false;

  @override
  void dispose() {
    _nomCtrl.dispose();
    _motdepasse.dispose();
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

  /// Converts "dd-MM-yyyy" → "yyyy-MM-ddT00:00:00.000Z" for Prisma.
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Créer un compte",
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
                    Expanded(child: _buildField("Mot de passe", _motdepasse)),
                  ],
                ),
                HeightSpace(18),

                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        "Date de naissance",
                        _dateCtrl,
                        isDate: true,
                      ),
                    ),
                    WidthSpace(20),
                    Expanded(child: _buildField("Matricule", _matriculeCtrl)),
                  ],
                ),
                HeightSpace(18),

                Row(
                  children: [
                    Expanded(
                      child: _buildField("Wilaya de naissance", _wilayaCtrl),
                    ),
                    WidthSpace(20),
                    Expanded(child: _buildField("Niveau", _niveauCtrl)),
                  ],
                ),
                HeightSpace(18),

                Row(
                  children: [
                    Expanded(child: _buildField("Spécialité", _specialiteCtrl)),
                    WidthSpace(20),
                    Expanded(
                      child: _buildField("Groupe", _groupeCtrl, isInt: true),
                    ),
                  ],
                ),

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
                        onChanged: (v) =>
                            setState(() => _isMalade = v ?? false),
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
          child: BlocConsumer<AddEtudiantCubit, AddEtudiantState>(
            listener: (context, state) {
              if (state is AddEtudiantSuccess) {
                Navigator.pop(context);
                context.read<EtudiantCubit>().loadEtudiants();
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: state.message,
                  type: AnimatedSnackBarType.success,
                );
              }

              if (state is AddEtudiantError) {
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
                      "password": _motdepasse.text.trim(),
                      "dateNaissance": _displayToIso8601(_dateCtrl.text.trim()),
                      "niveau": _niveauCtrl.text.trim(),
                      "specialite": _specialiteCtrl.text.trim().isEmpty
                          ? null
                          : _specialiteCtrl.text.trim(),
                      "groupe": int.parse(_groupeCtrl.text.trim()),
                      "matricule": _matriculeCtrl.text.trim(),
                      "willayaNaiss": _wilayaCtrl.text.trim(),
                      "maladeCr": _isMalade,
                    };

                    context.read<AddEtudiantCubit>().addEtudiant(data);
                  }
                },
                isloading: state is AddEtudiantLoading,
                title: "Créer un compte",
                style: AppStyles.white20w700,
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
    bool isInt = false,
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
          keyboardType: isDate || isInt
              ? TextInputType.number
              : TextInputType.text,
          inputFormatters: isDate
              ? [_DateInputFormatter()]
              : isInt
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              if (label == "Spécialité") return null;
              return "Champ obligatoire";
            }

            if (label == "Email") {
              if (!value.endsWith("@esi-sba.dz")) {
                return "Email doit finir par @esi-sba.dz";
              }
            }

            if (label == "Mot de passe") {
              if (value.length < 8) return "Min 8 caractères";
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

            if (label == "Groupe") {
              if (int.tryParse(value.trim()) == null) {
                return "Nombre entier requis";
              }
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
