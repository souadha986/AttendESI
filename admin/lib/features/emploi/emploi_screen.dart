import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/emploi/cubit/emploi_cubit.dart';
import 'package:admin/features/emploi/cubit/emploi_state.dart';
import 'package:admin/features/emploi/models/emploi_model.dart';
import 'package:admin/features/emploi/models/examen_model.dart';
import 'package:admin/features/main_screen/widget/custom_app_bar.dart';
import 'package:admin/features/emploi/cubit/import_emploi_cubit.dart';
import 'package:admin/features/emploi/cubit/import_emploi_state.dart';
import 'package:admin/features/emploi/cubit/import_examen_cubit.dart';
import 'package:admin/features/emploi/cubit/import_examen_state.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseSlot {
  final String subject;
  final String teacher;
  final String room;
  final String? specialite;
  const CourseSlot({
    required this.subject,
    required this.teacher,
    required this.room,
    this.specialite,
  });
}

class TimeRow {
  final String timeRange;
  final Map<String, List<CourseSlot>> daySlots;
  const TimeRow({required this.timeRange, required this.daySlots});
}

class ExamEntry {
  final String date;
  final String salle;
  final String horaire;
  final String matiere;
  final String responsable;
  final String surveillant;
  final String? specialite;

  const ExamEntry({
    required this.date,
    required this.salle,
    required this.horaire,
    required this.matiere,
    required this.responsable,
    required this.surveillant,
    this.specialite,
  });
}

const List<String> kDays = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi'];

String _niveauToApi(String label) {
  switch (label) {
    case '1CPI':
      return '1CPI';
    case '2CPI':
      return '2CPI';
    case '1CS':
      return '1CS';
    case '3CS':
      return '3CS';
    case '2CS':
    default:
      return '2CS';
  }
}

List<TimeRow> _buildTimeRows(Map<String, List<CourseSlotModel>> schedule) {
  // Collect all unique time ranges, preserving insertion order across days
  final orderedTimes = <String>[];
  for (final day in kDays) {
    final slots = schedule[day] ?? [];
    for (final s in slots) {
      if (!orderedTimes.contains(s.heure)) orderedTimes.add(s.heure);
    }
  }
  //  Sort chronologically by parsing the start hour
  orderedTimes.sort((a, b) {
    int _toMinutes(String range) {
      final part = range.split(' - ').first.trim();
      final parts = part.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }

    return _toMinutes(a).compareTo(_toMinutes(b));
  });
  return orderedTimes.map((heure) {
    final daySlots = <String, List<CourseSlot>>{};
    for (final day in kDays) {
      final slots = (schedule[day] ?? [])
          .where((s) => s.heure == heure)
          .map(
            (s) => CourseSlot(
              subject:
                  '${s.type} ${s.matiere}'
                  '${s.groupe.isNotEmpty ? ' G${s.groupe.join('/')}' : ''}',
              teacher: s.professeur,
              room: s.salle,
              specialite: s.specialite,
            ),
          )
          .toList();
      daySlots[day] = slots;
    }
    return TimeRow(timeRange: heure, daySlots: daySlots);
  }).toList();
}

List<ExamEntry> _buildExamEntries(EmploiExamenModel model) {
  final entries = <ExamEntry>[];

  model.examens.forEach((isoDate, exams) {
    final dateLabel = formatDate(isoDate);

    for (final e in exams) {
      entries.add(
        ExamEntry(
          date: dateLabel,
          salle: e.salle,
          horaire: e.horaire,
          matiere: e.specialite.isNotEmpty
              ? '${e.matiere} - ${e.specialite}'
              : e.matiere,
          responsable: e.responsables.join(', '),
          surveillant: e.surveillants.join(', '),
          specialite: e.specialite,
        ),
      );
    }
  });
  return entries;
}

String formatDate(String isoDate) {
  try {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(isoDate);
    if (m != null) {
      final yyyy = int.parse(m.group(1)!);
      final mm = int.parse(m.group(2)!);
      final dd = int.parse(m.group(3)!);

      final dtUtc = DateTime.utc(yyyy, mm, dd);

      const jours = [
        'Lundi',
        'Mardi',
        'Mercredi',
        'Jeudi',
        'Vendredi',
        'Samedi',
        'Dimanche',
      ];

      final jour = jours[dtUtc.weekday - 1];
      return '$jour ${dd.toString().padLeft(2, '0')}/${mm.toString().padLeft(2, '0')}/$yyyy';
    }
    final dt = DateTime.parse(isoDate);
    const jours = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    final jour = jours[dt.weekday - 1];
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');

    return '$jour $dd/$mm/${dt.year}';
  } catch (_) {
    return isoDate;
  }
}

List<ExamEntry> _buildRemplacementEntries(EmploiExamenModel model) {
  final entries = <ExamEntry>[];

  model.examens.forEach((isoDate, exams) {
    final dateLabel = formatDate(isoDate);
    for (final e in exams) {
      entries.add(
        ExamEntry(
          date: dateLabel,
          salle: e.salle,
          horaire: e.horaire,
          matiere: e.specialite.isNotEmpty
              ? '${e.matiere} • ${e.specialite}'
              : e.matiere,
          responsable: e.responsables.join(', '),
          surveillant: e.surveillants.join(', '),
          specialite: e.specialite,
        ),
      );
    }
  });

  return entries;
}

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────

enum EmploiMode { normal, examen, remplacement }

class EmploiScreen extends StatefulWidget {
  const EmploiScreen({super.key});

  @override
  State<EmploiScreen> createState() => _EmploiScreenState();
}

class _EmploiScreenState extends State<EmploiScreen> {
  // ── Variable pour l'expansion du bloc import ──
  bool _importExpanded = false;

  // ── Méthode de sélection fichier emploi
  Future<void> _onImporterEmploi() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;
    if (!context.mounted) return;

    context.read<ImportEmploiCubit>().importEmploi(
      fileName: file.name,
      fileBytes: file.bytes!,
    );
  }

  Future<void> _onImporterExamenEmd() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;
    if (!context.mounted) return;

    context.read<ImportExamenCubit>().importExamenEmd(
      fileName: file.name,
      fileBytes: file.bytes!,
    );
  }

  Future<void> _onImporterExamenRemplacement() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;
    if (!context.mounted) return;

    context.read<ImportExamenCubit>().importExamenRemplacement(
      fileName: file.name,
      fileBytes: file.bytes!,
    );
  }

  String _selectedYear = '2CS';
  EmploiMode _mode = EmploiMode.normal;

  final List<String> _years = ['1CPI', '2CPI', '1CS', '2CS', '3CS'];

  static const _blue = Color(0xFF1565C0);
  static const _rowAlt = Color(0xFFF5F8FF);
  static const _borderColor = Color(0xFFD0DCF0);

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final niveau = _niveauToApi(_selectedYear);
    final cubit = context.read<EmploiCubit>();
    switch (_mode) {
      case EmploiMode.normal:
        cubit.loadNormalSchedule(niveau);
        break;
      case EmploiMode.examen:
        cubit.loadExamens(niveau);
        break;
      case EmploiMode.remplacement:
        cubit.loadRemplacement(niveau);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ── Import Emploi Normal ──
        BlocListener<ImportEmploiCubit, ImportEmploiState>(
          listener: (context, state) {
            if (state is ImportEmploiSuccess) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.result.message,
                type: AnimatedSnackBarType.success,
              );
              _load();
            } else if (state is ImportEmploiError) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            }
          },
        ),
        // ── Import Examen EMD ──
        BlocListener<ImportExamenCubit, ImportExamenState>(
          listener: (context, state) {
            if (state is ImportExamenEmdSuccess) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.result.message,
                type: AnimatedSnackBarType.success,
              );
              _load();
            } else if (state is ImportExamenEmdError) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.message,
                type: AnimatedSnackBarType.error,
              );
            } else if (state is ImportExamenRemplacementSuccess) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.result.message,
                type: AnimatedSnackBarType.success,
              );
              _load();
            } else if (state is ImportExamenRemplacementError) {
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
          appBar: CustomAppBar(
            title: "Emploi du temps",
            showProfileSection: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeightSpace(33),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildYearDropdown(),
                            const SizedBox(width: 12),
                            _buildModeButton('Normal', EmploiMode.normal),
                            const SizedBox(width: 12),
                            _buildModeButton('Examen', EmploiMode.examen),
                            const SizedBox(width: 12),
                            _buildModeButton(
                              'Remplacement',
                              EmploiMode.remplacement,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [_buildImportSection()],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                BlocBuilder<EmploiCubit, EmploiState>(
                  builder: (context, state) {
                    // ── LOADING ──────────────────────────────
                    if (state is EmploiNormalLoadingState ||
                        state is EmploiExamenLoadingState ||
                        state is EmploiRemplacementLoadingState) {
                      return const _EmploiShimmer();
                    }
                    // ── ERRORS ───────────────────────────────
                    if (state is EmploiNormalErrorState) {
                      return _ErrorState(message: state.error, onRetry: _load);
                    }
                    if (state is EmploiExamenErrorState) {
                      return _ErrorState(message: state.error, onRetry: _load);
                    }
                    if (state is EmploiRemplacementErrorState) {
                      return _ErrorState(message: state.error, onRetry: _load);
                    }
                    // ── NORMAL SUCCESS ────────────────────────
                    if (state is EmploiNormalSuccessState) {
                      final rows = _buildTimeRows(state.emploi.schedule);
                      if (rows.isEmpty) {
                        return _buildEmptyState(
                          'Aucun emploi du temps disponible',
                        );
                      }
                      return _buildNormalSchedule(rows);
                    }
                    // ── EXAM SUCCESS ──────────────────────────
                    if (state is EmploiExamenSuccessState) {
                      final entries = _buildExamEntries(state.examens);
                      if (entries.isEmpty) {
                        return _buildEmptyState('Aucun examen disponible');
                      }
                      return _buildExamSchedule(entries);
                    }
                    // ── REMPLACEMENT SUCCESS ──────────────────
                    if (state is EmploiRemplacementSuccessState) {
                      if (state.remplacements.isEmpty) {
                        return _buildEmptyState(
                          'Aucun remplacement disponible',
                        );
                      }

                      final entries = _buildRemplacementEntries(
                        state.remplacements,
                      );
                      return _buildExamSchedule(entries);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── CONTROLS ──────────────────────────────────────────────────────────────
  Widget _buildYearDropdown() {
    return Container(
      width: 219.w,
      height: 70.h,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFE4EEFA),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xff06A1F1), width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedYear,
          dropdownColor: const Color(0xFFF0F4FF),
          focusColor: Colors.transparent,
          icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 20.sp),
          style: AppStyles.black25w500.copyWith(
            color: const Color(0xFF7B7B7B),
            fontSize: 16.sp,
          ),
          onChanged: (v) {
            if (v == null) return;
            setState(() => _selectedYear = v);
            _load(); // reload when year changes
          },
          items: _years
              .map((y) => DropdownMenuItem(value: y, child: Text(y)))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, EmploiMode mode) {
    final isSelected = _mode == mode;
    return GestureDetector(
      onTap: () {
        setState(() => _mode = mode);
        _load(); // reload when mode changes
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 70.h,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff06A1F1) : Color(0xFFE4EEFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xff06A1F1), width: 1.w),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _blue.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : const Color(0xff7B7B7B),
              fontSize: 16.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ── NORMAL SCHEDULE ──────────────────────────────────────────────────────

  Widget _buildNormalSchedule(List<TimeRow> rows) {
    final double timeColWidth = 80.0.w;
    final double minDayColWidth = 130.0.w;
    final double minTotalWidth = timeColWidth + kDays.length * minDayColWidth;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final useMinWidth = availableWidth < minTotalWidth;
          final tableWidth = useMinWidth ? minTotalWidth : availableWidth;
          final dayColWidth = (tableWidth - timeColWidth) / kDays.length;

          final table = Table(
            columnWidths: {
              0: FixedColumnWidth(timeColWidth),
              for (int i = 1; i <= kDays.length; i++)
                i: FixedColumnWidth(dayColWidth),
            },
            border: TableBorder(
              horizontalInside: BorderSide(color: _borderColor, width: 1),
              verticalInside: BorderSide(color: _borderColor, width: 1),
              bottom: BorderSide(color: _borderColor, width: 1),
              right: BorderSide(color: _borderColor, width: 1),
              left: BorderSide(color: _borderColor, width: 1),
              top: BorderSide(color: _borderColor, width: 1),
            ),
            children: [
              _buildHeaderRow(),
              ...rows.asMap().entries.map(
                (e) => _buildDataRow(e.value, e.key.isOdd),
              ),
            ],
          );

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: useMinWidth
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(width: tableWidth, child: table),
                    )
                  : table,
            ),
          );
        },
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFE4EEFA)),
      children: [_headerCell(''), ...kDays.map((d) => _headerCell(d))],
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: const Color(0xff213656),
          fontWeight: FontWeight.w800,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  TableRow _buildDataRow(TimeRow row, bool isAlt) {
    return TableRow(
      decoration: BoxDecoration(color: isAlt ? _rowAlt : Colors.white),
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 2.w),
          alignment: Alignment.center,
          child: Text(
            row.timeRange,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: const Color(0xff213656),
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
        ),
        ...kDays.map((day) {
          final slots = row.daySlots[day] ?? [];
          return Padding(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: slots.map((s) => _buildSlotCard(s)).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSlotCard(CourseSlot slot) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: const Color(0xff123A7A).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            slot.subject,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          if (slot.teacher.isNotEmpty)
            Text(
              slot.teacher,
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.9),
              ),
            ),
          Text(
            slot.specialite != null && slot.specialite!.isNotEmpty
                ? '${slot.room} - ${slot.specialite}'
                : slot.room,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // ── EXAM / REMPLACEMENT SCHEDULE ──────────────────────────────────────────
  Widget _buildExamSchedule(List<ExamEntry> entries) {
    final Map<String, List<ExamEntry>> grouped = <String, List<ExamEntry>>{};
    for (final e in entries) {
      grouped.putIfAbsent(e.date, () => []).add(e);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: _borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // header row
            Container(
              color: const Color(0xFFE4EEFA),
              child: Row(
                children: [
                  _examHeaderCell('Date', flex: 3),
                  _examHeaderCell('Salle', flex: 2),
                  _examHeaderCell('Horaire', flex: 2),
                  _examHeaderCell('Matière', flex: 3),
                  _examHeaderCell('Responsable', flex: 3),
                  _examHeaderCell('Surveillant', flex: 3),
                ],
              ),
            ),
            ...grouped.entries.toList().asMap().entries.map((mapEntry) {
              final groupIndex = mapEntry.key;
              final date = mapEntry.value.key;
              final groupEntries = mapEntry.value.value;
              return _buildExamGroup(date, groupEntries, groupIndex.isEven);
            }),
          ],
        ),
      ),
    );
  }

  Widget _examHeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: const Color(0xff213656),
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildExamGroup(
    String date,
    List<ExamEntry> entries,
    bool isEvenGroup,
  ) {
    return Column(
      children: entries.asMap().entries.map((e) {
        final idx = e.key;
        final entry = e.value;
        final isFirst = idx == 0;
        final totalRows = entries.length;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: _borderColor, width: 0.8.w),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isFirst)
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: totalRows > 1 ? 0 : 14,
                      ),
                      child: Text(
                        date,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: const Color(0xff213656),
                          fontWeight: FontWeight.w800,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  )
                else
                  const Expanded(flex: 3, child: SizedBox()),
                _examDataCell(entry.salle, flex: 2),
                _examDataCell(entry.horaire, flex: 2),
                _examDataCell(entry.matiere, flex: 3, bold: true),
                _examDataCell(entry.responsable, flex: 3),
                _examDataCell(entry.surveillant, flex: 3),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _examDataCell(String text, {required int flex, bool bold = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(color: _borderColor, width: 0.8)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black.withOpacity(0.9),
          ),
        ),
      ),
    );
  }

  Widget _buildImportSection() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE4EEFA),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xff06A1F1), width: 1.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(14.r),
              onTap: () => setState(() => _importExpanded = !_importExpanded),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: const Color(0xff06A1F1),
                      size: 20.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Importer fichier d'emploi",
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7B7B7B),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      _importExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xff06A1F1),
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),

            if (_importExpanded) ...[
              Divider(
                height: 1,
                thickness: 1,
                color: const Color(0xff06A1F1).withOpacity(0.3),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Normal ──
                    BlocBuilder<ImportEmploiCubit, ImportEmploiState>(
                      builder: (context, state) {
                        final isLoading = state is ImportEmploiLoading;
                        return _buildImportSubButton(
                          label: 'Normal',
                          isLoading: isLoading,
                          onPressed: _onImporterEmploi,
                        );
                      },
                    ),
                    SizedBox(width: 12.w),
                    // ── Examens EMD ──
                    BlocBuilder<ImportExamenCubit, ImportExamenState>(
                      builder: (context, state) {
                        final isLoading = state is ImportExamenEmdLoading;
                        return _buildImportSubButton(
                          label: 'Examens',
                          isLoading: isLoading,
                          onPressed: _onImporterExamenEmd,
                        );
                      },
                    ),
                    SizedBox(width: 12.w),
                    // ── Remplacement ──
                    BlocBuilder<ImportExamenCubit, ImportExamenState>(
                      builder: (context, state) {
                        final isLoading =
                            state is ImportExamenRemplacementLoading;
                        return _buildImportSubButton(
                          label: 'Remplacement',
                          isLoading: isLoading,
                          onPressed: _onImporterExamenRemplacement,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImportSubButton({
    required String label,
    required bool isLoading,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: isLoading
              ? const Color(0xff06A1F1).withOpacity(0.15)
              : const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: const Color(0xff06A1F1).withOpacity(0.5),
            width: 1.w,
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: const Color(0xff06A1F1),
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7B7B7B),
                  ),
                ),
        ),
      ),
    );
  }

  // ── EMPTY STATE ───────────────────────────────────────────────────────────

  Widget _buildEmptyState(String message) {
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHIMMER
// ─────────────────────────────────────────────

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    // ignore: unused_element_parameter
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

class _EmploiShimmer extends StatelessWidget {
  const _EmploiShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // header shimmer
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              color: const Color(0xFFE4EEFA),
              child: Row(
                children: [
                  _ShimmerBox(width: 150.w, height: 28.h),
                  SizedBox(width: 40.w),
                  ...List.generate(
                    5,
                    (_) => Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: _ShimmerBox(width: 100.w, height: 18.h),
                    ),
                  ),
                ],
              ),
            ),
            // row shimmers
            ...List.generate(
              6,
              (i) => Container(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: i.isEven ? Colors.white : const Color(0xFFF5F8FF),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 0.8),
                  ),
                ),
                child: Row(
                  children: [
                    _ShimmerBox(width: 150.w, height: 24.h),
                    SizedBox(width: 20.w),
                    ...List.generate(
                      5,
                      (_) => Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ShimmerBox(width: 150.w, height: 22.h),
                            SizedBox(height: 8.h),
                            _ShimmerBox(width: 130.w, height: 20.h),
                            SizedBox(height: 8.h),
                            _ShimmerBox(width: 120.w, height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ERROR STATE
// ─────────────────────────────────────────────

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
