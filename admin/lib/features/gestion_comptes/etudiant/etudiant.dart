import 'dart:async';
import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/add_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/archive_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/delete_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/archive_etudiant_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/delete_etudiant_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/liste_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/liste_etudiant_state.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/update_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/widget/add_etudiant.dart';
import 'package:admin/features/gestion_comptes/etudiant/models/etudiant_model.dart';
import 'package:admin/features/gestion_comptes/etudiant/widget/modify_etudiant.dart';
import 'package:admin/features/gestion_comptes/etudiant/widget/boxes.dart';
import 'package:admin/features/gestion_comptes/etudiant/widget/student_table.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/import_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/import_etudiant_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Etudiant extends StatefulWidget {
  final VoidCallback? onArchiveTap;
  const Etudiant({super.key, required this.onArchiveTap});

  @override
  State<Etudiant> createState() => _EtudiantState();
}

class _EtudiantState extends State<Etudiant> {
  final TextEditingController _controller = TextEditingController();

  // Debounce timer — prevents spamming the search API on every keystroke
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<EtudiantCubit>().loadEtudiants();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onImporterEtudiants() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;
    if (!context.mounted) return;

    context.read<ImportEtudiantCubit>().importEtudiants(
      fileName: file.name,
      fileBytes: file.bytes!,
    );
  }

  // ─── Confirmation dialog ──────────────────────────────────────────────────

  Future<bool> _confirm({
    required String title,
    required String message,
    required Color confirmColor,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          title,
          style: AppStyles.black25w500.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        content: Text(
          message,
          style: AppStyles.grey20w500.copyWith(
            color: const Color(0xFF828282),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Annuler',
              style: AppStyles.grey20w500.copyWith(
                color: const Color(0xFF828282),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            ),
            child: Text(
              confirmLabel,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ─── Delete ───────────────────────────────────────────────────────────────

  Future<void> _onSupprimer(EtudiantModel model) async {
    final confirmed = await _confirm(
      title: 'Supprimer l\'étudiant',
      message:
          'Êtes-vous sûr de vouloir supprimer ${model.fullName} ?\nCette action est irréversible.',
      confirmColor: const Color(0xFFE15252),
      confirmLabel: 'Supprimer',
    );
    if (!confirmed) return;

    context.read<EtudiantCubit>().removeLocally(model.authId!);
    await context.read<DeleteEtudiantCubit>().deleteEtudiant(model.authId!);

    final deleteState = context.read<DeleteEtudiantCubit>().state;
    if (deleteState is DeleteEtudiantError) {
      context.read<EtudiantCubit>().rollback(model);
      ShowSnackBar.showAnimatedSnackDialog(
        context: context,
        message: deleteState.message,
        type: AnimatedSnackBarType.error,
      );
    } else {
      ShowSnackBar.showAnimatedSnackDialog(
        context: context,
        message: '${model.fullName} a été supprimé.',
        type: AnimatedSnackBarType.success,
      );
    }
  }

  // ─── Archive ──────────────────────────────────────────────────────────────

  Future<void> _onArchiver(EtudiantModel model) async {
    final confirmed = await _confirm(
      title: 'Archiver l\'étudiant',
      message: 'Êtes-vous sûr de vouloir archiver ${model.fullName} ?',
      confirmColor: const Color(0xFF1565D8),
      confirmLabel: 'Archiver',
    );
    if (!confirmed) return;

    context.read<EtudiantCubit>().removeLocally(model.authId!);
    await context.read<ArchiveEtudiantCubit>().archiveEtudiant(model.authId!);

    final archiveState = context.read<ArchiveEtudiantCubit>().state;
    if (archiveState is ArchiveEtudiantError) {
      context.read<EtudiantCubit>().rollback(model);
      ShowSnackBar.showAnimatedSnackDialog(
        context: context,
        message: archiveState.message,
        type: AnimatedSnackBarType.error,
      );
    } else {
      ShowSnackBar.showAnimatedSnackDialog(
        context: context,
        message: '${model.fullName} a été archivé.',
        type: AnimatedSnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImportEtudiantCubit, ImportEtudiantState>(
      listener: (context, state) {
        if (state is ImportEtudiantSuccess) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.result.message,
            type: AnimatedSnackBarType.success,
          );
          // Recharger la table avec les nouveaux étudiants importés
          context.read<EtudiantCubit>().loadEtudiants();
        } else if (state is ImportEtudiantError) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.message,
            type: AnimatedSnackBarType.error,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          toolbarHeight: 125.h,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleSpacing: 20.w,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Etudiant",
                    style: AppStyles.white24w700.copyWith(
                      color: const Color(0xFF0969BB),
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  HeightSpace(8),
                  Text(
                    DateFormat(
                      '    EEEE d MMMM yyyy',
                      'fr_FR',
                    ).format(DateTime.now()),
                    style: AppStyles.white20w700.copyWith(
                      color: const Color(0xFF828282),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              SizedBox(
                width: 250.w,
                child: TextFormField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    context.read<EtudiantCubit>().search(value);
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<EtudiantCubit>().search('');
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Rechercher...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF454545),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 16.w,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFE4EEFA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(51.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeightSpace(33),
              SizedBox(
                height: 70.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    WidthSpace(30),

                    // ✅ Passes both AddEtudiantCubit + EtudiantCubit into the dialog
                    CreateAccountButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (innerContext) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<AddEtudiantCubit>(),
                              ),
                              BlocProvider.value(
                                value: context.read<EtudiantCubit>(),
                              ),
                            ],
                            child: AddEtudiantDialog(),
                          ),
                        );
                      },
                      text: "Créer un compte",
                      icon: Icons.add,
                    ),

                    SizedBox(width: 10.w),
                    BlocBuilder<ImportEtudiantCubit, ImportEtudiantState>(
                      builder: (context, state) {
                        final isLoading = state is ImportEtudiantLoading;
                        return SizedBox(
                          height: 70.h,
                          child: CreateAccountButton(
                            onPressed: _onImporterEtudiants,
                            text: "Importer fichier Excel",
                            icon: Icons.cloud_upload_outlined,
                            isLoading: isLoading,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10.w),
                    CreateAccountButton(
                      onPressed: () {
                        if (widget.onArchiveTap != null) {
                          widget.onArchiveTap!();
                        }
                      },
                      text: "Etudiant Archiver",
                      icon: Icons.person_outline,
                    ),
                  ],
                ),
              ),
              HeightSpace(30),
              BlocBuilder<EtudiantCubit, EtudiantState>(
                builder: (context, state) {
                  // ── Loading ──────────────────────────────────────────────
                  if (state is EtudiantLoading) {
                    return const _TableShimmer();
                  }

                  // ── Error ────────────────────────────────────────────────
                  if (state is EtudiantError) {
                    return _ErrorState(
                      message: state.message,
                      onRetry: () =>
                          context.read<EtudiantCubit>().loadEtudiants(),
                    );
                  }

                  // ── Loaded ───────────────────────────────────────────────
                  if (state is EtudiantLoaded) {
                    if (state.filtered.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            HeightSpace(300),
                            Text(
                              "Aucune liste d'étudiants pour le moment.",
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

                    final models = state.filtered;

                    return StudentsTable(
                      students: List.generate(
                        models.length,
                        (i) => _toStudent(models[i]),
                      ),

                      onSupprimer: (student) async {
                        final index = models.indexWhere(
                          (m) => m.email == student.email,
                        );
                        if (index == -1) return;
                        await _onSupprimer(models[index]);
                      },

                      // ✅ Passes both UpdateEtudiantCubit + EtudiantCubit into the dialog
                      onModifier: (student) {
                        final model = models.firstWhere(
                          (m) => m.email == student.email,
                        );
                        showDialog(
                          context: context,
                          builder: (innerContext) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<UpdateEtudiantCubit>(),
                              ),
                              BlocProvider.value(
                                value: context.read<EtudiantCubit>(),
                              ),
                            ],
                            child: ModifierEtudiantDialog(model: model),
                          ),
                        );
                      },

                      onArchiver: (student) async {
                        final index = models.indexWhere(
                          (m) => m.email == student.email,
                        );
                        if (index == -1) return;
                        await _onArchiver(models[index]);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Mapper ───────────────────────────────────────────────────────────────

  Student _toStudent(EtudiantModel e) => Student(
    issick: e.maladieCr,
    nom: e.nom,
    prenom: e.prenom,
    email: e.email,
    niveau: e.niveau,
    specialite: e.specialite,
    groupe: 'Groupe ${e.groupe}',
    matricule: e.matricule,
    dateNaissance: e.dateNaissance ?? '',
    lieuNaissance: e.wilaya ?? '',
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// Shimmer loading skeleton
// ═════════════════════════════════════════════════════════════════════════════

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 6,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Alignment> _beginAnim;
  late final Animation<Alignment> _endAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _beginAnim = AlignmentTween(
      begin: const Alignment(-2.0, 0),
      end: const Alignment(1.0, 0),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _endAnim = AlignmentTween(
      begin: const Alignment(-1.0, 0),
      end: const Alignment(2.0, 0),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: _beginAnim.value,
            end: _endAnim.value,
            colors: const [
              Color(0xFFE4EAF4),
              Color(0xFFF4F7FC),
              Color(0xFFE4EAF4),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableShimmer extends StatelessWidget {
  const _TableShimmer();

  static const double _totalWidth = 1500;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.w),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: _totalWidth.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildShimmerHeader(),
              ...List.generate(9, (i) => _ShimmerRow(index: i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
      color: const Color(0xFFE4EEFA),
      child: Row(
        children: [
          _headerCell(width: 120.w),
          _headerCell(width: 120.w),
          _headerCell(width: 220.w),
          _headerCell(width: 100.w),
          _headerCell(width: 150.w),
          _headerCell(width: 100.w),
          _headerCell(width: 130.w),
          _headerCell(width: 150.w),
          _headerCell(width: 150.w),
          _headerCell(width: 220.w),
        ],
      ),
    );
  }

  Widget _headerCell({required double width}) {
    return SizedBox(
      width: width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: _ShimmerBox(width: width * 0.55, height: 18.h),
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  final int index;
  const _ShimmerRow({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120.w,
            child: Row(
              children: [
                _ShimmerBox(width: 68.w, height: 16.h),
                SizedBox(width: 5.w),
                _ShimmerBox(width: 25.w, height: 25.h, borderRadius: 4),
              ],
            ),
          ),
          _rowCell(width: 120.w),
          _rowCell(width: 220.w, textWidth: 160.w),
          _rowCell(width: 100.w),
          _rowCell(width: 150.w),
          _rowCell(width: 100.w),
          _rowCell(width: 130.w),
          _rowCell(width: 150.w),
          _rowCell(width: 150.w),
          SizedBox(
            width: 220.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ShimmerBox(width: 68.w, height: 32.h, borderRadius: 8),
                SizedBox(width: 5.w),
                _ShimmerBox(width: 58.w, height: 32.h, borderRadius: 8),
                SizedBox(width: 5.w),
                _ShimmerBox(width: 62.w, height: 32.h, borderRadius: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowCell({required double width, double? textWidth}) {
    return SizedBox(
      width: width,
      child: _ShimmerBox(width: textWidth ?? width * 0.65, height: 16.h),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Error state
// ═════════════════════════════════════════════════════════════════════════════

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Column(
        children: [
          HeightSpace(100),
          Center(
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
                      backgroundColor: const Color(0xFF0969BB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
