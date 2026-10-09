import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/core/widgets/spacing.dart';

import 'package:admin/features/gestion_comptes/prof/cubit/cubit/archive_prof_liste_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/archive_prof_liste_state.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/desarchive_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/desarchive_prof_state.dart';
import 'package:admin/features/gestion_comptes/prof/models/prof_model.dart';
import 'package:admin/features/gestion_comptes/prof/widget/archeive_prof_table.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ArcheiveProf extends StatefulWidget {
  final VoidCallback? onBack;
  const ArcheiveProf({super.key, this.onBack});

  @override
  State<ArcheiveProf> createState() => _ArcheiveProfState();
}

class _ArcheiveProfState extends State<ArcheiveProf> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();

    context.read<ArcheiveProfliste>().loadProfs();
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

  Future<void> _ondesarchiver(ProfModel model) async {
    final confirmed = await _confirm(
      title: 'Desarchiver l\'enseignant',
      message: 'Êtes-vous sûr de vouloir desarchiver ${model.fullname} ?',
      confirmColor: const Color(0xFF1565D8),
      confirmLabel: 'Desarchiver',
    );
    if (!confirmed) return;

    context.read<ArcheiveProfliste>().removeLocally(model.authId);
    await context.read<DesarchiveProfCubit>().desarcheuveProf(model.authId);

    final archiveState = context.read<DesarchiveProfCubit>().state;
    if (archiveState is desarcheiveProfError) {
      context.read<ArcheiveProfliste>().rollback(model);
      ShowSnackBar.showAnimatedSnackDialog(
        context: context,
        message: archiveState.message,
        type: AnimatedSnackBarType.error,
      );
    } else {
      ShowSnackBar.showAnimatedSnackDialog(
        context: context,
        message: '${model.fullname} a été desarchivé.',
        type: AnimatedSnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        toolbarHeight: 125.h,
        elevation: 0,
        centerTitle: false,
        titleSpacing:
            0, // Changed to 0 to give the back button room at the edge
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w), // Move padding here
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center button and text vertically
            children: [
              // --- THE BACK BUTTON ---
              InkWell(
                onTap: () => widget.onBack?.call(),
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF0969BB,
                    ).withOpacity(0.1), // Subtle background
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new, // Use "new" for a cleaner look
                    color: const Color(0xFF0969BB),
                    size: 18.sp,
                  ),
                ),
              ),

              WidthSpace(15), // Gap after the button
              // --- TITLE AND DATE ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Archive Enseignant",
                    style: AppStyles.white24w700.copyWith(
                      color: const Color(0xFF0969BB),
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  HeightSpace(4),
                  Text(
                    DateFormat(
                      'EEEE d MMMM yyyy',
                      'fr_FR',
                    ).format(DateTime.now()),
                    style: AppStyles.white20w700.copyWith(
                      color: const Color(0xFF828282),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // --- SEARCH FIELD ---
              SizedBox(
                width: 250.w,
                child: TextFormField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    context.read<ArcheiveProfliste>().search(value);
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<ArcheiveProfliste>().search('');
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
      ),
      body: Column(
        children: [
          HeightSpace(30),
          Expanded(
            child: BlocBuilder<ArcheiveProfliste, ProfArcheive>(
              builder: (context, state) {
                if (state is ProfArcheiveLoading) {
                  return const _TableShimmer();
                }

                if (state is ProfArcheiveError) {
                  return _ErrorState(
                    message: state.message,
                    onRetry: () =>
                        context.read<ArcheiveProfliste>().loadProfs(),
                  );
                }

                if (state is ProfArcheiveLoaded) {
                  if (state.filtered.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          HeightSpace(300),
                          Text(
                            "Aucune liste d'enseignant pour le moment.",
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

                  return ArcheiveProfTable(
                    profs: List.generate(
                      models.length,
                      (i) => _toProf(models[i]),
                    ),
                    ondesarchiver: (student) async {
                      final index = models.indexWhere(
                        (m) => m.email == student.email,
                      );
                      if (index == -1) return;
                      await _ondesarchiver(models[index]);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Prof _toProf(ProfModel p) => Prof(
    nom: p.nom,
    prenom: p.prenom,
    email: p.email,
    role: p.role,
    description: p.description,
    willayaNaiss: p.willayaNaiss,
    dateNaissance: p.dateNaissance,
    modules: p.modules,
  );
}

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
