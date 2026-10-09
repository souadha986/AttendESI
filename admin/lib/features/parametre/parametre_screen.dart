import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/gestion_comptes/etudiant/widget/boxes.dart';
import 'package:admin/features/main_screen/widget/custom_app_bar.dart';
import 'package:admin/features/parametre/cubit/change_mdp_cubit.dart';
import 'package:admin/features/parametre/cubit/change_mdp_state.dart';
import 'package:admin/features/parametre/cubit/import_salles_cubit.dart';
import 'package:admin/features/parametre/cubit/import_salles_state.dart';
import 'package:admin/features/parametre/cubit/import_matieres_cubit.dart';
import 'package:admin/features/parametre/cubit/import_matieres_state.dart';
import 'package:admin/features/parametre/cubit/logout_cubit.dart';
import 'package:admin/features/parametre/cubit/logout_state.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ParametreScreen extends StatefulWidget {
  const ParametreScreen({super.key});

  @override
  State<ParametreScreen> createState() => _ParametreScreenState();
}

class _ParametreScreenState extends State<ParametreScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onEnregistrer() {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().updatePassword(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
    }
  }

  void _onDeconnecter() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          "Déconnexion",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          "Voulez-vous vraiment vous déconnecter ?",
          style: GoogleFonts.poppins(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              "Annuler",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<LogoutCubit>().logout();
            },
            child: Text(
              "Déconnecter",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onImporterSalles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;

    if (file.bytes == null) return;

    if (!context.mounted) return;

    context.read<ImportSallesCubit>().importSalles(
      fileName: file.name,
      fileBytes: file.bytes!,
    );
  }

  Future<void> _onImporterMatieres() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) return;

    if (!context.mounted) return;

    context.read<ImportMatieresCubit>().importMatieres(
      fileName: file.name,
      fileBytes: file.bytes!,
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "     $label",
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff454545),
          ),
        ),
        HeightSpace(8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 18.h,
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
                size: 20.sp,
              ),
              onPressed: onToggle,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: const BorderSide(
                color: Color(0xff06A1F1),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ── ChangePassword listener ──
        BlocListener<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccessState) {
              _currentPasswordController.clear();
              _newPasswordController.clear();
              _confirmPasswordController.clear();
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.message,
                type: AnimatedSnackBarType.success,
              );
              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) context.go('/login');
              });
            } else if (state is ChangePasswordErrorState) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.error,
                type: AnimatedSnackBarType.error,
              );
            }
          },
        ),
        // ── Logout listener ──
        BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              context.go('/login');
            } else if (state is LogoutErrorState) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.error,
                type: AnimatedSnackBarType.error,
              );
            }
          },
        ),

        //import listeners
        BlocListener<ImportSallesCubit, ImportSallesState>(
          listener: (context, state) {
            if (state is ImportSallesSuccess) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.result.message,
                type: AnimatedSnackBarType.success,
              );
            } else if (state is ImportSallesError) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            }
          },
        ),
        BlocListener<ImportMatieresCubit, ImportMatieresState>(
          listener: (context, state) {
            if (state is ImportMatieresSuccess) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.result.message,
                type: AnimatedSnackBarType.success,
              );
            } else if (state is ImportMatieresError) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            }
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: CustomAppBar(title: "Paramètres", showProfileSection: false),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
            child: Column(
              children: [
                // ── Boutons import ──
                Center(
                  child: Container(
                    width: 730.w,
                    height: 110.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ── Bouton Salles ──
                        BlocBuilder<ImportSallesCubit, ImportSallesState>(
                          builder: (context, state) {
                            final isLoading = state is ImportSallesLoading;
                            return SizedBox(
                              height: 70.h,
                              width: 310.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F4FF),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: isLoading
                                    ? Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: const Color(0xff06A1F1),
                                            strokeWidth: 2.5,
                                          ),
                                        ),
                                      )
                                    : CreateAccountButton(
                                        onPressed: _onImporterSalles,
                                        text: "Importer fichier des Salles",
                                        icon: Icons.cloud_upload_outlined,
                                      ),
                              ),
                            );
                          },
                        ),

                        // ── Bouton Modules ──
                        BlocBuilder<ImportMatieresCubit, ImportMatieresState>(
                          builder: (context, state) {
                            final isLoading = state is ImportMatieresLoading;
                            return SizedBox(
                              height: 70.h,
                              width: 310.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F4FF),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: isLoading
                                    ? Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: const Color(0xff06A1F1),
                                            strokeWidth: 2.5,
                                          ),
                                        ),
                                      )
                                    : CreateAccountButton(
                                        onPressed: _onImporterMatieres,
                                        text: "Importer fichier des Modules",
                                        icon: Icons.cloud_upload_outlined,
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                HeightSpace(10),

                // ── Changer mot de passe ──
                Container(
                  width: 730.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 100.w,
                      vertical: 30.h,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "changer le mot de passe",
                              style: GoogleFonts.poppins(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff454545),
                              ),
                            ),
                          ),
                          HeightSpace(30),
                          _buildPasswordField(
                            label: "Mot de passe Actuelle",
                            controller: _currentPasswordController,
                            obscure: _obscureCurrent,
                            onToggle: () => setState(
                              () => _obscureCurrent = !_obscureCurrent,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez entrer votre mot de passe actuel";
                              }
                              return null;
                            },
                          ),
                          HeightSpace(20),
                          _buildPasswordField(
                            label: "Nouveau mot de passe",
                            controller: _newPasswordController,
                            obscure: _obscureNew,
                            onToggle: () =>
                                setState(() => _obscureNew = !_obscureNew),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez entrer un nouveau mot de passe";
                              }
                              if (value.length < 8) {
                                return "Le mot de passe doit contenir au moins 8 caractères";
                              }
                              return null;
                            },
                          ),
                          HeightSpace(20),
                          _buildPasswordField(
                            label: "Confirmer mot de passe",
                            controller: _confirmPasswordController,
                            obscure: _obscureConfirm,
                            onToggle: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Veuillez confirmer votre mot de passe";
                              }
                              if (value != _newPasswordController.text) {
                                return "Les mots de passe ne correspondent pas";
                              }
                              return null;
                            },
                          ),
                          HeightSpace(40),
                          BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                            builder: (context, state) {
                              final isLoading =
                                  state is ChangePasswordLoadingState;
                              return Center(
                                child: SizedBox(
                                  width: 250.w,
                                  height: 55.h,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF0F6AFA),
                                          Color(0xFF06A1F1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : _onEnregistrer,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        disabledBackgroundColor:
                                            Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Text(
                                              "Enregistrer",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                HeightSpace(10),

                // ── Bouton Déconnecter ──
                Container(
                  width: 730.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  child: BlocBuilder<LogoutCubit, LogoutState>(
                    builder: (context, state) {
                      final isLoading = state is LogoutLoadingState;
                      return Center(
                        child: SizedBox(
                          width: 250.w,
                          height: 55.h,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              gradient: const LinearGradient(
                                colors: [Colors.red, Color(0xFFF55356)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _onDeconnecter,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      "Déconnecter",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                HeightSpace(30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
