import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/features/exclusion/cubit/action_exclusion_cubit.dart';
import 'package:admin/features/exclusion/cubit/action_exclusion_state.dart';
import 'package:admin/features/exclusion/cubit/exclusion_cubit.dart';
import 'package:admin/features/exclusion/cubit/exclusion_state.dart';
import 'package:admin/features/exclusion/model/detail_model.dart';
import 'package:admin/features/exclusion/widget/exclusion_table.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExaminerDossierDialog extends StatefulWidget {
  final ExclusionEntry entry;

  const ExaminerDossierDialog({super.key, required this.entry});

  @override
  State<ExaminerDossierDialog> createState() => _ExaminerDossierDialogState();
}

class _ExaminerDossierDialogState extends State<ExaminerDossierDialog> {
  @override
  void initState() {
    super.initState();
    context.read<ExclusionCubit>().loadDossier(
      authId: widget.entry.authId,
      matiereId: widget.entry.matiereId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 60.h),
      child: Container(
        width: 700.w,
        height: 800.h,
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: Colors.black, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: BlocBuilder<ExclusionCubit, ExclusionState>(
          builder: (context, state) {
            if (state is DossierLoading) return const _DossierShimmer();
            if (state is DossierError) {
              return _DossierErrorState(
                message: state.message,
                onRetry: () => context.read<ExclusionCubit>().loadDossier(
                  authId: widget.entry.authId,
                  matiereId: widget.entry.matiereId,
                ),
              );
            }
            if (state is DossierLoaded) {
              return _DossierContent(
                entry: widget.entry,
                dossier: state.dossier,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _DossierContent extends StatelessWidget {
  final ExclusionEntry entry;
  final DetailModel dossier;

  const _DossierContent({required this.entry, required this.dossier});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionExclusionCubit, ActionExclusionState>(
     // Dans le BlocListener de _DossierContent
listener: (context, state) {
  if (state is PrononcerExclusionSuccess) {
    context.read<ExclusionCubit>().updateStatutLocal(
      authId: state.decision.studentAuthId,
      matiereId: state.decision.matiereId,
      newStatut: state.decision.status,
    );
    ShowSnackBar.showAnimatedSnackDialog(
      context: context,
      message: 'Exclusion prononcée avec succès.',
      type: AnimatedSnackBarType.success,
    );
    Navigator.of(context).pop();
  } else if (state is PrononcerExclusionError) {
    ShowSnackBar.showAnimatedSnackDialog(
      context: context,
      message: state.message,
      type: AnimatedSnackBarType.error,
    );
  } else if (state is AccorderDerogationSuccess) {
    context.read<ExclusionCubit>().updateStatutLocal(
      authId: state.decision.studentAuthId,
      matiereId: state.decision.matiereId,
      newStatut: state.decision.status,
    );
    ShowSnackBar.showAnimatedSnackDialog(
      context: context,
      message: 'Dérogation accordée.',
      type: AnimatedSnackBarType.success,
    );
    Navigator.of(context).pop();
  } else if (state is AccorderDerogationError) {
    ShowSnackBar.showAnimatedSnackDialog(
      context: context,
      message: state.message,
      type: AnimatedSnackBarType.error,
    );
  }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dossier - ${dossier.nomComplet ?? '${entry.nom} ${entry.prenom}'}',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close, size: 22.sp, color: Colors.black87),
              ),
            ],
          ),

          SizedBox(height: 50.h),

          // ── Labels row ───────────────────────────────────────────────
          Row(
            children: [
              _labelCell('Module', width: 220.w),
              SizedBox(width: 16.w),
              _labelCell('Absences justifiées', width: 180.w),
              SizedBox(width: 16.w),
              _labelCell('Absences non justifiées', width: 180.w),
            ],
          ),

          SizedBox(height: 12.h),

          // ── Data row ─────────────────────────────────────────────────
          Row(
            children: [
              _DataBox(text: dossier.module ?? '-', width: 220.w, isBold: true),
              SizedBox(width: 16.w),
              _DataBox(text: '${dossier.absJustifiee ?? 0}', width: 180.w),
              SizedBox(width: 16.w),
              _DataBox(text: '${dossier.absNonJustifiee ?? 0}', width: 180.w),
            ],
          ),

          SizedBox(height: 28.h),

          // ── Historique ───────────────────────────────────────────────
          Text(
            'Historique des absences',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 12.h),

          Container(
            width: 530.w,
            height: 230.h,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD0D5DD), width: 1.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: dossier.historique == null || dossier.historique!.isEmpty
                ? Center(
                    child: Text(
                      'Aucune absence enregistrée',
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    itemCount: dossier.historique!.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (_, i) {
                      final h = dossier.historique![i];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          children: [
                            SizedBox(width: 10.w),
                            Text(
                              h.date ?? '',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Text(
                              (h.intervalleHeure ?? '').replaceAll('\n', ' '),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[800],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: h.isJustified == true
                                    ? const Color(0xFFE8F5E9)
                                    : const Color(0xFFFFEBEE),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                h.isJustified == true
                                    ? 'Justifiée'
                                    : 'Non justifiée',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: h.isJustified == true
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFC62828),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          SizedBox(height: 30.h),

          // ── Maladie chronique ────────────────────────────────────────
          if (dossier.maladeCr == true)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              margin: EdgeInsets.only(bottom: 16.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_outlined, color: Colors.black),
                  SizedBox(width: 8.w),
                  Text(
                    'Maladie chronique enregistrée pour cet étudiant',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.black),
                SizedBox(width: 8.w),
                Text(
                  'Pas de maladie chronique enregistrée pour cet étudiant',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

          SizedBox(height: 50.h),

          // ── Action buttons ───────────────────────────────────────────
          BlocBuilder<ActionExclusionCubit, ActionExclusionState>(
            builder: (context, actionState) {
              final isExcluLoading = actionState is PrononcerExclusionLoading;
              final isDeroLoading = actionState is AccorderDerogationLoading;
              // Bloquer les deux boutons si l'un est en cours
              final isBusy = isExcluLoading || isDeroLoading;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ActionButton(
                    label: "Prononcer l'exclusion",
                    backgroundColor: const Color(0xFFE53935),
                    isLoading: isExcluLoading,
                    isDisabled: isBusy,
                    onTap: () {
                      context.read<ActionExclusionCubit>().prononcerExclusion(
                        studentAuthId: entry.authId,
                        matiereId: int.parse(entry.matiereId),
                      );
                    },
                  ),
                  SizedBox(width: 24.w),
                  _ActionButton(
                    label: 'Accorder une dérogation',
                    backgroundColor: const Color(0xFF1E88E5),
                    isLoading: isDeroLoading,
                    isDisabled: isBusy,
                    onTap: () {
                      context.read<ActionExclusionCubit>().accorderDerogation(
                        studentAuthId: entry.authId,
                        matiereId: int.parse(entry.matiereId),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _labelCell(String text, {required double width}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _DataBox extends StatelessWidget {
  final String text;
  final double width;
  final bool isBold;

  const _DataBox({
    required this.text,
    required this.width,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD0D5DD), width: 1.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isDisabled;

  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isDisabled
        ? backgroundColor.withOpacity(0.55)
        : backgroundColor;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: effectiveColor,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// ── Shimmer, ErrorState  ──────────────────────────────────────────

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

class _DossierShimmer extends StatelessWidget {
  const _DossierShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header shimmer ────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ShimmerBox(width: 260.w, height: 22.h, borderRadius: 8),
            _ShimmerBox(width: 22.w, height: 22.h, borderRadius: 6),
          ],
        ),

        SizedBox(height: 50.h),

        // ── Labels row shimmer ────────────────────────────────────────
        Row(
          children: [
            _ShimmerBox(width: 80.w, height: 14.h),
            SizedBox(width: 16.w + (220 - 80).w),
            _ShimmerBox(width: 130.w, height: 14.h),
            SizedBox(width: 16.w + (180 - 130).w),
            _ShimmerBox(width: 150.w, height: 14.h),
          ],
        ),

        SizedBox(height: 12.h),

        // ── Data boxes shimmer ────────────────────────────────────────
        Row(
          children: [
            _shimmerBox(width: 220.w),
            SizedBox(width: 16.w),
            _shimmerBox(width: 180.w),
            SizedBox(width: 16.w),
            _shimmerBox(width: 180.w),
          ],
        ),

        SizedBox(height: 28.h),

        // ── Historique title shimmer ──────────────────────────────────
        _ShimmerBox(width: 180.w, height: 15.h),

        SizedBox(height: 12.h),

        // ── Historique container shimmer ──────────────────────────────
        Container(
          width: 530.w,
          height: 250.h,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD0D5DD), width: 1.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            children: List.generate(
              5,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  children: [
                    _ShimmerBox(width: 16.w, height: 16.h, borderRadius: 8),
                    SizedBox(width: 10.w),
                    _ShimmerBox(width: 80.w, height: 13.h),
                    SizedBox(width: 20.w),
                    _ShimmerBox(width: 100.w, height: 13.h),
                    const Spacer(),
                    _ShimmerBox(width: 90.w, height: 24.h, borderRadius: 20),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 30.h),

        // ── Maladie chronique shimmer ─────────────────────────────────
        _ShimmerBox(width: 340.w, height: 14.h),

        SizedBox(height: 50.h),

        // ── Buttons shimmer ───────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ShimmerBox(width: 180.w, height: 52.h, borderRadius: 50),
            SizedBox(width: 24.w),
            _ShimmerBox(width: 190.w, height: 52.h, borderRadius: 50),
          ],
        ),
      ],
    );
  }

  Widget _shimmerBox({required double width}) {
    return _ShimmerBox(width: width, height: 56.h, borderRadius: 12);
  }
}

// ── Error state  ──────────────────────────────

class _DossierErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DossierErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
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
              style: TextStyle(
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
    );
  }
}
