import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import '../models/planning_models.dart';

class PlanningTable extends StatelessWidget {
  final NormalPlanning planning;
  final String niveau;

  const PlanningTable({
    super.key,
    required this.planning,
    required this.niveau,
  });

  @override
  Widget build(BuildContext context) {
    final niveauData = planning.emploiDuTemps?.niveaux?[niveau];
    if (niveauData == null) {
      return const Center(child: Text(""));
    }

    final heures = <String>{};
    final Map<String, Map<String, List<Map<String, dynamic>>>> grouped = {};

    // Ordre fixe des jours
    final ordreJours = [
      "Samedi",
      "Dimanche",
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
    ];
    final jours = <String>{};

    // Groupage des seances
    niveauData.specialites?.forEach((specName, spec) {
      spec.jours?.forEach((jour, seances) {
        jours.add(jour);
        for (var s in seances) {
          final h = _formatHeure(s.heureDebut, s.heureFin);
          heures.add(h);

          grouped.putIfAbsent(jour, () => {});
          grouped[jour]!.putIfAbsent(h, () => []);
          grouped[jour]![h]!.add({"seance": s, "specialite": specName});
        }
      });
    });

    final joursList = ordreJours.where((j) => jours.contains(j)).toList();
    final heuresList = heures.toList()..sort();

    return SingleChildScrollView(
      child: Table(
        border: TableBorder.all(
          color: const Color(0xff123A7A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        columnWidths: {0: FixedColumnWidth(120.w)},
        children: [
          // Header
          TableRow(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r),
              ),
              color: Color(0xffDBEDFF),
            ),
            children: [_cell(""), ...joursList.map((j) => _headerCell(j))],
          ),
          // Rows
          ...heuresList.map((h) {
            return TableRow(
              decoration: BoxDecoration(color: const Color(0xffe3edf8)),
              children: [
                _cell(h),
                ...joursList.map((jour) {
                  final items = grouped[jour]?[h] ?? [];
                  if (items.isEmpty) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: _buildCell(items),
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCell(List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(items.length, (index) {
        final item = items[index];
        final Seance s = item["seance"];
        final String specialite = item["specialite"] ?? "";
        final prof = '${s.professeur?.nom ?? ''} ${s.professeur?.prenom ?? ''}'
            .trim();
        final salle = s.salle ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                s.matiere?.nomMatiere ?? '',
                style: AppStyles.blackpetit,
              ),
            ),
            Center(child: Text("$prof - $salle", style: AppStyles.blackpetit)),
            if (s.groupe != null && s.groupe!.isNotEmpty)
              Center(
                child: Text(
                  s.groupe!.map((g) => 'G$g').join(', '),
                  style: AppStyles.blackpetit,
                ),
              ),
            if (planning.agent?.cycleResponsable?.toLowerCase().contains(
                      'preparatoire',
                    ) !=
                    true &&
                specialite.isNotEmpty)
              Center(
                child: Text(
                  specialite,
                  style: AppStyles.blackpetit.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            // Divider entre les matières si plusieurs
            if (items.length > 1 && index != items.length - 1)
              const Divider(color: Color(0xff123A7A), thickness: 1),
          ],
        );
      }),
    );
  }

  String _formatHeure(DateTime? debut, DateTime? fin) {
    if (debut == null || fin == null) return "";
    return '${debut.hour.toString().padLeft(2, '0')}:${debut.minute.toString().padLeft(2, '0')} - '
        '${fin.hour.toString().padLeft(2, '0')}:${fin.minute.toString().padLeft(2, '0')}';
  }
}

Widget _headerCell(String text) => Padding(
  padding: const EdgeInsets.all(8),
  child: Center(
    child: Text(
      text,
      style: AppStyles.blueDBw800.copyWith(color: const Color(0xff213656)),
    ),
  ),
);

Widget _cell(String text) => Padding(
  padding: const EdgeInsets.all(8),
  child: Center(child: Text(text, style: AppStyles.blackpetit)),
);
