import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/features/planning/models/planning_models.dart';

class ExamTable extends StatelessWidget {
  final ExamPlanning examPlanning;

  const ExamTable({super.key, required this.examPlanning});

  @override
  Widget build(BuildContext context) {
    DateTime parseDate(String date) {
      final parts = date.split('/');

      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }

    final niveaux = examPlanning.examens?.niveaux;

    if (niveaux == null || niveaux.isEmpty) {
      return const Center(child: Text(""));
    }

    final Map<String, Map<String, Map<String, List<Examen>>>> grouped = {};

    for (var niveauEntry in niveaux.entries) {
      final niveau = niveauEntry.key;
      final specialites = niveauEntry.value.specialites;

      if (specialites == null) continue;

      for (var specEntry in specialites.entries) {
        final examensList = specEntry.value;

        for (var e in examensList) {
          final date = _formatDate(e.date);
          final horaire = _formatHeure(e.heureDebut, e.heureFin);

          grouped.putIfAbsent(date, () => {});
          grouped[date]!.putIfAbsent(horaire, () => {});
          grouped[date]![horaire]!.putIfAbsent(niveau, () => []);
          grouped[date]![horaire]![niveau]!.add(e);
        }
      }
    }

    if (niveaux.isEmpty) {
      return const Center(child: Text(""));
    }

    final sortedDates = grouped.entries.toList()
      ..sort((a, b) {
        return parseDate(a.key).compareTo(parseDate(b.key));
      });

    List<TableRow> rows = [];

    for (var dateEntry in sortedDates) {
      final date = dateEntry.key;
      final horairesMap = dateEntry.value;

      bool firstDate = true;

      horairesMap.forEach((horaire, promoMap) {
        bool firstHoraire = true;

        promoMap.forEach((promo, exams) {
          rows.add(
            TableRow(
              decoration: const BoxDecoration(color: Color(0xffe3edf8)),
              children: [
                _cell(firstDate ? date : ""),
                _cell(firstHoraire ? horaire : ""),
                _cell(promo),

                if (examPlanning.agent?.cycleResponsable
                        ?.toLowerCase()
                        .contains('preparatoire') !=
                    true)
                  _buildCell(exams, (e) => e.specialite ?? ''),

                _buildCell(exams, (e) => e.matiere?.nomMatiere ?? ''),
                _buildCell(exams, (e) => e.salle ?? ''),

                _buildCell(exams, (e) => (e.surveillances ?? []).join(', ')),
              ],
            ),
          );

          firstDate = false;
          firstHoraire = false;
        });
      });
    }

    return SingleChildScrollView(
      child: Table(
        border: TableBorder.all(
          color: const Color(0xff123A7A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        columnWidths: {
          0: FixedColumnWidth(120.w),
          1: FixedColumnWidth(120.w),
          2: FixedColumnWidth(80.w),
          3: FixedColumnWidth(150.w),
          4: FixedColumnWidth(200.w),
          5: FixedColumnWidth(150.w),
          6: FixedColumnWidth(200.w),
        },
        children: [
          /// HEADER (inchangé)
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r),
              ),
              color: const Color(0xffDBEDFF),
            ),
            children: [
              _headerCell("Date"),
              _headerCell("Horaire"),
              _headerCell("Promo"),
              if (examPlanning.agent?.cycleResponsable?.toLowerCase().contains(
                    'preparatoire',
                  ) !=
                  true)
                _headerCell("Spécialité"),
              _headerCell("Matière"),
              _headerCell("Salle"),
              _headerCell("Surveillance"),
            ],
          ),

          /// DATA
          ...rows,
        ],
      ),
    );
  }

  Widget _buildCell(List<Examen> list, String Function(Examen e) selector) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: List.generate(list.length, (i) {
          return Column(
            children: [
              Text(selector(list[i]), style: AppStyles.blackpetit),
              if (i != list.length - 1) const Divider(color: Color(0xff123A7A)),
            ],
          );
        }),
      ),
    );
  }

  String _formatHeure(DateTime? d, DateTime? f) {
    if (d == null || f == null) return "";
    return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} - '
        '${f.hour.toString().padLeft(2, '0')}:${f.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// HEADER CELL (inchangé)
Widget _headerCell(String text) => Padding(
  padding: EdgeInsets.all(10.w),
  child: Center(
    child: Text(
      text,
      style: AppStyles.blueDBw800.copyWith(color: Color(0xff213656)),
    ),
  ),
);

/// DATA CELL (inchangé)
Widget _cell(String text) => Padding(
  padding: EdgeInsets.all(10.w),
  child: Center(child: Text(text, style: AppStyles.blackpetit)),
);
