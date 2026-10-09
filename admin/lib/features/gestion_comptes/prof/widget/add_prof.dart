import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/core/widgets/Bottons.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/add_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/add_prof_state.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/liste_prof_cubit.dart';
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

class AddProfDialog extends StatefulWidget {
  const AddProfDialog({super.key});

  @override
  State<AddProfDialog> createState() => _AddProfDialogState();
}

class _AddProfDialogState extends State<AddProfDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomCtrl = TextEditingController();
  final TextEditingController _motdepasse = TextEditingController();
  final TextEditingController _prenomCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _wilayaCtrl = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _modules = TextEditingController();

  @override
  void dispose() {
    _nomCtrl.dispose();
    _motdepasse.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _dateCtrl.dispose();
    _description.dispose();
    _wilayaCtrl.dispose();
    _modules.dispose();
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
                    Expanded(child: _buildField("Nom", _nomCtrl, "")),
                    WidthSpace(20),
                    Expanded(child: _buildField("Prénom", _prenomCtrl, "")),
                  ],
                ),
                HeightSpace(18),

                Row(
                  children: [
                    Expanded(child: _buildField("Email", _emailCtrl, "")),
                    WidthSpace(20),
                    Expanded(
                      child: _buildField("Mot de passe", _motdepasse, ""),
                    ),
                  ],
                ),
                HeightSpace(18),

                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        "Date de naissance",
                        _dateCtrl,
                        "",
                        isDate: true,
                      ),
                    ),
                    WidthSpace(20),
                    Expanded(
                      child: _buildField(
                        "Wilaya de naissance",
                        _wilayaCtrl,
                        "",
                      ),
                    ),
                  ],
                ),
                HeightSpace(18),

                Row(
                  children: [
                    Expanded(
                      child: _buildField("Type de poste", _description, ""),
                    ),
                    WidthSpace(20),
                    Expanded(
                      child: _buildField(
                        "Modules",
                        _modules,
                        "Module1,Module2,Module3...",
                      ),
                    ),
                  ],
                ),
                HeightSpace(18),
              ],
            ),
          ),
        ),
      ),

      actionsPadding: EdgeInsets.only(bottom: 20.h),
      actions: [
        Center(
          child: BlocConsumer<AddProfCubit, AddProfState>(
            listener: (context, state) {
              if (state is AddProfSuccess) {
                Navigator.pop(context);
                context.read<ProfCubit>().loadProfs();
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: state.message,
                  type: AnimatedSnackBarType.success,
                );
              }

              if (state is AddProfError) {
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
                    final List<String> modulesList = _modules.text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    final data = {
                      "nom": _nomCtrl.text.trim(),
                      "prenom": _prenomCtrl.text.trim(),
                      "email": _emailCtrl.text.trim(),
                      "password": _motdepasse.text.trim(),
                      "dateNaissance": _displayToIso8601(_dateCtrl.text.trim()),
                      "willayaNaiss": _wilayaCtrl.text.trim(),
                      "description": _description.text.trim(),
                      "modules": modulesList,
                    };
                    context.read<AddProfCubit>().addProf(data);
                  }
                },
                isloading: state is AddProfLoading,
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
    TextEditingController ctrl,
    String hint, {
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
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
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

            return null;
          },
          decoration: InputDecoration(
            hintText: isDate ? 'dd-mm-yyyy' : hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
            isDense: true,
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
