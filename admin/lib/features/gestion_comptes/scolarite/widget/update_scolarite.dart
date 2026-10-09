import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/core/widgets/Bottons.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/scolarite_liste_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/models/scolarite_model.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/update_scolarite_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/update_scolarite_state.dart';

class ModifierScolariteDialog extends StatefulWidget {
  final ScolariteModel model;
  const ModifierScolariteDialog({super.key, required this.model});

  @override
  State<ModifierScolariteDialog> createState() =>
      _ModifierScolariteDialogState();
}

class _ModifierScolariteDialogState extends State<ModifierScolariteDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomCtrl;
  late TextEditingController _prenomCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _cycleCtrl;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.model.nom);
    _prenomCtrl = TextEditingController(text: widget.model.prenom);
    _emailCtrl = TextEditingController(text: widget.model.email);
    _cycleCtrl = TextEditingController(text: widget.model.cycleResponsable);
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _emailCtrl.dispose();
    _cycleCtrl.dispose();
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
                _buildField("Email", _emailCtrl),
                HeightSpace(18),
                _buildField("Cycle", _cycleCtrl),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: EdgeInsets.only(bottom: 20.h),
      actions: [
        Center(
          child: BlocConsumer<UpdateScolariteCubit, ScolariteupdateState>(
            listener: (context, state) {
              if (state is ScolariteUpdateSuccess) {
                Navigator.pop(context);
                context.read<ScolariteCubit>().loadScolarites();
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: state.message,
                  type: AnimatedSnackBarType.success,
                );
              }
              if (state is ScolariteupdateError) {
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
                      "cycle": _cycleCtrl.text.trim(),
                    };
                    context.read<UpdateScolariteCubit>().modifyScolarite(
                      widget.model.authId,
                      data,
                    );
                  }
                },
                isloading: state is ScolariteupdateLoading,
                title: "Enregistrer",
                style: AppStyles.white20w700.copyWith(fontSize: 15.sp),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController ctrl) {
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
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Champ obligatoire";
            }
            if (label == "Email") {
              if (!value.endsWith("@esi-sba.dz")) {
                return "Email doit finir par @esi-sba.dz";
              }
            }
            return null;
          },
          decoration: InputDecoration(
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
