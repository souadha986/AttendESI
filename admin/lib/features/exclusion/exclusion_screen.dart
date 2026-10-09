import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/exclusion/cubit/action_exclusion_cubit.dart';
import 'package:admin/features/exclusion/cubit/exclusion_cubit.dart';
import 'package:admin/features/exclusion/cubit/exclusion_state.dart';
import 'package:admin/features/exclusion/cubit/seuil_cubit.dart';
import 'package:admin/features/exclusion/cubit/seuil_state.dart';
import 'package:admin/features/exclusion/model/exclusion_table_model.dart';
import 'package:admin/features/exclusion/repo/exclusion_repo.dart';
import 'package:admin/features/exclusion/widget/examiner_dossie_dialog.dart';
import 'package:admin/features/exclusion/widget/exclusion_table.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ExclusionScreen extends StatefulWidget {
  const ExclusionScreen({super.key});

  @override
  State<ExclusionScreen> createState() => _ExclusionScreenState();
}

class _ExclusionScreenState extends State<ExclusionScreen> {
  final TextEditingController _controller = TextEditingController();

  int _seuil = 5;
  bool _countAll = true;
  bool _countUnjustified = true;

  @override
  void initState() {
    super.initState();
    context.read<ExclusionCubit>().loadAlerteList();
    context.read<SeuilCubit>().loadSeuil();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ExclusionStatut _parseStatut(String? statut) {
    switch ((statut ?? '').toLowerCase().trim()) {
      case 'exclu':
      case 'exclus':
      case 'excluded':
        return ExclusionStatut.exclu;
      case 'dérogation':
      case 'derogation':
      case 'dérogatoire':
        return ExclusionStatut.derogation;
      default:
        return ExclusionStatut.enAttente;
    }
  }

  ExclusionEntry _toEntry(EtudiantEnAlerteModel m) {
    return ExclusionEntry(
      nom: m.nom ?? '',
      prenom: m.prenom ?? '',
      niveau: m.niveau ?? '',
      specialite: m.specialite ?? '-',
      groupe: 'Groupe ${m.groupe ?? ''}',
      module: m.module ?? '',
      enseignant: m.enseignant ?? '',
      nombreAbsences: m.nbAbsences ?? 0,
      statut: _parseStatut(m.statut), // ← ici
      authId: m.authId ?? '',
      matiereId: m.matiereId?.toString() ?? '',
      issick: m.maladeCr ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Gestion des exclusions",
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
                  context.read<ExclusionCubit>().search(value);
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    context.read<ExclusionCubit>().search('');
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
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer<SeuilCubit, SeuilState>(
              listener: (context, state) {
                if (state is SeuilLoaded) {
                  setState(() {
                    _seuil = state.seuil.seuil;
                    _countAll = state.seuil.methodeCalcule;
                    _countUnjustified = !state.seuil.methodeCalcule;
                  });
                }
                if (state is SeuilSaved) {
                  setState(() {
                    _seuil = state.updated.seuil;
                    _countAll = state.updated.methodeCalcule;
                    _countUnjustified = !state.updated.methodeCalcule;
                  });
                  ShowSnackBar.showAnimatedSnackDialog(
                    context: context,
                    message: state.message,
                    type: AnimatedSnackBarType.success,
                  );
                }
                if (state is SeuilSaveError) {
                  ShowSnackBar.showAnimatedSnackDialog(
                    context: context,
                    message: state.message,
                    type: AnimatedSnackBarType.error,
                  );
                }
              },
              builder: (context, state) {
                if (state is SeuilLoading) {
                  return _SeuilShimmer();
                }

                if (state is SeuilError) {
                  return _ErrorState(
                    message: state.message,
                    onRetry: () => context.read<SeuilCubit>().loadSeuil(),
                  );
                }

                final isSaving = state is SeuilSaving;

                return Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: Container(
                    width: 900.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 30.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Configuration du seuil d'exclusion:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        HeightSpace(16),
                        Row(
                          children: [
                            WidthSpace(50),
                            Text(
                              "Seuil max d'absences par module",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            WidthSpace(300),
                            Container(
                              height: 70.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black87,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Row(
                                children: [
                                  _CounterButton(
                                    icon: Icons.add,
                                    onTap: isSaving
                                        ? () {}
                                        : () => setState(() => _seuil++),
                                  ),
                                  SizedBox(
                                    width: 40.w,
                                    child: Center(
                                      child: Text(
                                        '$_seuil',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  _CounterButton(
                                    icon: Icons.remove,
                                    onTap: isSaving
                                        ? () {}
                                        : () {
                                            if (_seuil > 0)
                                              setState(() => _seuil--);
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        HeightSpace(20),
                        IgnorePointer(
                          ignoring: isSaving,
                          child: _ToggleRow(
                            label:
                                "Compter absences justifiées + non justifiées",
                            value: _countAll,
                            onChanged: (v) => setState(() {
                              _countAll = v;
                              _countUnjustified = !v;
                            }),
                          ),
                        ),
                        HeightSpace(10),
                        IgnorePointer(
                          ignoring: isSaving,
                          child: _ToggleRow(
                            label: "Compter absences non justifiées",
                            value: _countUnjustified,
                            onChanged: (v) => setState(() {
                              _countUnjustified = v;
                              _countAll = !v;
                            }),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            WidthSpace(610),
                            ElevatedButton(
                              onPressed: isSaving
                                  ? null
                                  : () => context.read<SeuilCubit>().saveSeuil(
                                      seuil: _seuil,
                                      methode: _countAll,
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0969BB),
                                foregroundColor: Colors.white,
                                fixedSize: Size(130.w, 42.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: isSaving
                                  ? SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text("Enregistrer"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            HeightSpace(30),

            BlocBuilder<ExclusionCubit, ExclusionState>(
              builder: (context, state) {
                if (state is ExclusionLoading || state is ExclusionSearching) {
                  return _TableShimmer();
                }

                if (state is ExclusionError) {
                  return _ErrorState(
                    message: state.message,
                    onRetry: () =>
                        context.read<ExclusionCubit>().loadAlerteList(),
                  );
                }

                if (state is ExclusionSearchError) {
                  return _ErrorState(
                    message: state.message,
                    onRetry: () {
                      context.read<ExclusionCubit>().search(_controller.text);
                    },
                  );
                }

                if (state is ExclusionSearchLoaded) {
                  if (state.results.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          HeightSpace(300),
                          Text(
                            "Aucun résultat pour cette recherche.",
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
                  return ExclusionTable(
                    entries: state.results.map(_toEntry).toList(),
                    onExaminer: (entry) async {
                      await showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.35),
                        builder: (innerContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<ExclusionCubit>(),
                            ),
                            BlocProvider(
                              create: (_) => ActionExclusionCubit(
                                context.read<ExclusionRepo>(),
                              ),
                            ),
                          ],
                          child: ExaminerDossierDialog(entry: entry),
                        ),
                      );
                      if (context.mounted) {
                        final cubit = context.read<ExclusionCubit>();
                        if (cubit.state is DossierLoaded ||
                            cubit.state is DossierError) {
                          cubit.backToList();
                        }
                      }
                    },
                  );
                }

                if (state is ExclusionLoaded) {
                  if (state.filtered.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          HeightSpace(300),
                          Text(
                            "Aucun étudiant en alerte pour le moment.",
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
                  return ExclusionTable(
                    entries: state.filtered.map(_toEntry).toList(),
                    onExaminer: (entry) async {
                      await showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.35),
                        builder: (innerContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<ExclusionCubit>(),
                            ),
                            BlocProvider(
                              create: (_) => ActionExclusionCubit(
                                context.read<ExclusionRepo>(),
                              ),
                            ),
                          ],
                          child: ExaminerDossierDialog(entry: entry),
                        ),
                      );
                      if (context.mounted) {
                        final cubit = context.read<ExclusionCubit>();
                        if (cubit.state is DossierLoaded ||
                            cubit.state is DossierError) {
                          cubit.backToList();
                        }
                      }
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
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Icon(icon, size: 18.sp),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.6,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF0969BB),
            inactiveThumbColor: const Color(0xFF0969BB),
            inactiveTrackColor: Colors.white,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
                SizedBox(width: 15.w),
                _ShimmerBox(width: 80.w, height: 32.h, borderRadius: 8),
                SizedBox(width: 5.w),
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

class _SeuilShimmer extends StatelessWidget {
  const _SeuilShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.w),
      child: Container(
        width: 900.w,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBox(width: 300.w, height: 20.h),

            HeightSpace(24),

            Row(
              children: [
                WidthSpace(50),
                _ShimmerBox(width: 230.w, height: 16.h),
                WidthSpace(300),
                _ShimmerBox(width: 120.w, height: 46.h, borderRadius: 50),
              ],
            ),

            HeightSpace(28),

            Row(
              children: [
                _ShimmerBox(width: 38.w, height: 22.h, borderRadius: 11),
                SizedBox(width: 16.w),
                _ShimmerBox(width: 340.w, height: 16.h),
              ],
            ),

            HeightSpace(18),

            Row(
              children: [
                _ShimmerBox(width: 38.w, height: 22.h, borderRadius: 11),
                SizedBox(width: 16.w),
                _ShimmerBox(width: 240.w, height: 16.h),
              ],
            ),

            HeightSpace(22),

            Row(
              children: [
                WidthSpace(610),
                _ShimmerBox(width: 130.w, height: 42.h, borderRadius: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
