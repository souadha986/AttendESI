import 'dart:async';
import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/gestion_comptes/etudiant/widget/boxes.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/scolarite_liste_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/scolarite_liste_state.dart';
import 'package:admin/features/gestion_comptes/scolarite/models/scolarite_model.dart';
import 'package:admin/features/gestion_comptes/scolarite/widget/add_scolarite.dart';
import 'package:admin/features/gestion_comptes/scolarite/widget/scolarite_table.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/add_scolarite_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/delete_scolarite_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/delete_scolarite_state.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/update_scolarite_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/widget/update_scolarite.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ScolaritePage extends StatefulWidget {
  const ScolaritePage({super.key});

  @override
  State<ScolaritePage> createState() => _ScolaritePageState();
}

class _ScolaritePageState extends State<ScolaritePage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<ScolariteCubit>().loadScolarites();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

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

  Future<void> _onSupprimer(ScolariteModel model) async {
    final confirmed = await _confirm(
      title: 'Supprimer le scolarite',
      message:
          'Êtes-vous sûr de vouloir supprimer ${model.fullname} ?\nCette action est irréversible.',
      confirmColor: const Color(0xFFE15252),
      confirmLabel: 'Supprimer',
    );
    if (!confirmed) return;

    await context.read<DeleteScolariteCubit>().deleteScolarite(model.authId);

    final deleteState = context.read<DeleteScolariteCubit>().state;
    if (deleteState is DeleteScolariteError) {
      context.read<ScolariteCubit>().rollback(model);
      ShowSnackBar.showAnimatedSnackDialog(
        context: context,
        message: deleteState.message,
        type: AnimatedSnackBarType.error,
      );
    } else {
      context.read<ScolariteCubit>().removeLocally(model.authId);
      ShowSnackBar.showAnimatedSnackDialog(
        context: context,
        message: '${model.fullname} a été supprimé.',
        type: AnimatedSnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        toolbarHeight: 125.h,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20.w,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "S.Scolarite",
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
                  CreateAccountButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (innerContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<AddScolariteCubit>(),
                            ),
                            BlocProvider.value(
                              value: context.read<ScolariteCubit>(),
                            ),
                          ],
                          child: AddScolariteDialog(),
                        ),
                      );
                    },
                    text: "Créer un compte",
                    icon: Icons.add,
                  ),
                ],
              ),
            ),
            HeightSpace(30),
            BlocBuilder<ScolariteCubit, ScolariteState>(
              builder: (context, state) {
                if (state is ScolariteLoading) {
                  return const _TableShimmer();
                }

                if (state is ScolariteError) {
                  return _ErrorState(
                    message: state.message,
                    onRetry: () =>
                        context.read<ScolariteCubit>().loadScolarites(),
                  );
                }

                if (state is ScolariteLoaded) {
                  if (state.filtered.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          HeightSpace(300),
                          Text(
                            "Aucune liste de scolarite pour le moment.",
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

                  return ScolaritesTable(
                    Scolarites: List.generate(
                      models.length,
                      (i) => _toScolarite(models[i]),
                    ),
                    onSupprimer: (s) async {
                      final index = models.indexWhere(
                        (m) => m.email == s.email,
                      );
                      if (index == -1) return;
                      await _onSupprimer(models[index]);
                    },
                    onModifier: (s) {
                      final model = models.firstWhere(
                        (m) => m.email == s.email,
                      );
                      showDialog(
                        context: context,
                        builder: (innerContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<UpdateScolariteCubit>(),
                            ),
                            BlocProvider.value(
                              value: context.read<ScolariteCubit>(),
                            ),
                          ],
                          child: ModifierScolariteDialog(model: model),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Scolarite _toScolarite(ScolariteModel p) => Scolarite(
    nom: p.nom,
    prenom: p.prenom,
    email: p.email,
    cycleResponsable: p.cycleResponsable,
  );
}

// ═══════════════════════════════════════════════════════════════════
// Shimmer
// ═══════════════════════════════════════════════════════════════════

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

  static const double _totalWidth = 1050;

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
          _headerCell(width: 150.w),
          _headerCell(width: 150.w),
          _headerCell(width: 220.w),
          _headerCell(width: 260.w),
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
          _rowCell(width: 150.w),
          _rowCell(width: 150.w),
          _rowCell(width: 220.w, textWidth: 160.w),
          _rowCell(width: 250.w),
          SizedBox(
            width: 220.w,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 20.w),
                _ShimmerBox(width: 68.w, height: 32.h, borderRadius: 8),
                SizedBox(width: 30.w),
                _ShimmerBox(width: 58.w, height: 32.h, borderRadius: 8),
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

// ═══════════════════════════════════════════════════════════════════
// Error state
// ═══════════════════════════════════════════════════════════════════

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
