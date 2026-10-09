class ExamenModel {
  final String matiere;
  final String horaire;
  final String salle;
  final String type;
  final String specialite;
  final List<String> responsables;
  final List<String> surveillants;

  const ExamenModel({
    required this.matiere,
    required this.horaire,
    required this.salle,
    required this.type,
    required this.specialite,
    required this.responsables,
    required this.surveillants,
  });

  static String _extractNom(dynamic item) {
    if (item is String) return item;
    if (item is Map) {
      return item['fullName'] as String? ??
          item['full_name'] as String? ??
          item['fullname'] as String? ??
          item['nom'] as String? ??
          item['name'] as String? ??
          item['prenom'] as String? ??
          item.values.whereType<String>().firstOrNull ??
          item.toString();
    }
    return item.toString();
  }

  factory ExamenModel.fromJson(Map<String, dynamic> json) {
    return ExamenModel(
      matiere: json['matiere'] as String? ?? '',
      horaire: json['horaire'] as String? ?? '',
      salle: json['salle'] as String? ?? '',
      type: json['type'] as String? ?? '',
      specialite: json['specialite'] as String? ?? '',
      responsables: (json['responsables'] as List? ?? [])
          .map((e) => _extractNom(e))
          .toList(),
      surveillants: (json['surveillants'] as List? ?? [])
          .map((e) => _extractNom(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'matiere': matiere,
    'horaire': horaire,
    'salle': salle,
    'type': type,
    'specialite': specialite,
    'responsables': responsables,
    'surveillants': surveillants,
  };
}

class EmploiExamenModel {
  
  final Map<String, List<ExamenModel>> examens;

  const EmploiExamenModel({required this.examens});

  factory EmploiExamenModel.fromJson(Map<String, dynamic> json) {
    final map = <String, List<ExamenModel>>{};
    json.forEach((date, slots) {
      // ── Fix : virgule → T pour que DateTime.parse fonctionne ──
      final cleanDate = date.replaceFirst(',', 'T');
      map[cleanDate] = (slots as List)
          .map((s) => ExamenModel.fromJson(s as Map<String, dynamic>))
          .toList();
    });
    return EmploiExamenModel(examens: map);
  }

  static String formatDateKey(String isoKey) {
    try {
      final cleaned = isoKey.replaceFirst(',', 'T');
      final dt = DateTime.parse(cleaned);
      const jours = [
        'Lundi',
        'Mardi',
        'Mercredi',
        'Jeudi',
        'Vendredi',
        'Samedi',
        'Dimanche',
      ];
      final jourLabel = jours[dt.weekday - 1];
      final dd = dt.day.toString().padLeft(2, '0');
      final mm = dt.month.toString().padLeft(2, '0');
      final yyyy = dt.year.toString();
      return '$jourLabel $dd/$mm/$yyyy';
    } catch (_) {
      return isoKey;
    }
  }

  bool get isEmpty => examens.isEmpty;
}
